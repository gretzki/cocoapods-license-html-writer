# cocoapods-license-html-writer
Turns licence files of embedded cocoapods in single html file.

Execute `swift LicenseWriter.swift` in the root of your iOS/MacOS project and the script creates a LICENSES.html for you. 
It includes licenses of all embedded cocoapods and creates the following structure:

```
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,minimum-scale=1,maximum-scale=1">
</head>

<p class='licenseTitle'>LIZENZ TITEL</p>
<p class='licenseBody'>LOREM IPSUM
...
</p>
</html>
```

Have fun!
