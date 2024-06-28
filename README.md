## Инструкция по использованию скрипта PowerShell для создания самоподписного сертификата разработчика

### Требования

 PowerShell 5.1 или выше
 Файл конфигурации INI с параметрами сертификата

### Файл конфигурации INI

Файл конфигурации INI должен содержать следующие параметры:

- `Subject = CN=SigningCertificate`
- `KeyUsage = DigitalSignature`
- `KeyAlgorithm = RSA`
- `KeyLength = 4096`
- `NotAfter = +3 year`
- `KeyNameNewCert = Test_CodeSign`

#### Пояснение по параматерам в файле INI

 - `subject`: Имя субъекта сертификата (например, "CN=YourSubjectName, C=YourCountry").
 - `keyUsage`: Использование ключа сертификата (для подписи кода значение должно быть !!!ТОЛЬКО!!!, "DigitalSignature").
 - `keyAlgorithm`: Алгоритм ключа сертификата (например, "RSA").
 - `keyLength`: Длина ключа сертификата (например, "2048").
 - `keyNameNewCert`: Имя нового сертификата (например, "YourKeyName").

### Использование скрипта

1. Откройте PowerShell от имени администратора.
2. Перейдите в каталог со скриптом и файлом конфигурации INI.
3. Выполните следующую команду:

`Set-ExecutionPolicy RemoteSigned
.\script.ps1`


4. Введите пароль для сертификата, когда будет предложено.
5. Просмотрите параметры сертификата в терминале и нажмите клавишу ввода, чтобы продолжить.
6. Скрипт создаст самоподписной сертификат разработчика и экспортирует его в файл .pfx с именем, указанным в файле конфигурации INI.

### Советы

 Убедитесь, что у вас есть права администратора для выполнения скрипта.
 Убедитесь, что файл INI содержит правильные параметры.
 Храните пароль сертификата в надежном месте.
 Файл .pfx можно использовать для подписи приложений или других целей, требующих подписи с цифровой подписью.

## Подписать скомпилированный файл exe

1. Откройте CommandLine (CMD) от имени администратора.
2. Перейдите в каталог с файлом signtool.exe `cd /d "<путь к папке с программой>"`.
3. Выполните следующую команду:

`signtool sign /f "<полный путь к сертификату разработчика>" /p <пароль на сертификат> /fd SHA256 "<Полный путь к вашему файлу exe>"`
