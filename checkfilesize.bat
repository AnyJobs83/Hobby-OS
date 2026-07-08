@echo off

if %~1 == "" (
    echo checkfilesize.bat ERROR: No file specified
    exit /b 1
)

if %~2 == "" (
    echo checkfilesize.batERROR: No maximum size specified
    exit /b 1
)

if not exist %~1 (
    echo checkfilesize.bat ERROR: File does not exist: %~1
    exit /b 1
)

if %~z1 GEQ %2 (
    echo checkfilesize.bat ERROR: %1 exceeds set maximum size of %2 bytes
    exit /b 1
)

exit /b 0