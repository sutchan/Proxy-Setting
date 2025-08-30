@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
title 网络代理设置工具 by SutChan
color 0A

:: ============================================================================
:: 1. 检查管理员权限 (更可靠的方法)
:: ============================================================================
net session >nul 2>&1
if %errorlevel% NEQ 0 (
    echo.
    echo    [错误] 请以管理员身份运行此脚本！
    echo.
    timeout /t 5 >nul
    exit /b
)

:: ============================================================================
:: 2. 主菜单循环
:: ============================================================================
:main_menu
cls
echo.
echo    ================================================
echo            网络代理设置工具 by SutChan
echo    ================================================
echo.
echo      1. 启用并设置系统代理.
echo.
echo      2. 关闭系统代理
echo.
echo      3. 刷新 DNS 缓存
echo.
echo      4. 显示当前网络代理设置
echo.
echo      5. 退出程序
echo.
echo    ================================================

set "choice="
set /p "choice= 请选择要进行的操作 (1-5): "

:: 根据选择调用对应的子程序
if "%choice%"=="1" call :enable_proxy
if "%choice%"=="2" call :disable_proxy
if "%choice%"=="3" call :flush_dns
if "%choice%"=="4" call :show_settings
if "%choice%"=="5" (
    echo.
    echo    谢谢使用，再见！
    timeout /t 1 >nul
    exit /b
)

:: 如果输入无效，则提示并返回主菜单
echo.
echo    [错误] 无效输入，请输入 1 到 5 之间的数字。
timeout /t 2 >nul
goto :main_menu

:: 主循环结束，脚本不应该执行到这里，但为了保险起见
goto :main_menu


:: ============================================================================
:: 3. 功能子程序定义 (模块化代码)
:: ============================================================================

:enable_proxy
    cls
    echo.
    echo --- 启用并设置系统代理 ---
    echo.
    set "proxy_server="
    set /p "proxy_server=请输入代理服务器地址和端口 (例如: 127.0.0.1:7890): "
    
    if not defined proxy_server (
        echo.
        echo    [错误] 输入不能为空！
        goto :common_pause
    )
    
    echo.
    echo    正在设置代理服务器为: %proxy_server%
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /t REG_SZ /d "%proxy_server%" /f >nul
    if !errorlevel! NEQ 0 (
        echo    [错误] 设置代理服务器地址失败！
        goto :common_pause
    )
    
    echo    正在启用代理开关...
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f >nul
    if !errorlevel! NEQ 0 (
        echo    [错误] 启用代理开关失败！
        goto :common_pause
    )
    
    echo    [成功] 系统代理已启用！
    call :flush_dns_quiet
    goto :common_pause

:disable_proxy
    cls
    echo.
    echo --- 关闭系统代理 ---
    echo.
    echo    正在关闭代理开关...
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f >nul
    
    if !errorlevel! EQU 0 (
        echo    [成功] 系统代理已关闭！
    ) else (
        echo    [错误] 操作失败，可能需要管理员权限。
    )
    call :flush_dns_quiet
    goto :common_pause

:flush_dns
    cls
    echo.
    echo --- 刷新 DNS 缓存 ---
    echo.
    ipconfig /flushdns
    goto :common_pause

:flush_dns_quiet
    echo    正在刷新 DNS 缓存...
    ipconfig /flushdns >nul
    goto :eof

:show_settings
    cls
    echo.
    echo --- 当前网络代理设置 ---
    
    set "proxy_enabled="
    set "proxy_server_addr="
    
    :: 查询代理是否启用
    for /f "tokens=3" %%a in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable 2^>nul') do (
        set "proxy_enabled=%%a"
    )
    
    :: 查询代理服务器地址
    for /f "tokens=2,*" %%a in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer 2^>nul') do (
        set "proxy_server_addr=%%b"
    )
    
    echo.
    if "%proxy_enabled%"=="0x1" (
        echo    代理状态: 已启用
        if defined proxy_server_addr (
            echo    代理地址: %proxy_server_addr%
        ) else (
            echo    代理地址: [未设置] (代理可能无效)
        )
    ) else (
        echo    代理状态: 已关闭
    )
    echo.
    echo    ================================
    goto :common_pause

:common_pause
    echo.
    pause
    goto :eof