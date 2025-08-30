@echo off
:: 使用 UTF-8 代码页以正确显示多语言字符
chcp 65001 >nul
setlocal enabledelayedexpansion
color 0A

:: ============================================================================
:: 1. 语言检测与字符串定义
:: ============================================================================

:: 使用 WMIC 获取系统语言代码 (LCID)
set "LANG_ID="
for /f "skip=1" %%i in ('wmic os get OSLanguage') do (
    if not defined LANG_ID set "LANG_ID=%%i"
)

:: 根据语言代码 (LCID) 设置脚本语言变量
:: 2052 = 简体中文(中国), 1028 = 繁体中文(台湾), 3076 = 繁体中文(香港)
if "%LANG_ID%"=="2052" (
    set "SCRIPT_LANG=CN"
) else if "%LANG_ID%"=="1028" (
    set "SCRIPT_LANG=CN"
) else if "%LANG_ID%"=="3076" (
    set "SCRIPT_LANG=CN"
) else (
    set "SCRIPT_LANG=EN"
)

:: --- 根据 SCRIPT_LANG 加载对应的文本字符串 ---
if "%SCRIPT_LANG%"=="CN" (
    set "L_TITLE=网络代理设置工具"
    set "L_ADMIN_ERROR=[错误] 请以管理员身份运行此脚本！"
    set "L_MENU_1=1. 启用并设置系统代理"
    set "L_MENU_2=2. 关闭系统代理"
    set "L_MENU_3=3. 刷新 DNS 缓存"
    set "L_MENU_4=4. 显示当前网络代理设置"
    set "L_MENU_5=5. 退出程序"
    set "L_PROMPT_CHOICE=请选择要进行的操作 (1-5): "
    set "L_INVALID_INPUT=[错误] 无效输入，请输入 1 到 5 之间的数字。"
    set "L_GOODBYE=谢谢使用，再见！"
    set "L_ENABLE_PROXY_TITLE=--- 启用并设置系统代理 ---"
    set "L_PROMPT_PROXY_ADDR=请输入代理服务器地址和端口 (例如: 127.0.0.1:7890): "
    set "L_ERROR_EMPTY_INPUT=[错误] 输入不能为空！"
    set "L_SETTING_PROXY_TO=正在设置代理服务器为: "
    set "L_ERROR_SET_ADDR=[错误] 设置代理服务器地址失败！"
    set "L_ENABLING_PROXY=正在启用代理开关..."
    set "L_ERROR_ENABLE_PROXY=[错误] 启用代理开关失败！"
    set "L_SUCCESS_PROXY_ENABLED=[成功] 系统代理已启用！"
    set "L_DISABLE_PROXY_TITLE=--- 关闭系统代理 ---"
    set "L_DISABLING_PROXY=正在关闭代理开关..."
    set "L_SUCCESS_PROXY_DISABLED=[成功] 系统代理已关闭！"
    set "L_ERROR_OPERATION_FAILED=[错误] 操作失败，可能需要管理员权限。"
    set "L_FLUSH_DNS_TITLE=--- 刷新 DNS 缓存 ---"
    set "L_FLUSHING_DNS=正在刷新 DNS 缓存..."
    set "L_SHOW_SETTINGS_TITLE=--- 当前网络代理设置 ---"
    set "L_PROXY_STATUS=代理状态"
    set "L_PROXY_ADDR=代理地址"
    set "L_STATUS_ENABLED=已启用"
    set "L_STATUS_DISABLED=已关闭"
    set "L_STATUS_NOT_SET=[未设置] (代理可能无效)"
) else (
    set "L_TITLE=Proxy Management Tool"
    set "L_ADMIN_ERROR=[ERROR] Please run this script as an administrator!"
    set "L_MENU_1=1. Enable and Set System Proxy"
    set "L_MENU_2=2. Disable System Proxy"
    set "L_MENU_3=3. Flush DNS Cache"
    set "L_MENU_4=4. Show Current Proxy Settings"
    set "L_MENU_5=5. Exit"
    set "L_PROMPT_CHOICE=Please select an option (1-5): "
    set "L_INVALID_INPUT=[ERROR] Invalid input. Please enter a number between 1 and 5."
    set "L_GOODBYE=Thank you for using. Goodbye!"
    set "L_ENABLE_PROXY_TITLE=--- Enable and Set System Proxy ---"
    set "L_PROMPT_PROXY_ADDR=Enter proxy server address and port (e.g., 127.0.0.1:7890): "
    set "L_ERROR_EMPTY_INPUT=[ERROR] Input cannot be empty!"
    set "L_SETTING_PROXY_TO=Setting proxy server to: "
    set "L_ERROR_SET_ADDR=[ERROR] Failed to set proxy server address!"
    set "L_ENABLING_PROXY=Enabling proxy switch..."
    set "L_ERROR_ENABLE_PROXY=[ERROR] Failed to enable proxy switch!"
    set "L_SUCCESS_PROXY_ENABLED=[SUCCESS] System proxy has been enabled!"
    set "L_DISABLE_PROXY_TITLE=--- Disable System Proxy ---"
    set "L_DISABLING_PROXY=Disabling proxy switch..."
    set "L_SUCCESS_PROXY_DISABLED=[SUCCESS] System proxy has been disabled!"
    set "L_ERROR_OPERATION_FAILED=[ERROR] Operation failed. Administrator privileges may be required."
    set "L_FLUSH_DNS_TITLE=--- Flush DNS Cache ---"
    set "L_FLUSHING_DNS=Flushing DNS cache..."
    set "L_SHOW_SETTINGS_TITLE=--- Current Proxy Settings ---"
    set "L_PROXY_STATUS=Proxy Status"
    set "L_PROXY_ADDR=Proxy Address"
    set "L_STATUS_ENABLED=Enabled"
    set "L_STATUS_DISABLED=Disabled"
    set "L_STATUS_NOT_SET=[Not Set] (Proxy may be ineffective)"
)

