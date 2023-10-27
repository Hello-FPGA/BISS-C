 ECHO parameter 1 is the name of project tcl file
@SET vivado_path=C:\Xilinx\Vivado\2019.1
@SET vivado=%vivado_path%\bin\vivado.bat

if [%1] == [] (
  SET vivadoprj=biss
) else (
  SET vivadoprj=%1%
)
SET prjscript=prj_%vivadoprj%.tcl

@ECHO OFF
if exist %vivado% (
  if exist %prjscript% (
    start %vivado% -source build_project.tcl
  ) else (
    ECHO %prjscript% was not found.
  )
) else (
  ECHO.
  ECHO ###############################
  ECHO ### Failed to locate Vivado ###
  ECHO ###############################
  ECHO.
  ECHO This batch file "%~n0.bat" did not find Vivado installed in:
  ECHO.
  ECHO     %vivado%
  ECHO.
  ECHO Fix the problem by doing one of the following:
  ECHO.
  ECHO  1. If you do not have this version of Vivado installed,
  ECHO     please install it or download the project sources from
  ECHO     a commit of the Git repository that was intended for
  ECHO     your version of Vivado.
  ECHO.
  ECHO  2. If Vivado is installed in a different location on your
  ECHO     PC, please modify the first line of this batch file 
  ECHO     to specify the correct location.
  ECHO.
  pause
)
