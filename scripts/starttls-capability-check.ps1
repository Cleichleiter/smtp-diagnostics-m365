param (
    [Parameter(Mandatory = $true)]
    [string]$Server,

    [int]$Port = 25,

    [string]$EhloName = "smtp-test.local"
)

$client = New-Object System.Net.Sockets.TcpClient
$client.Connect($Server, $Port)

$stream = $client.GetStream()
$stream.ReadTimeout = 8000
$stream.WriteTimeout = 8000

$reader = New-Object System.IO.StreamReader($stream)
$writer = New-Object System.IO.StreamWriter($stream)
$writer.NewLine = "`r`n"
$writer.AutoFlush = $true

$reader.ReadLine() | Out-Null
$writer.WriteLine("EHLO $EhloName")

$ehlo = @()
while ($true) {
    try {
        $line = $reader.ReadLine()
        if (-not $line) { break }
        $ehlo += $line
        if ($line -match '^250 ') { break }
    } catch {
        break
    }
}

$startTls = $ehlo -match 'STARTTLS'

Write-Host "STARTTLS Advertised: $($startTls.Count -gt 0)"

$writer.WriteLine("QUIT")
$client.Close()
