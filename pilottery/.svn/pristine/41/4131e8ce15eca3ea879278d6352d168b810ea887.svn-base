@echo off
set SRC_DIR=%~dp0
set KWS_DEST_FILE=%SRC_DIR%\run_scripts\10-kws.sql
rem set MIS_DEST_FILE=%SRC_DIR%\run_scripts\mis_all.sql
rem set DATA_DEST_FILE=%SRC_DIR%\init_data.sql

rem 设置字符集为UTF8
chcp 65001

rem echo start %SRC_DIR%\json_v1_0_5\install.sql; > %KWS_DEST_FILE%
rem echo. >> %KWS_DEST_FILE%

echo set feedback off > %KWS_DEST_FILE%

rem ###########################################################################
rem ##############################  建立 【表】 对象 ##########################
rem ###########################################################################

echo 建立KWS用户对象 ... [TABLE]

for /F "tokens=*" %%s in ('dir /b %SRC_DIR%\KWS\TABLES\*.sql') do (
  echo prompt 正在建立[TABLES -^> %%s ]...... >> %KWS_DEST_FILE%
  type %SRC_DIR%\KWS\TABLES\%%s >> %KWS_DEST_FILE%
  echo. >> %KWS_DEST_FILE%
)

rem ###########################################################################
rem ##############################  建立 【零碎】 对象 ##########################
rem ###########################################################################

echo 建立用户对象 ... [SEQUENCE]
echo prompt 正在建立[SEQUENCE]...... >> %KWS_DEST_FILE%
for /F "tokens=*" %%s in ('dir /b %SRC_DIR%\KWS\SEQUENCE\*.sql') do (
  echo prompt 正在建立[SEQUENCE -^> %%s ]...... >> %KWS_DEST_FILE%
  type %SRC_DIR%\KWS\SEQUENCE\%%s >> %KWS_DEST_FILE%
  echo. >> %KWS_DEST_FILE%
)

echo 建立用户对象 ... [TYPE]
echo prompt 正在建立[TYPE]...... >> %KWS_DEST_FILE%
for /F "tokens=*" %%s in ('dir /b %SRC_DIR%\KWS\TYPE\*.sql') do (
  echo prompt 正在建立[TYPE -^> %%s ]...... >> %KWS_DEST_FILE%
  type %SRC_DIR%\KWS\TYPE\%%s >> %KWS_DEST_FILE%
  echo. >> %KWS_DEST_FILE%
)

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

rem ###########################################################################
rem ##############################  合并 【初始化数据】 脚本 ##################
rem ###########################################################################

rem echo 导入初始化数据脚本 ... [Init Data]
rem for /F "tokens=*" %%s in ('dir /b %SRC_DIR%\KWS\INITData\*.sql') do (
rem   echo prompt 正在导入初始化数据 [INIT DATA -^> %%s ]...... >> %KWS_DEST_FILE%
rem   type %SRC_DIR%\KWS\INITData\%%s >> %KWS_DEST_FILE%
rem   echo. >> %KWS_DEST_FILE%
rem )

echo 添加结束符号
echo. >> %KWS_DEST_FILE%
echo exit; >> %KWS_DEST_FILE%

pause
