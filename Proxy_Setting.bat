@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
color 2e
title 网络代理设置工具

:: 检查管理员权限
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if not %errorlevel%==0 (
    echo.
    echo    错误：请以管理员身份运行此脚本！
    timeout /t 3 >nul
    exit /b
)

:begin
cls
echo.
echo    ===============================
echo      网络代理设置工具 by SutChan
echo    ===============================
echo.
echo     1 启用代理服务器
echo     2 取消代理服务器
echo     3 刷新 DNS缓存
echo     4 显示网络设置
echo     5 退出程序
echo.
echo    ===============================

set "Choice="
set /P Choice=请选择要进行的操作 (1-5)：

:: 去除首尾空格
for /f "tokens=* delims= " %%a in ("!Choice!") do set "Choice=%%a"

if "!Choice!"=="" (
    echo.
    echo    [错误] 输入不能为空！
    timeout /t 2 >nul
    goto :begin
)

if "%Choice%"=="1" (
    echo.
    echo    注意：请确保已配置代理地址（如 127.0.0.1:8080），否则代理无效。
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f
    if %errorlevel% NEQ 0 goto reg_error
    ipconfig /flushdns >nul && (
        echo    [成功] 已启用代理服务器并刷新DNS
    ) || (
        echo    [警告] DNS刷新失败，但代理已启用
    )
    timeout /t 2 >nul
    goto :begin
)

:: ... 其他选项保持不变（注意 errorlevel 判断）

if "%Choice%"=="5" (
    echo.
    echo    谢谢使用，再见！
    timeout /t 2 >nul
    exit
)

echo.
echo    [错误] 请输入有效的选项 (1-5)！
timeout /t 2 >nul
goto :begin

:reg_error
echo.
echo    [错误] 注册表修改失败，请以管理员身份运行！
timeout /t 3 >nul
goto :begin