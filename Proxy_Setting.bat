@echo off
:: ============================================================================
::  Proxy Management Tool - Enhanced Version
::  Author: SutChan
::  Desc: Windows 系统代理快速切换工具 | 支持中英文 | 分协议代理 | 日志记录
::  Version: 2.0
:: ============================================================================

:: 设置 UTF-8 编码以支持中文字符
chcp 65001 >nul
setlocal enabledelayedexpansion

:: 初始化变量
set "LOG_FILE=%~dpn0.log"
set "SCRIPT_NAME=%~nx0"

:: ============================================================================
:: 1. 语言检测与字符串定义
:: ============================================================================

:: 获取系统语言 ID (LCID)
set "LANG_ID="
for /f "skip=1 tokens=*" %%i in ('wmic os get OSLanguage 2^>nul') do (
    if not defined LANG_ID set "LANG_ID=%%i"
)
:: 清除前后空格
for /f "tokens=* delims= " %%a in ("%LANG_ID%") do set "LANG_ID=%%a"

:: 判断是否为中文环境（常见简体/繁体中文 LCID）
set "CN_LIST=2052,1028,3076,5124,4100"
set "SCRIPT_LANG=EN"
for %%i in (%CN_LIST%) do (
    if "%LANG_ID%"=="%%i" set "SCRIPT_LANG=CN"
)

:: --- 加载对应语言文本 ---
if "%SCRIPT_LANG%"=="CN" (
    set "L_TITLE=网络代理设置工具"
    set "L_ADMIN_ERROR=[错误] 请以管理员身份运行此脚本！"
    set "L_MENU_1=1. 启用并设置系统代理"
    set "L_MENU_2=2. 关闭系统代理"
    set "L_MENU_3=3. 刷新 DNS 缓存"
    set "L_MENU_4=4. 显示当前网络代理设置"
    set "L_MENU_5=5. 重置代理（清除全部配置）"
    set "L_MENU_6=6. 退出程序"
    set "L_PROMPT_CHOICE=请选择要进行的操作 (1-6): "
    set "L_INVALID_INPUT=[错误] 无效输入，请输入 1 到 6 之间的数字。"
    set "L_GOODBYE=谢谢使用，再见！"
    set "L_ENABLE_PROXY_TITLE=--- 启用并设置系统代理 ---"
    set "L_PROMPT_PROXY_ADDR=请输入代理服务器信息："
    set "L_PROMPT_HTTP=  HTTP 代理 (如 127.0.0.1:7890): "
    set "L_PROMPT_HTTPS=  HTTPS 代理 (如 127.0.0.1:7890): "
    set "L_PROMPT_SOCKS=  SOCKS 代理 (如 127.0.0.1:7891): "
    set "L_ERROR_EMPTY_INPUT=[错误] 输入不能为空！"
    set "L_SETTING_PROXY=正在设置代理..."
    set "L_ERROR_SET_ADDR=[错误] 设置代理失败！"
    set "L_ENABLING_PROXY=正在启用代理开关..."
    set "L_ERROR_ENABLE_PROXY=[错误] 启用代理失败！"
    set "L_SUCCESS_PROXY_ENABLED=[成功] 系统代理已启用！"
    set "L_DISABLE_PROXY_TITLE=--- 关闭系统代理 ---"
    set "L_DISABLING_PROXY=正在关闭代理开关..."
    set "L_SUCCESS_PROXY_DISABLED=[成功] 系统代理已关闭！"
    set "L_FLUSH_DNS_TITLE=--- 刷新 DNS 缓存 ---"
    set "L_FLUSHING_DNS=正在刷新 DNS 缓存..."
    set "L_SHOW_SETTINGS_TITLE=--- 当前网络代理设置 ---"
    set "L_PROXY_STATUS=代理状态"
    set "L_PROXY_ADDR=代理地址"
    set "L_PAC_URL=PAC 脚本"
    set "L_PROXY_OVERRIDE=代理例外"
    set "L_STATUS_ENABLED=已启用"
    set "L_STATUS_DISABLED=已关闭"
    set "L_STATUS_NOT_SET=[未设置]"
    set "L_RESET_TITLE=--- 重置代理配置 ---"
    set "L_RESETTING=正在清除所有代理相关设置..."
    set "L_SUCCESS_RESET=[成功] 所有代理配置已清除！"
) else (
    set "L_TITLE=Proxy Management Tool"
    set "L_ADMIN_ERROR=[ERROR] Please run this script as administrator!"
    set "L_MENU_1=1. Enable and Set System Proxy"
    set "L_MENU_2=2. Disable System Proxy"
    set "L_MENU_3=3. Flush DNS Cache"
    set "L_MENU_4=4. Show Current Proxy Settings"
    set "L_MENU_5=5. Reset Proxy (Clear All Config)"
    set "L_MENU_6=6. Exit"
    set "L_PROMPT_CHOICE=Please select an option (1-6): "
    set "L_INVALID_INPUT=[ERROR] Invalid input. Enter 1-6."
    set "L_GOODBYE=Thank you for using. Goodbye!"
    set "L_ENABLE_PROXY_TITLE=--- Enable and Set System Proxy ---"
    set "L_PROMPT_PROXY_ADDR=Enter proxy server details:"
    set "L_PROMPT_HTTP=  HTTP Proxy (e.g., 127.0.0.1:7890): "
    set "L_PROMPT_HTTPS=  HTTPS Proxy (e.g., 127.0.0.1:7890): "
    set "L_PROMPT_SOCKS=  SOCKS Proxy (e.g., 127.0.0.1:7891): "
    set "L_ERROR_EMPTY_INPUT=[ERROR] Input cannot be empty!"
    set "L_SETTING_PROXY=Setting proxy..."
    set "L_ERROR_SET_ADDR=[ERROR] Failed to set proxy!"
    set "L_ENABLING_PROXY=Enabling proxy switch..."
    set "L_ERROR_ENABLE_PROXY=[ERROR] Failed to enable proxy!"
    set "L_SUCCESS_PROXY_ENABLED=[SUCCESS] System proxy enabled!"
    set "L_DISABLE_PROXY_TITLE=--- Disable System Proxy ---"
    set "L_DISABLING_PROXY=Disabling proxy switch..."
    set "L_SUCCESS_PROXY_DISABLED=[SUCCESS] System proxy disabled!"
    set "L_FLUSH_DNS_TITLE=--- Flush DNS Cache ---"
    set "L_FLUSHING_DNS=Flushing DNS cache..."
    set "L_SHOW_SETTINGS_TITLE=--- Current Proxy Settings ---"
    set "L_PROXY_STATUS=Proxy Status"
    set "L_PROXY_ADDR=Proxy Address"
    set "L_PAC_URL=PAC Script URL"
    set "L_PROXY_OVERRIDE=Proxy Exceptions"
    set "L_STATUS_ENABLED=Enabled"
    set "L_STATUS_DISABLED=Disabled"
    set "L_STATUS_NOT_SET=[Not Set]"
    set "L_RESET_TITLE=--- Reset Proxy Configuration ---"
    set "L_RESETTING=Clearing all proxy settings..."
    set "L_SUCCESS_RESET=[SUCCESS] All proxy settings cleared!"
)

