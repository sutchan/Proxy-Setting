# Windows 网络代理设置工具 (Windows Proxy Management Tool)

[English Version](#english-version)

一个简单而强大的批处理脚本，用于快速管理 Windows 系统代理设置。非常适合需要频繁在直连和代理网络环境之间切换的用户。

![脚本运行截图](screenshot.png)

## ✨ 功能特性

*   **启用并设置代理**：快速为系统设置 HTTP 代理服务器地址和端口。
*   **一键关闭代理**：迅速清除系统代理设置，恢复直连。
*   **刷新 DNS 缓存**：解决因 DNS 缓存导致的网络问题。
*   **查看当前设置**：清晰地显示当前代理是否启用及其地址。
*   **交互式菜单**：友好的命令行菜单，操作直观。
*   **管理员权限检查**：自动检测是否以管理员身份运行，并给出提示。

## 🚀 如何使用

1.  从本仓库下载 `proxy_tool.bat` 文件。
2.  右键点击 `proxy_tool.bat` 文件。
3.  选择 **“以管理员身份运行”**。
4.  根据屏幕上的菜单提示进行操作。

## ⚠️ 常见问题 (Troubleshooting)

**问：脚本中的中文显示为乱码，或者提示 `'xxx' 不是内部或外部命令...` 错误？**

**答：** 这是最常见的问题，由文件编码错误导致。

**解决方法：**
1.  用 Windows **记事本** 打开 `.bat` 文件。
2.  点击左上角 **“文件”** -> **“另存为...”**。
3.  在弹出的窗口底部，将 **“编码”** 选项从 `UTF-8` 修改为 **`ANSI`**。
4.  保存并覆盖原文件，然后重新运行脚本即可。

## 📜 许可证

本项目采用 [MIT License](LICENSE) 许可证。

## 👤 作者

*   **原始脚本:** SutChan
*   **优化与文档:** [Your Name / Community]

---

## English Version

A simple yet powerful batch script for quickly managing Windows system proxy settings. Ideal for users who frequently need to switch between direct and proxied network environments.

![Screenshot of the tool](screenshot.png)

## ✨ Features

*   **Enable & Set Proxy**: Quickly set the HTTP proxy server address and port for the system.
*   **One-Click Disable Proxy**: Instantly clear system proxy settings to restore a direct connection.
*   **Flush DNS Cache**: Resolve network issues caused by a stale DNS cache.
*   **View Current Settings**: Clearly display whether the proxy is enabled and its current address.
*   **Interactive Menu**: A user-friendly command-line interface for intuitive operation.
*   **Administrator Check**: Automatically detects if the script is run with administrator privileges and provides a prompt if not.

## 🚀 How to Use

1.  Download the `proxy_tool.bat` file from this repository.
2.  Right-click on the `proxy_tool.bat` file.
3.  Select **"Run as administrator"**.
4.  Follow the on-screen menu prompts to perform actions.

## ⚠️ Troubleshooting

**Q: The script displays garbled characters (mojibake) for Chinese text, or shows an error like `'xxx' is not recognized as an internal or external command...`?**

**A:** This is a common issue caused by incorrect file encoding.

**Solution:**
1.  Open the `.bat` file with Windows **Notepad**.
2.  Click **"File"** -> **"Save As..."**.
3.  At the bottom of the dialog box, change the **"Encoding"** dropdown from `UTF-8` to **`ANSI`**.
4.  Save and overwrite the original file. Rerun the script, and the issue should be resolved.

## 📜 License

This project is licensed under the [MIT License](LICENSE).

## 👤 Author

*   **Original Script by:** SutChan
*   **Optimized & Documented by:** [Your Name / Community]