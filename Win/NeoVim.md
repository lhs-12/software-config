# <center>NeoVim<center/>

# 安装

在WSL2里面操作(Ubuntu)
```
github下载安装包
sudo tar zxvf nvim-linux64.tar.gz
sudo rm -rf nvim-linux64.tar.gz
sudo mv nvim-linux64 /var/local
sudo ln -s /var/local/nvim-linux64/bin/nvim /usr/bin/nvim
```

GitHub下载GUI客户端neovide.exe,  
创建快捷方式, 里面加参数`--wsl`, 可选参数`--frame none --maximized`

打开neovim, 使用`:checkhealth`命令, 检查安装情况

可以装pynvim插件
```
sudo apt-get update
sudo apt-get -y install python3-pip
pip3 --version
pip3 install pynvim 或 pip3 install --upgrade pynvim
```

windows下载neovide

# 配置

LazyVim