:: ============================================================================
:: 2. 检查管理员权限（可靠方式）
:: ============================================================================
net session >nul 2>&1
if %errorlevel% NEQ 0 (
    echo.
    echo    %L_ADMIN_ERROR%
    echo.
    timeout /t 5 >nul
    exit /b 1
)
title %L_TITLE% - %SCRIPT_NAME%

:: ============================================================================
:: 3. 主菜单循环
:: ============================================================================
:main_menu
cls
echo.
echo    ====================================================
echo              %L_TITLE% by SutChan
echo    ====================================================
echo.
echo      %L_MENU_1%
echo      %L_MENU_2%
echo      %L_MENU_3%
echo      %L_MENU_4%
echo      %L_MENU_5%
echo      %L_MENU_6%
echo.
echo    ====================================================

set "choice="
set /p "choice= %L_PROMPT_CHOICE%"

if "%choice%"=="1" call :enable_proxy   & goto log_action
if "%choice%"=="2" call :disable_proxy & goto log_action
if "%choice%"=="3" call :flush_dns     & goto log_action
if "%choice%"=="4" call :show_settings & goto no_log
if "%choice%"=="5" call :reset_proxy   & goto log_action
if "%choice%"=="6" goto :exit_script

echo.
echo    %L_INVALID_INPUT%
timeout /t 2 >nul
goto :main_menu

:: 记录操作日志
:log_action
echo [%date% %time%] ACTION: %choice% - %USERNAME%@%COMPUTERNAME% >> "%LOG_FILE%"
:no_log
goto :main_menu

:: ============================================================================
:: 4. 功能子程序
:: ============================================================================

