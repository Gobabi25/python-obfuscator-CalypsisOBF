# python-obfuscator-CalypsisOBF
![GitHub stars](https://img.shields.io/github/stars/iamsopotatoe-coder/python-obfuscator-CalypsisOBF?style=social) ![GitHub forks](https://img.shields.io/github/forks/iamsopotatoe-coder/python-obfuscator-CalypsisOBF?style=social) ![GitHub issues](https://img.shields.io/github/issues/iamsopotatoe-coder/python-obfuscator-CalypsisOBF) ![License](https://img.shields.io/github/license/iamsopotatoe-coder/python-obfuscator-CalypsisOBF) ![Contributors](https://img.shields.io/github/contributors/iamsopotatoe-coder/python-obfuscator-CalypsisOBF) ![Python](https://img.shields.io/badge/python-3.6+-blue.svg)

## Description
A Python script obfuscation tool for educational and research purposes. CalypsisOBF helps protect Python code by applying various obfuscation techniques to make reverse engineering more difficult.

## ⚠️ Disclaimer
**This tool is intended for educational purposes only. The author is not responsible for any misuse of this software. Users are responsible for ensuring compliance with applicable laws and regulations.**

## VirusTotal Results
The following images demonstrate the effectiveness of the obfuscation in reducing detection rates:

### Before Obfuscation
![No obfuscation](no-obfuscation.png)
*Without obfuscation: Higher detection rate from antivirus engines*

### After Obfuscation
![With obfuscation](with-obfuscation.png)
*With obfuscation: Significantly reduced detection rate, demonstrating the effectiveness of the tool*

## Obfuscation Layers
CalypsisOBF applies multiple protection layers to secure your Python code:

- AST Variable Renaming
- Code Noise Injection
- Bytecode Compilation (marshal)
- XOR Encryption
- Hexlify & Base64 Encoding
- zlib Compression
- LZMA Compression
- Custom Loader Stub

## Example

### Original Python Code

```python
print("Hello, world!")
```

### Obfuscated Output

```python
# The output will not look like Python code anymore and will contain a loader stub like:
import marshal, zlib, lzma, base64, binascii
<...obfuscated variables and data...>
exec(<decoded bytecode>)
```
> *Note: The obfuscated Python file is meant to run as a script but is not intended to be human-readable. It works on standard Python interpreters.*

## Features
- Advanced Python code obfuscation
- Multiple obfuscation layers
- Easy to use interface
- Preserves code functionality

## Installation
```bash
git clone https://github.com/iamsopotatoe-coder/python-obfuscator-CalypsisOBF.git
cd python-obfuscator-CalypsisOBF
```

## Usage
Refer to the documentation for detailed usage instructions.

## License
This project is licensed under the MIT License - see the LICENSE file for details.
