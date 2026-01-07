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

Write-Host "Connected to $Server:$Port"

$banner = $reader.ReadLine()
Write-Host "S: $banner"

$writer.WriteLine("EHLO $EhloName")

while ($true) {
    try {
        $line = $reader.ReadLine()
        if (-not $line) { break }
        Write-Host "S: $line"
        if ($line -match '^250 ') { break }
    } catch {
        break
    }
}

$writer.WriteLine("QUIT")
$client.Close()
