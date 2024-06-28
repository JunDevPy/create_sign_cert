Set-ExecutionPolicy RemoteSigned
$UserName = $env:USERNAME
Write-Host "Введите пароль для сертификата:"
$password = Read-Host -AsSecureString
$notAfter = Get-Date -Year ((Get-Date).Year + 1)
# Загрузить переменные из файла INI
$ini = Get-Content "$PSScriptRoot\config.ini"
$Obj = [pscustomobject]@{                                                                                                 
         subject     = ($ini | select-string subject) -replace "^.+="
         keyUsage     = ($ini | select-string keyUsage) -replace "^.+="
         # CertLocation     = ($ini | select-string CertLocation) -replace "^.+="
         keyAlgorithm     = ($ini | select-string keyAlgorithm) -replace "^.+="
         keyLength     = ($ini | select-string keyLength) -replace "^.+="
         keyNameNewCert     = ($ini | select-string keyNameNewCert) -replace "^.+="
}
if ($Obj) { $Objects += @($Obj) }
    # Return $Objects>Nul
	# Получаем значение переменной
	$subject = $Obj.subject
	$keyUsage = $Obj.keyUsage
	# $CertLocation = $Obj.CertLocation
	$keyAlgorithm = $Obj.keyAlgorithm
	$keyLength = $Obj.keyLength
	$keyNameNewCert = $Obj.keyNameNewCert

# Вывести переменные в терминал
Write-Host "Конфиг файл: $ini"
Write-Host "subject: $subject"
Write-Host "keyUsage: $keyUsage"
# Write-Host "CertLocation: $CertLocation"
Write-Host "keyAlgorithm: $keyAlgorithm"
Write-Host "keyLength: $keyLength"
Write-Host "keyNameNewCert: $keyNameNewCert"
Write-Host "notAfter: $notAfter"
Write-Host "UserName: $UserName"
Write-Host "password: $password"

# Приостановить выполнение скрипта до тех пор, пока пользователь не нажмет клавишу
Read-Host "Нажмите клавишу <ENTER>, чтобы продолжить..."

Write-Host "--- Cоздание самоподписного сертификата разработчика... ---"

$certificate = New-SelfSignedCertificate -Type Custom -Subject "CN=$subject, C=RU" -KeyUsage $keyUsage -FriendlyName "$keyNameNewCert" -CertStoreLocation "Cert:\CurrentUser\My" -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.3", "2.5.29.19={text}")

Write-Host "--- Cоздание самоподписного сертификата разработчика ЗАВЕРШЕНО ---"

# Экспортировать сертификат в файл .pfx
Write-Host "--- Экспорт сертификата в pfx файл  ---"

$certificate.Export("Pfx", $password) | Set-Content "$PSScriptRoot\$keyNameNewCert.pfx" -Encoding Byte
$Acl = Get-Acl "$PSScriptRoot\$keyNameNewCert.pfx"
$Acl.SetAccessRule((New-Object System.Security.AccessControl.FileSystemAccessRule($UserName, "FullControl", "Allow")))
Set-Acl -Path "$PSScriptRoot\$keyNameNewCert.pfx" -AclObject $Acl

Write-Host "--- Экспорт сертификата в pfx файл ЗАВЕРШЕН ---"

# # Импортировать сертификат из файла PFX в хранилище Cert:\CurrentUser\Root
# Import-PfxCertificate -FilePath "$PSScriptRoot\$keyNameNewCert.pfx" -CertStoreLocation "Cert:\CurrentUser\Root" -Password (Read-Host "Введите пароль для сертификата:")
