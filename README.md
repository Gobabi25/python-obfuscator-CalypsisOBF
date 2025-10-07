# python-obfuscator-CalypsisOBF
![GitHub stars](https://img.shields.io/github/stars/iamsopotatoe-coder/python-obfuscator-CalypsisOBF?style=social) ![GitHub forks](https://img.shields.io/github/forks/iamsopotatoe-coder/python-obfuscator-CalypsisOBF?style=social) ![GitHub issues](https://img.shields.io/github/issues/iamsopotatoe-coder/python-obfuscator-CalypsisOBF) ![License](https://img.shields.io/github/license/iamsopotatoe-coder/python-obfuscator-CalypsisOBF) ![Contributors](https://img.shields.io/github/contributors/iamsopotatoe-coder/python-obfuscator-CalypsisOBF) ![Python](https://img.shields.io/badge/python-3.6+-blue.svg)

## Description
A Python script obfuscation tool for educational and research purposes. CalypsisOBF helps protect Python code by applying various obfuscation techniques to make reverse engineering more difficult.

## ⚠️ Disclaimer
**This tool is intended for educational purposes only. The author is not responsible for any misuse of this software. Users are responsible for ensuring compliance with applicable laws and regulations.**

## VirusTotal Results

The following scans were performed to illustrate the obfuscator's effectiveness.

### **Before Obfuscation**

- Higher detection rate from antivirus engines.
- ![No obfuscation](no-obfuscation.png)

### **After Obfuscation**

- Significantly fewer detections, demonstrating improved code security.
- ![With obfuscation](with-obfuscation.png)

### Comparison Table

| Scan Type           | Total Detections | Antivirus Engines Flagged |
|---------------------|------------------|---------------------------|
| Without Obfuscation | [XX]             | [Engine names]            |
| With Obfuscation    | [YY]             | [Engine names]            |

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
JgtjWkwqbQ = b'\xfd7zXZ\x00\x00\x04\xe6\xd6\xb4F\x02\x00!\x01\x16\x00\x00\x00t/\xe5\xa3\x01\x00\xf2x\x9cuP\xc1n\xc30\x08\xfd\xa5,K\x8f;,\x9am\xd5\x12D\xa9\x9cXp\xdd\x0e1\x89\xcfM\xfd\xf5\xc3Q\xabN\x9bv\xb0\xe0\x01\xef\xe1\x07\x88\x17\x88\xb0S\xb1\xff\xc7\xfc\xb7\x0e\xc5\xaf\xc3\x03\x87\xa9\xa1bN\xec`\xe7\x80\x8a\xd7\x9b\xd63:\xb8\xfe\xe6q\xb0\xf7~\x9f\xa0\xd5~`\x81v\xea\xa8\xf8D\x19\x17\n\xdb\x82\xce\xae\x14/\x0b\xc7i\'a\x8d\xe7R1\x86sGU\xff\xd03\x1d\xe7\xca\xd3xf1\x04\xd1\xe8\xdcg7\x04R\x9e)?}A\xf4\xc2\x8eu\xef\xbc\xa8\xce+\xc9%A67\n}\xc2\xca\x0bsf\xddAe\xcb\xec\xac\xd49\x8c\xe7\xe6\xf8\x97\xe3L\x822<}>}\x8b_\xd5\xe7\xfdN5\xea\xbd\x8f\xbb\xbc\xef\x83\xabxl \xd6\xde\xac\xf3\xe3\x0b\x84M\xa8\xc5\r?z\xa1\xac\xbe\xcb\xd7\xc3\xef\xdb7"|\x95\x88\x00\x00-\xd5\xdd\xef8\x14\x9eh\x00\x01\x8b\x02\xf3\x01\x00\x00\xd8\xb0\xf3X\xb1\xc4g\xfb\x02\x00\x00\x00\x00\x04YZ'
yFl_DHKGxI = 193
h5qF7xr6Kz = lzma.decompress(JgtjWkwqbQ)
TZAs7F8Zgg = zlib.decompress(h5qF7xr6Kz)
m80zR3YEzl = base64.b64decode(TZAs7F8Zgg)
qwpN5gdbKp = binascii.unhexlify(m80zR3YEzl)
ZLIHD20fXM = bytes(b ^ yFl_DHKGxI for b in qwpN5gdbKp)
ft37atyAKP = marshal.loads(ZLIHD20fXM)
exec(ft37atyAKP)
```

**Note:** The obfuscated Python file is meant to run as a script but is not intended to be human-readable. It works on standard Python interpreters.

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
