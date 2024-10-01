@echo off
setlocal enabledelayedexpansion

REM Comprovar si es passa l'argument de la ruta
if "%~1"=="" (
    set /p route="Please, enter the full path of the file you want to rename: "
) else (
    set route=%~1
)

REM Depuració: mostrar la ruta del fitxer
echo Route provided: %route%

REM Comprovar si el fitxer existeix
if not exist "%route%" (
    echo Error: File does not exist.
    exit /b 1
)

REM Extreure el nom del fitxer i l'extensió
for %%F in ("%route%") do (
    set name=%%~nxF
    set extension=%%~xF
)

REM Depuració: mostrar el nom i l'extensió del fitxer
echo File name: %name%
echo File extension: %extension%

REM Seleccionar la matèria
:subject
echo Please, choose the subject that the file is related to:
echo 1. FM_Sost
echo 2. TUT
echo 3. GBD
echo 4. ISO
echo 5. PAX
echo 6. LMSGI
set /p subject="Enter a number between 1 and 6: "
if %subject% lss 1 if %subject% gtr 6 (
    echo Invalid selection. Please enter a number between 1 and 6.
    goto subject
)

REM Demanar el número de Resultat Avaluació (RA)
:RA_input
set /p RA="Please enter the Resultat Avaluació number (e.g., 1 for RA1, 2 for RA2): "
if not "%RA%"=="" (
    set RA=RA%RA%
) else (
    echo Invalid input. Please enter a valid number for RA.
    goto RA_input
)

REM Demanar el número d'Activitat (AC)
:AC_input
set /p ac="Please enter the Activity number (e.g., 1 for AC01, 2 for AC02): "
if not "%ac%"=="" (
    if %ac% lss 10 (set ac=AC0%ac%) else (set ac=AC%ac%)
) else (
    echo Invalid input. Please enter a valid number for Activity.
    goto AC_input
)

REM Demanar cognom i nom
set /p lastname="Please enter your last name: "
set /p firstname="Please enter your first name: "

REM Definir els noms de matèries i construir el nou nom
if %subject%==1 (
    set subject_name=MFM_Sost
) else if %subject%==2 (
    set subject_name=MTUT
) else if %subject%==3 (
    set subject_name=MGBD
) else if %subject%==4 (
    set subject_name=MISO
) else if %subject%==5 (
    set subject_name=MPAX
) else if %subject%==6 (
    set subject_name=MLMSGI
)

REM Crear el nou nom del fitxer
set newname=%subject_name%_%RA%_%ac%_%lastname%_%firstname%

REM Afegir l'extensió si existeix
if not "%extension%"=="" (
    set final_name=%newname%%extension%
) else (
    set final_name=%newname%
)

REM Mostrar el nou nom i demanar confirmació
echo The file will be renamed to: %final_name%
set /p confirmation="Do you want to proceed? (y/n): "
if /i not "%confirmation%"=="y" (
    echo Operation cancelled.
    exit /b 1
)

REM Comprovar si el fitxer amb el mateix nom ja existeix
set target_path=%~dp1%final_name%
if exist "%target_path%" (
    echo Warning: A file named %final_name% already exists.
    set /p overwrite="Do you want to overwrite it? (y/n): "
    if /i not "%overwrite%"=="y" (
        echo Operation cancelled.
        exit /b 1
    )
)

REM Renombrar el fitxer
ren "%route%" "%final_name%"
if errorlevel 1 (
    echo Error: Failed to rename the file.
    exit /b 1
)

echo File renamed successfully to %final_name%
exit /b 0
