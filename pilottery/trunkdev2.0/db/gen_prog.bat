@echo off
set SRC_DIR=%~dp0
set KWS_DEST_FILE=%SRC_DIR%\run_scripts\11-kws-prog.sql

rem 设置字符集为UTF8
chcp 65001

echo set feedback off > %KWS_DEST_FILE%

rem ###########################################################################
rem ##############################  建立 【PACKAGE】 对象 ##########################
rem ###########################################################################

echo 建立KWS用户对象 ... [PACKAGE]

for /F "tokens=*" %%s in ('dir /b %SRC_DIR%\KWS\PACKAGE\*.sql') do (
  echo prompt 正在建立[PACKAGE -^> %%s ]...... >> %KWS_DEST_FILE%
  type %SRC_DIR%\KWS\PACKAGE\%%s >> %KWS_DEST_FILE%
  echo. >> %KWS_DEST_FILE%
  echo / >> %KWS_DEST_FILE%
)

rem ###########################################################################
rem ##############################  建立 【FUNCTION】 对象 ##########################
rem ###########################################################################

echo 建立KWS用户对象 ... [FUNCTION]

for /F "tokens=*" %%s in ('dir /b %SRC_DIR%\KWS\FUNCTION\*.sql') do (
  echo prompt 正在建立[FUNCTION -^> %%s ]...... >> %KWS_DEST_FILE%
  type %SRC_DIR%\KWS\FUNCTION\%%s >> %KWS_DEST_FILE%
  echo. >> %KWS_DEST_FILE%
  echo / >> %KWS_DEST_FILE%
)

rem ###########################################################################
rem ##############################  建立 【PROCEDURE】 对象 ##########################
rem ###########################################################################

echo 建立KWS用户对象 ... [PROCEDURE]

for /F "tokens=*" %%s in ('dir /b %SRC_DIR%\KWS\PROCEDURE\*.sql') do (
  echo prompt 正在建立[PROCEDURE -^> %%s ]...... >> %KWS_DEST_FILE%
  type %SRC_DIR%\KWS\PROCEDURE\%%s >> %KWS_DEST_FILE%
  echo. >> %KWS_DEST_FILE%
  echo / >> %KWS_DEST_FILE%
)

rem ###########################################################################
rem ##############################  建立 【TRIGGER】 对象 ##########################
rem ###########################################################################

echo 建立KWS用户对象 ... [TRIGGER]

for /F "tokens=*" %%s in ('dir /b %SRC_DIR%\KWS\TRIGGER\*.sql') do (
  echo prompt 正在建立[TRIGGER -^> %%s ]...... >> %KWS_DEST_FILE%
  type %SRC_DIR%\KWS\TRIGGER\%%s >> %KWS_DEST_FILE%
  echo. >> %KWS_DEST_FILE%
  echo / >> %KWS_DEST_FILE%
)

rem ###########################################################################
rem ##############################  建立 【VIEW】 对象 ##########################
rem ###########################################################################

echo 建立KWS用户对象 ... [VIEW]
echo prompt 正在建立视图view ...... 01_create_view_kws.sql >> %KWS_DEST_FILE%
type %SRC_DIR%\KWS\view\01_create_view_kws.sql >> %KWS_DEST_FILE%

echo prompt 正在建立视图view ...... 02_create_view_taishan.sql >> %KWS_DEST_FILE%
type %SRC_DIR%\KWS\view\02_create_view_taishan.sql >> %KWS_DEST_FILE%

echo 添加结束符号
echo. >> %KWS_DEST_FILE%
echo exit; >> %KWS_DEST_FILE%

pause
