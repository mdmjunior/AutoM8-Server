#!/bin/bash

########################################################
# AutoM8 - Linux Server Post-Install Automation Tool   #
# Author: Marcio Moreira junior                        #
# email: mdmjunior@gmail.com                           #
# Versão 1.0                                           #
########################################################

check_env() {
 
    # A função check_env() verifica se a distribuição e release são compatíveis com o AutoM8, que foi desenvolvido em Ubuntu 24.04.
    DISTRO=$(lsb_release -is 2>/dev/null)
    RELEASE=$(lsb_release -rs 2>/dev/null)
    #CODENAME=$(lsb_release -cs 2>/dev/null)
    USERNM=$(whoami)
    HOSTNAME=$(hostnamectl hostname)

    clear
    echo "                                                        "
    echo "   █████╗ ██╗   ██╗████████╗ ██████╗ ███╗   ███╗ █████╗ "
    echo "  ██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗████╗ ████║██╔══██╗"
    echo "  ███████║██║   ██║   ██║   ██║   ██║██╔████╔██║╚█████╔╝"
    echo "  ██╔══██║██║   ██║   ██║   ██║   ██║██║╚██╔╝██║██╔══██╗"
    echo "  ██║  ██║╚██████╔╝   ██║   ╚██████╔╝██║ ╚═╝ ██║╚█████╔╝"
    echo "  ╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝ ╚═╝     ╚═╝ ╚════╝ "
    echo "                  Linux Automation Tool                 "

    # Verifica se a distribuição é compatível
    if [ "$DISTRO" != "Ubuntu" ]; then
        echo "Distribuição: $DISTRO"
        echo "No momento o AutoM8 suporta somente Ubuntu a partir da versão 20.04."
        exit 1
    fi

    if [[ $(echo "$RELEASE 20.04" | awk '{print ($1 >= $2)}') -eq 0 ]]; then
        echo "Release: $RELEASE"
        echo "No momento o AutoM8 suporta somente Ubuntu a partir da versão 20.04."
        exit 1
    fi

    install_server
}

install_server() {
    echo "INICIANDO INSTALAÇÃO OTIMIZADA PARA SERVIDOR"
    echo "O script irá preparar o seu sistema operacional, aguarde."
    echo -e "\e[32mDISTRO: $DISTRO\e[0m"
    echo -e "\e[32mRELEASE: $RELEASE\e[0m"
    echo -e "\e[32mUSUARIO: $USERNM\e[0m"
    sudo systemctl daemon-reload

    # Atualiza os repositórios e o sistema operacional
    if [ "$USERNM" == "root" ]; then
        echo "Esse script deve ser executado com o seu usuario, $USERNM"
        exit 1
    fi

    echo "ATUALIZANDO OS REPOSITÓRIOS E PACOTES DO SO"
    echo "Seu usuário não tem privilégios de root, digite a senha para elevação: "
    sudo apt update && sudo apt upgrade -y
    echo -e "\e[32mAtualização do sistema operacional finalizada.\e[0m"

    echo "Defina o hostname do servidor: "
    read -r SERVER_HOST
    sudo hostnamectl hostname "$SERVER_HOST"
    sed -i "s/$HOSTNAME/$SERVER_HOST/g" /etc/hosts

    # Configurando SSH
    echo "CONFIGURANDO SSH SERVER PARA PERMITIR LOGIN COM CHAVE"
    sudo sed -i 's/#PubkeyAuthentication/PubkeyAuthentication/g' /etc/ssh/sshd_config
    echo "Reiniciando serviço SSHD"
    sudo systemctl restart ssh

    # Adicionando usuário ao sudo sem senha
    echo "ADICIONANDO USUÁRIO AO SUDOERS"
    echo "%$USERNM ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers

    echo "SISTEMA PRONTO PARA USO"
    exit
}

# Chamar a função check_env
check_env
