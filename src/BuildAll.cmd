SETLOCAL
SET BATCH_FILE_NAME=%0
SET BATCH_DIR_NAME=%~dp0

cd "C:\Program Files (x86)\Microsoft Visual Studio\Installer"
for /f "usebackq tokens=*" %%A IN (`vswhere -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) DO @set vcdir=%%A
"%vcdir%\VC\Auxiliary\Build\vcvarsall.bat" x86_amd64

echo on


cd /d "%BATCH_DIR_NAME%

msbuild /target:Clean /property:Configuration=Release /property:Platform=x86 SEVPN.sln
IF ERRORLEVEL 1 GOTO LABEL_ERROR

msbuild /target:Rebuild /maxcpucount:8 /property:Configuration=Release /property:Platform=x86 SEVPN.sln
IF ERRORLEVEL 1 GOTO LABEL_ERROR

msbuild /target:Clean /property:Configuration=Release /property:Platform=x64 SEVPN.sln
IF ERRORLEVEL 1 GOTO LABEL_ERROR

msbuild /target:Rebuild /maxcpucount:8 /property:Configuration=Release /property:Platform=x64 SEVPN.sln
IF ERRORLEVEL 1 GOTO LABEL_ERROR

"%BATCH_DIR_NAME%\bin\BuildUtil.exe" /CMD:All
IF ERRORLEVEL 1 GOTO LABEL_ERROR

:LABEL_ERROR
EXIT %ERRORLEVEL%
