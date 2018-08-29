@echo off
setlocal EnableDelayedExpansion
echo ***************************************************************************
echo      deploy_boe_libraries.bat
echo                     by niuren.zhu
echo                           2017.05.16
echo  说明：
echo     1. 上传boe的jar包到maven仓库。
echo     2. 添加PATH变量到%%MAVEN_HOME%%\bin，并检查JAVA_HOME配置是否正确。
echo     3. 在^<servers^>节点下添加（其中用户名与密码需要向管理员申请）
echo             ^<server^>
echo               ^<id^>ibas-maven^<^/id^>
echo               ^<username^>用户名^<^/username^>
echo               ^<password^>密码^<^/password^>
echo             ^<^/server^>
echo ****************************************************************************
REM 设置参数变量
SET WORK_FOLDER=%~dp0
REM 仓库地址
SET REPOSITORY_URL=http://maven.colorcoding.org/repository/maven-3rdparty
REM 仓库标识
SET REPOSITORY_ID=ibas-maven
REM 组标记
SET GROUP_ID=com.sap.boe
REM 版本
SET VERSION=4.2.2

echo --开始分析目录[%WORK_FOLDER%]
REM 创建pom.dependencies.txt
@echo ^<boe.version^>%VERSION%^<^/boe.version^> >"%WORK_FOLDER%pom.dependencies.txt"
@echo ^>>"%WORK_FOLDER%pom.dependencies.txt"
@echo ^>>"%WORK_FOLDER%pom.dependencies.txt"
for /f %%l in ('dir /a /b "%WORK_FOLDER%*.jar"' ) do (
  @echo ^<dependency^> >>"%WORK_FOLDER%pom.dependencies.txt"
  @echo     ^<groupId^>%GROUP_ID%^<^/groupId^> >>"%WORK_FOLDER%pom.dependencies.txt"
  @echo     ^<artifactId^>%%~nl^<^/artifactId^> >>"%WORK_FOLDER%pom.dependencies.txt"
  @echo     ^<version^>^$^{boe.version^}^<^/version^> >>"%WORK_FOLDER%pom.dependencies.txt"
  @echo ^<^/dependency^> >>"%WORK_FOLDER%pom.dependencies.txt"
)
@echo off
for /f %%l in ('dir /a /b "%WORK_FOLDER%*.jar"' ) do (
  echo --注册文件[%%l]
  mvn deploy:deploy-file -DgroupId=%GROUP_ID% -DartifactId=%%~nl -Dversion=%VERSION% -Dpackaging=jar -Dfile="%WORK_FOLDER%%%l" -Durl=%REPOSITORY_URL% -DrepositoryId=%REPOSITORY_ID%
)
echo --操作完成