:: ============================================================================
:: 2. 检查管理员权限
:: ============================================================================
net session >nul 2>&1
if %errorlevel% NEQ 0 (
    echo.
    echo    %L_ADMIN_ERROR%
    echo.
    timeout /t 5 >nul
    exit /b
)
title %L_TITLE% by SutChan

:: ============================================================================
:: 3. 主菜单循环 (已完全使用语言变量)
:: ============================================================================
:main_menu
cls
echo.
echo    ================================================
echo            %L_TITLE% by SutChan
echo    ================================================
echo.
echo      %L_MENU_1%
echo      %L_MENU_2%
echo      %L_MENU_3%
echo      %L_MENU_4%
echo      %L_MENU_5%
echo.
echo    ================================================

set "choice="
set /p "choice= %L_PROMPT_CHOICE%"

if "%choice%"=="1" call :enable_proxy
if "%choice%"=="2" call :disable_proxy
if "%choice%"=="3" call :flush_dns
if "%choice%"=="4" call :show_settings
if "%choice%"=="5" (
    echo.
    echo    %L_GOODBYE%
    timeout /t 1 >nul
    exit /b
)

echo.
echo    %L_INVALID_INPUT%
timeout /t 2 >nul
goto :main_menu


:: ============================================================================
:: 4. 功能子程序 (已完全使用语言变量)
:: ============================================================================

:enable_proxy
    cls & echo. & echo %L_ENABLE_PROXY_TITLE% & echo.
    set "proxy_server="
    set /p "proxy_server=%L_PROMPT_PROXY_ADDR%"
    if not defined proxy_server ( echo. & echo    %L_ERROR_EMPTY_INPUT% & goto :common_pause )
    echo. & echo    %L_SETTING_PROXY_TO%%proxy_server%
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer /t REG_SZ /d "%proxy_server%" /f >nul
    if !errorlevel! NEQ 0 ( echo    %L_ERROR_SET_ADDR% & goto :common_pause )
    echo    %L_ENABLING_PROXY%
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f >nul
    if !errorlevel! NEQ 0 ( echo    %L_ERROR_ENABLE_PROXY% & goto :common_pause )
    echo    %L_SUCCESS_PROXY_ENABLED%
    call :flush_dns_quiet
    goto :common_pause

:disable_proxy
    cls & echo. & echo %L_DISABLE_PROXY_TITLE% & echo.
    echo    %L_DISABLING_PROXY%
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f >nul
    if !errorlevel! EQU 0 ( echo    %L_SUCCESS_PROXY_DISABLED% ) else ( echo    %L_ERROR_OPERATION_FAILED% )
    call :flush_dns_quiet
    goto :common_pause

:flush_dns
    cls & echo. & echo %L_FLUSH_DNS_TITLE% & echo.
    ipconfig /flushdns
    goto :common_pause

:flush_dns_quiet
    echo    %L_FLUSHING_DNS%
    ipconfig /flushdns >nul
    goto :eof

:show_settings
    cls & echo. & echo %L_SHOW_SETTINGS_TITLE%
    set "proxy_enabled=" & set "proxy_server_addr="
    for /f "tokens=3" %%a in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable 2^>nul') do ( set "proxy_enabled=%%a" )
    for /f "tokens=2,*" %%a in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer 2^>nul') do ( set "proxy_server_addr=%%b" )
    echo.
    if "%proxy_enabled%"=="0x1" (
        echo    %L_PROXY_STATUS%: %L_STATUS_ENABLED%
        if defined proxy_server_addr ( echo    %L_PROXY_ADDR%: %proxy_server_addr% ) else ( echo    %L_PROXY_ADDR%: %L_STATUS_NOT_SET% )
    ) else (
        echo    %L_PROXY_STATUS%: %L_STATUS_DISABLED%
    )
    echo. & echo    ================================
    goto :common_pause

:common_pause
    echo. & pause
    goto :eof