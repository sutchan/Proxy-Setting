@Echo Off
color 2e
Title 命令
:begin
cls
Echo.请选择需要的操作
echo.
Echo     1 启用代理服务器	2 取消代理服务器
Echo.     
echo     3 刷新 DNS		4 显示设置
echo.    
echo.
Set /P Choice= 　　　　　请选择要进行的操作数字 ，然后按回车：
If not "%Choice%"=="" (
  If "%Choice%"=="4" ipconfig /all
  If "%Choice%"=="3" ipconfig /flushdns
  If "%Choice%"=="2" reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f & ipconfig /flushdns
  If "%Choice%"=="1" reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f & ipconfig /flushdns
)
pause>nul
goto :beg