:enable_proxy
    cls & echo. & echo %L_ENABLE_PROXY_TITLE% & echo.
    echo %L_PROMPT_PROXY_ADDR%
    set "http_proxy=" & set "https_proxy=" & set "socks_proxy="
    set /p "http_proxy=%L_PROMPT_HTTP%"
    set /p "https_proxy=%L_PROMPT_HTTPS%"
    set /p "socks_proxy=%L_PROMPT_SOCKS%"

    :: 至少一个代理需填写
    if "%http_proxy%%https_proxy%%socks_proxy%"=="" (
        echo.
        echo    %L_ERROR_EMPTY_INPUT%
        goto :common_pause
    )

    echo. & echo    %L_SETTING_PROXY%
    set "proxy_reg="
    if not "%http_proxy%"=="" set "proxy_reg=http=%http_proxy%;"
    if not "%https_proxy%"=="" set "proxy_reg=!proxy_reg!https=%https_proxy%;"
    if not "%socks_proxy%"=="" set "proxy_reg=!proxy_reg!socks=%socks_proxy%"

    :: 写入注册表
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /t REG_SZ /d "!proxy_reg!" /f >nul
    if errorlevel 1 ( echo    %L_ERROR_SET_ADDR% & goto :common_pause )

    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f >nul
    if errorlevel 1 ( echo    %L_ERROR_ENABLE_PROXY% & goto :common_pause )

    echo    %L_ENABLING_PROXY%
    echo    %L_SUCCESS_PROXY_ENABLED%
    call :flush_dns_quiet
    goto :common_pause

:disable_proxy
    cls & echo. & echo %L_DISABLE_PROXY_TITLE% & echo.
    echo    %L_DISABLING_PROXY%
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f >nul
    if errorlevel 1 (
        echo    %L_ERROR_OPERATION_FAILED%
    ) else (
        echo    %L_SUCCESS_PROXY_DISABLED%
    )
    call :flush_dns_quiet
    goto :common_pause

:flush_dns
    cls & echo. & echo %L_FLUSH_DNS_TITLE% & echo.
    echo    %L_FLUSHING_DNS%
    ipconfig /flushdns | findstr /i "successfully\|成功\|已完成" >nul && (
        echo    [SUCCESS] DNS cache flushed.
    ) || (
        echo    [ERROR] Failed to flush DNS.
    )
    goto :common_pause

:flush_dns_quiet
    ipconfig /flushdns >nul 2>&1
    goto :eof

:show_settings
    cls & echo. & echo %L_SHOW_SETTINGS_TITLE%
    echo.

    :: 读取 ProxyEnable
    set "enabled_val="
    for /f "tokens=3" %%a in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable 2^>nul') do set "enabled_val=%%a"

    :: 读取 ProxyServer
    set "proxy_val="
    for /f "tokens=2,*" %%a in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer 2^>nul') do set "proxy_val=%%b"

    :: 读取 PAC URL
    set "pac_val="
    for /f "tokens=2,*" %%a in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v AutoConfigURL 2^>nul') do set "pac_val=%%b"

    :: 读取例外列表
    set "override_val="
    for /f "tokens=2,*" %%a in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyOverride 2^>nul') do set "override_val=%%b"

    :: 输出状态
    if "%enabled_val%"=="0x1" (
        echo    %L_PROXY_STATUS%: %L_STATUS_ENABLED%
        if defined proxy_val ( echo    %L_PROXY_ADDR%: %proxy_val% ) else ( echo    %L_PROXY_ADDR%: %L_STATUS_NOT_SET% )
    ) else (
        echo    %L_PROXY_STATUS%: %L_STATUS_DISABLED%
        echo    %L_PROXY_ADDR%: %L_STATUS_NOT_SET%
    )

    if defined pac_val    ( echo    %L_PAC_URL%: %pac_val% )    else ( echo    %L_PAC_URL%: %L_STATUS_NOT_SET% )
    if defined override_val ( echo    %L_PROXY_OVERRIDE%: %override_val% ) else ( echo    %L_PROXY_OVERRIDE%: %L_STATUS_NOT_SET% )

    echo. & echo    ====================================================
    goto :common_pause

:reset_proxy
    cls & echo. & echo %L_RESET_TITLE% & echo.
    echo    %L_RESETTING%
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /f >nul 2>&1
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /f >nul 2>&1
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v AutoConfigURL /f >nul 2>&1
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyOverride /f >nul 2>&1
    echo    %L_SUCCESS_RESET%
    call :flush_dns_quiet
    goto :common_pause

:exit_script
    echo.
    echo    %L_GOODBYE%
    timeout /t 3 >nul
    exit /b 0

:common_pause
    echo. & pause
    goto :eof