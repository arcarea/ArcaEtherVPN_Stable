SETLOCAL
SET BATCH_FILE_NAME=%0
SET BATCH_DIR_NAME=%~dp0

for /f "usebackq tokens=*" %%i in (`"%BATCH_DIR_NAME%\BuildFiles\Utility\vswhere.exe" -version [16.0^,17.0^) -sort -requires Microsoft.Component.MSBuild -find Common7\Tools\VsDevCmd.bat`) do (
    if exist "%%i" (
        call "%%i"
    )
)

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
