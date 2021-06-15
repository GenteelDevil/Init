#!/bin/bash

necessory_software=("git" "vim" "zsh" "tmux")

echo "$USER, welcome to your new device!"
# 比较日期更新更新源
echo -e "\033[31m[ * ] ready to update source file\033[0m"
today=$(date +%y-%m-%d)
update_time=$(echo $(ls -l --full-time /etc/apt/sources.list) | sed 's/.* [0-9][0-9]\([0-9]*-[0-9]*-[0-9]*\).*/\1/g')
if [ "$today" != "$update_time" ]
then
    sudo apt-get -y update
else
    echo -e "\033[31m[ * ]\033[0m source.list has been updated today."
fi

# 遍历下载自定义软件包
for package in ${necessory_software[*]}
do 
    if ! [ -x "$(command -v $package)" ]; then
        echo -e "\033[31m [ ! ]\033[0m $package not installed"
        sudo apt-get install -y $package
    else 
        echo -e "\033[31m [ - ]\033[0m $package installed"

    fi
done

# 检查是否为WSL或者虚拟机 设置proxy
echo -e "\033[31m[ * ]\033[0m ready to set proxy"
if [[ "$(uname -a)" == *"Microsoft"* ]]; then
    echo -e "\033[31m [ - ]\033[0m Microsoft WSL detected"
    proxy_loc="http://127.0.0.1:7890"
else 
    echo -e "\033[31m [ - ]\033[0m normal Linux detected"
    host_ip="$(route -n | grep UG | awk '{print $2}' | grep -E -o '([0-9]{1,3}\.){3}')"
    proxy_loc="http://$host_ip""1:7890"
fi
echo -e "\033[31m [ - ]\033[0m set proxy to $proxy_loc"
export https_proxy=$proxy_loc && export http_proxy=$proxy_loc

# 安装oh-my-zsh
echo -e "\033[31m[ * ]\033[0m ready to config zsh"
zsh_config="/home/$USER/.oh-my-zsh"
if [ -d ${zsh_config} ];then
	echo -e "\033[31m [ - ]\033[0m oh-my-zsh already existed."
else
	sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
