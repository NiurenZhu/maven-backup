@echo off
setlocal EnableDelayedExpansion
echo ***************************************************************************
echo      deploy_packages.bat
echo                     by niuren.zhu
echo                           2017.09.06
echo  说明：
echo     1. 上传jar包到maven仓库。
echo     2. 添加PATH变量到%%MAVEN_HOME%%\bin，并检查JAVA_HOME配置是否正确。
echo     3. 在setting.xml的^<servers^>节点下添加（其中用户名与密码需要向管理员申请）
echo             ^<server^>
echo               ^<id^>ibas-maven^<^/id^>
echo               ^<username^>用户名^<^/username^>
echo               ^<password^>密码^<^/password^>
echo             ^<^/server^>
echo ****************************************************************************
REM 设置参数变量
SET WORK_FOLDER=%~dp0
REM 仓库根地址
SET ROOT_URL=http://maven.colorcoding.org/repository/

echo --开始部署
CALL :DEPLOY_PACKAGE com.sap.b1 sbowrapper 9.2 %WORK_FOLDER%\sbowrapper.jar maven-3rdparty
CALL :DEPLOY_PACKAGE com.sap.b1 sboapi 9.2 %WORK_FOLDER%\sboapi.jar maven-3rdparty


echo --操作完成

goto :EOF
REM 以下为函数
:DEPLOY_PACKAGE
set GROUP_ID=%1
set ARTIFACT_ID=%2
set VERSION=%3
set FILE=%4
set REPOSITORY=%5
set PACKAGING=jar
set REPOSITORY_ID=ibas-maven
set REPOSITORY_URL=%ROOT_URL%%REPOSITORY%

call mvn deploy:deploy-file ^
    -DgroupId=%GROUP_ID% ^
    -DartifactId=%ARTIFACT_ID% ^
    -Dversion=%VERSION% ^
    -Dpackaging=%PACKAGING% ^
    -Dfile="%FILE%" ^
    -Durl=%REPOSITORY_URL% ^
    -DrepositoryId=%REPOSITORY_ID%
goto :EOF