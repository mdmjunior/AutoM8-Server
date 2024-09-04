#!/bin/bash

########################################################
# AutoM8 - Ubuntu Post-Install Automation Tool         #
# Author: Marcio Moreira junior                        #
# email: mdmjunior@gmail.com                           #
# Versão 1.0                                           #
########################################################

check_env() {

    # A função check_env() verifica se a distribuição e release são compatíveis com o AutoM8, que foi desenvolvido em Ubuntu 24.04.
    DISTRO=$(lsb_release -is 2>/dev/null)
    RELEASE=$(lsb_release -rs 2>/dev/null)
    USERNM=$(whoami)

    if [ "$DISTRO" != "Ubuntu" ] || [[ $(echo"$RELEASE 24.04" | awk '{print ($1 >= $2)}') -eq 0 ]]; then
        echo "Distribuição: $DISTRO"
        echo "Release: $RELEASE"
        echo "No momento o AutoM8 suporta somente Ubuntu a partir da versão 24.04."
        exit 1
    fi

    clear
    echo "                                                        "
    echo "                                                        "
    echo "   █████╗ ██╗   ██╗████████╗ ██████╗ ███╗   ███╗ █████╗ "
    echo "  ██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗████╗ ████║██╔══██╗"
    echo "  ███████║██║   ██║   ██║   ██║   ██║██╔████╔██║╚█████╔╝"
    echo "  ██╔══██║██║   ██║   ██║   ██║   ██║██║╚██╔╝██║██╔══██╗"
    echo "  ██║  ██║╚██████╔╝   ██║   ╚██████╔╝██║ ╚═╝ ██║╚█████╔╝"
    echo "  ╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝ ╚═╝     ╚═╝ ╚════╝ "
    echo "                                                        "
    echo "              Ubuntu Post-Installation Tool             "
    echo "       https://marciomoreirajunior.com.br/AutoM8/       "

}

install_desktop() {
    echo "INICIANDO INSTALAÇÃO OTIMIZADA PARA DESKTOP"
    echo "O script irá preparar o seu sistema operacional, aguarde."
    echo -e "\e[32mDISTRO: $DISTRO\e[0m"
    echo -e "\e[32mRELEASE: $RELEASE\e[0m"
    echo -e "\e[32mUSUARIO: $USERNM\e[0m"
    sudo systemctl daemon-reload

    # Atualiza os repositórios e o sistema operacional  teste
    if [ "$USERNM" == "root" ]; then
        echo "Esse script deve ser executado com o seu usuario, $USERNM"
        exit 1
    else
        echo "ATUALIZANDO OS REPOSITÓRIOS E PACOTES DO SO"
        echo "Seu usuário não tem privilégios de root, digite a senha para elevação: "
        sudo apt update && sudo apt upgrade -y
        echo -e "\e[32mAtualização do sistema operacional finalizada.\e[0m"
    fi

    echo "INSTALANDO PACOTES BÁSICOS"
    sudo apt install -y ntpdate vim net-tools iproute2 curl sshpass ethtool wget links htop iotop openssh-server openssl gpg 
    echo -e "\e[32mPacotes instalados\e[0m"

    echo "INSTANDO REPOSITÓRIO DOCKER"
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update

    echo "INSTALANDO FERRAMENTAS DE COMPACTAÇÃO DE ARQUIVOS"
    sudo apt install -y rar unrar bzip2 tar unzip
    echo -e "\e[32mPacotes instalados\e[0m"

    echo "INSTALANDO PACOTES DE FILESYSTEMS"
    sudo apt install -y zfsutils-linux
    echo -e "\e[32mPacotes instalados\e[0m"

    echo "INSTALANDO FERRAMENTAS DE REDE"
    sudo apt install -y tcpdump iptables iptables-persistent traceroute
    echo -e "\e[32mPacotes instalados\e[0m"

    echo "INSTALANDO FERRAMENTAS DE DESENVOLVIMENTO"
    sudo apt install -y apt-transport-https ca-certificates git ruby python3 python3-pip 
    echo -e "\e[32mPacotes Instalados\e[0m"

    echo "ATUALIZANDO EDITOR DE TEXTO PADRÃO"
    sudo update-alternatives --install /usr/bin/editor editor /usr/bin/vim.basic 1
    sudo update-alternatives --set editor /usr/bin/vim.basic

    # Adicionando usuário ao sudo sem senha
    echo "ADICIONANDO USUÁRIO AO SUDOERS"
    echo "%mmoreira ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers

    # Configurando SSH
    echo "CONFIGURANDO SSH SERVER PARA PERMITIR LOGIN COM CHAVE"
    sudo sed -i 's/#PubkeyAuthentication/PubkeyAuthentication/g' /etc/ssh/sshd_config
    echo "Reiniciando serviço SSHD"
    sudo systemctl restart ssh

    echo "SISTEMA PRONTO PARA USO"
    exit
}

install_server() {
    echo "Função de instalação do servidor ainda não implementada"
    exit 1
}

# Chamar a função check_env
check_env
