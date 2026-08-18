# How to use

open Linux terminal

```bash
cd ~
mkdir -p .config/nvim
git clone https://github.com/Puneeth-24/Neovim-config .
```

## update ubuntu
```bash
sudo apt update
sudo apt upgrade -y
```

## Install essential utilities
These are required by Neovim plugins, especially Mason and Telescope
```bash
sudo apt install -y unzip curl wget tar gzip ripgrep
```

## for C/C++ development

```bash
sudo apt install -y clangd clang-format
```

verify
```bash
clangd --version
clang-format --version
```

clangd -> for C/C++ development <br>
clang-format -> C/C++ formatter

## Python

```bash
sudo apt install -y python3 python3-pip python3-venv
```

verify
```bash
python3 --version
pip3 --version
```
---

for now I use mostly these, Neovim can support many lsp's.
I will add for more lsp's later.
