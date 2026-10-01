$ServiceName = "Velociraptor"
$MsiPath = "C:\Install\velociraptor-v0.77.2-windows-amd64.msi"
$LogPath = "C:\Install\install_log.txt"

Start-Transcript -Path $LogPath -Append

Write-Host "=== Velociraptor Installer ==="
Write-Host "Date: $(Get-Date)"

$service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

if ($service -ne $null) {
	Write-Host "Slushba '$ServiceName' yshe ystanovlena"
	Write-Host "Tek status: $($service.Status)"

	if ($service.Status -ne "Running") {
		Write-Host "Slushba ne zapuchena. Zapuskaem..."
		Start-Service -Name $ServiceName
		Write-Host "Slushba zapushena"
	} else {
		Write-Host "Slushba yshe rabotaet, nichego delat ne nushno"
	}
} else {
	Write-Host "Slushba ne naydena. Ystanavlivaem velociraptor"

	if (-not (Test-Path $MsiPath)) {
		Write-Host "OSHIBKA: MSI-file ne nayden po puti $MsiPath"
		Stop-Transcript
		exit 1
	}
		
	$msiArgs = "/i `"$MsiPath`" /qn /l*v C:\Insttall\msi_install.log"
	$process = Start-Process msiexec.exe -ArgumentList $msiArgs -Wait -PassThru

	if ($process.ExitCode -eq 0) {
		Write-Host "Ystanovka proshla yspeshno"
		Start-Sleep -Seconds 5
		$newService = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
		if ($newService -ne $null) {
			Write-Host "Slushba '$ServiceName' sozdana. Status: $($newService.Status)"
		} else {
			Write-Host "MSI ystanovlen, no slushba ne naydena"
		}
	} else {
		Write-Host "OSHIBKA: MSI vernul kod $($process.ExitCode). Smotrite C:\Install\msi_install.log"
	}
}

Write-Host "=== Gotovo ==="
Stop-Transcript