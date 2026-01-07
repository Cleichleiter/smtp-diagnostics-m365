# ==============================
# Script: smtp-starttls-mailfrom-rcptto-test.ps1
# Purpose: Perform a full SMTP conversation test against a server,
#          including EHLO, STARTTLS, MAIL FROM, and RCPT TO.
# Compatibility: PowerShell 5.1+
# ==============================

# ------------------------------
# Configuration
# ------------------------------

$Server   = "nebraskafire-com.mail.protection.outlook.com"
$Port     = 25
$EhloName = "test.example.com"

# Match these to the device configuration being tested
$MailFrom = "sender@domain.com"
$RcptTo   = "recipient@domain.com"

# ------------------------------
# Helper Functions
# ------------------------------

function Read-SmtpResponse {
    param(
        [Parameter(Mandatory=$true)][System.IO.StreamReader]$Reader,
        [int]$TimeoutMs = 8000
    )

    $lines = New-Object System.Collections.Generic.List[string]
    $sw = [System.Diagnostics.Stopwatch]::StartNew()

    while ($sw.ElapsedMilliseconds -lt $TimeoutMs) {
        try {
            $line = $Reader.ReadLine()
            if ($null -eq $line) { break }

            $lines.Add($line)

            # Multiline SMTP responses end when the status code
            # is followed by a space instead of a hyphen.
            if ($line -match '^(?<code>\d{3})(?<sep>[-\s])') {
                if ($Matches['sep'] -eq ' ') { break }
            }
        }
        catch [System.IO.IOException] {
            break
        }
    }

    return ,$lines.ToArray()
}

function Send-SmtpCommand {
    param(
        [Parameter(Mandatory=$true)][System.IO.StreamWriter]$Writer,
        [Parameter(Mandatory=$true)][System.IO.StreamReader]$Reader,
        [string]$Command
    )

    if ($Command) {
        Write-Host "C: $Command"
        $Writer.WriteLine($Command)
    }

    $response = Read-SmtpResponse -Reader $Reader
    foreach ($line in $response) {
        Write-Host "S: $line"
    }

    return ,$response
}

# ------------------------------
# Connection Setup
# ------------------------------

Write-Host ("Connecting to {0}:{1}" -f $Server, $Port)

$tcp = New-Object System.Net.Sockets.TcpClient
$tcp.ReceiveTimeout = 8000
$tcp.SendTimeout    = 8000
$tcp.Connect($Server, $Port)

$net = $tcp.GetStream()
$net.ReadTimeout  = 8000
$net.WriteTimeout = 8000

$reader = New-Object System.IO.StreamReader($net)
$writer = New-Object System.IO.StreamWriter($net)
$writer.NewLine   = "`r`n"
$writer.AutoFlush = $true

# ------------------------------
# SMTP Conversation
# ------------------------------

# Banner
Send-SmtpCommand -Writer $writer -Reader $reader -Command $null | Out-Null

# EHLO
Send-SmtpCommand -Writer $writer -Reader $reader -Command ("EHLO {0}" -f $EhloName) | Out-Null

# STARTTLS
$startTlsResponse = Send-SmtpCommand -Writer $writer -Reader $reader -Command "STARTTLS"

if (($startTlsResponse -join "`n") -notmatch '^220') {
    Write-Host "STARTTLS was not accepted by the server."
    $writer.WriteLine("QUIT")
    $tcp.Close()
    return
}

# ------------------------------
# TLS Upgrade
# ------------------------------

$ssl = New-Object System.Net.Security.SslStream($net, $false, ({ $true }))
$ssl.AuthenticateAsClient($Server)

Write-Host ("TLS Established: {0}" -f $ssl.SslProtocol)

$readerTls = New-Object System.IO.StreamReader($ssl)
$writerTls = New-Object System.IO.StreamWriter($ssl)
$writerTls.NewLine   = "`r`n"
$writerTls.AutoFlush = $true

# EHLO after TLS
Send-SmtpCommand -Writer $writerTls -Reader $readerTls -Command ("EHLO {0}" -f $EhloName) | Out-Null

# MAIL FROM / RCPT TO
Send-SmtpCommand -Writer $writerTls -Reader $readerTls -Command ("MAIL FROM:<{0}>" -f $MailFrom) | Out-Null
Send-SmtpCommand -Writer $writerTls -Reader $readerTls -Command ("RCPT TO:<{0}>"   -f $RcptTo)   | Out-Null

# ------------------------------
# Cleanup
# ------------------------------

Send-SmtpCommand -Writer $writerTls -Reader $readerTls -Command "QUIT" | Out-Null
$tcp.Close()

Write-Host "SMTP conversation test completed."
