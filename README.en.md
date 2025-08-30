# Windows Proxy Management Tool

[简体中文](README.md)

A simple yet powerful batch script for quickly managing Windows system proxy settings. Ideal for users who frequently need to switch between direct and proxied network environments.

![Screenshot of the tool](screenshot.png)

## ✨ Features

*   **Enable & Set Proxy**: Quickly set the HTTP proxy server address and port for the system.
*   **One-Click Disable Proxy**: Instantly clear system proxy settings to restore a direct connection.
*   **Flush DNS Cache**: Resolve network issues caused by a stale DNS cache.
*   **View Current Settings**: Clearly display whether the proxy is enabled and its current address.
*   **Interactive Menu**: A user-friendly command-line interface for intuitive operation.
*   **Administrator Check**: Automatically detects if the script is run with administrator privileges and provides a prompt if not.
*   **Auto Language Detection**: Automatically switches between Chinese and English based on your system's language settings.

## 🚀 How to Use

1.  Download the `proxy_tool.bat` file from this repository.
2.  Right-click on the `proxy_tool.bat` file.
3.  Select **"Run as administrator"**.
4.  Follow the on-screen menu prompts to perform actions.

## ⚠️ Troubleshooting

**Q: The script displays garbled characters (mojibake) or shows an error like `'xxx' is not recognized as an internal or external command...`?**

**A:** This is a common issue caused by incorrect file encoding.

**Solution:**
1.  Open the `.bat` file with Windows **Notepad**.
2.  Click **"File"** -> **"Save As..."**.
3.  At the bottom of the dialog box, change the **"Encoding"** dropdown from `UTF-8` to **`ANSI`**.
4.  Save and overwrite the original file. Rerun the script, and the issue should be resolved.

## 📜 License

This project is licensed under the [MIT License](LICENSE).

## 👤 Author

*   **Script by:** SutChan