# GUIDA DE INSTALAÇÃO PT-BR

## Pré requisitos

- Pendrive ou CD com a imagem
- Conexão de rede

### Grave a imagem

Use o Rufus se estiver no Windows para ter 100% de certeza que irá funcionar.

Exemplos para caso esteja no Linux.

    fdisk -l \\ Irá listar seus disposítivos
    dd if=arch.iso of=/dev/sdx status=progress

### Boot

Reinicie o maquina e de boot, não esqueça de escolher corretamente entre o inicio com UEFI ou sem.

## Instalação

### Setup

Configure seu teclado caso não seja do modelo americano, ex:

    loadkeys br-abnt2

Se você está usando Ethernet o Arch já habilitou isso pra você no inicio do sistema.

Caso esteja usando wireless, configure com:

    wifi-menu

Teste a conexão com.

    ping -c3 www.github.com

Baixe os novos mirros ordenamos por região (esse passo não é obrigatório mas recomendo muito).

    cd /etc/pacman.d/
    wget www.archlinux.org/mirrorlist/all
    mv all mirrorlist
    nano mirrorlist

Ao entrar no editor busque pelo seu continente/país e descomente os mirrors desejados.

### Disco

Você pode listar suas unidades de disco com o comando citado no primeiro no passo de gravação da imagem.

Entre no cfdisk para configurar suas partições.

    cfdisk /dev/sdx

#### Particionamento

Cire uma partição boot de no mínimo 120M (você não vai usar mais do que isso).

    /boot EFI System 

Você pode querer usar uma partição SWAP, recomendo que se assim como eu consuma normalmente mais de 80% da RAM, crie uma partição de 4GB.

    /swap Linux swap

Pasta para o sistema, se não for separar sua pasta home, o sistema em si vai não vai consumir mais de 8GB, se você quiser instalar coisas pode querer separar pelo menos 90GB.

    /     Linux filesystem

Pasta home

Formate as partições (as numerações vão depender da ordem que você criou).

    mkfs.fat -F32 -n BOOT /dev/sda1
    mkfs.ext4 /dev/sda2

Monte as partições.

    mount /dev/sda2 /mnt
    mkdir /mnt/boot
    mount /dev/sda1 /mnt/boot

Essa é uma boa demonstração de como podemos facilmente montar partições dentro de sistemas Linux.

### Instale os pacotes básicos

linux-lts é opicional mas você só tem a ganhar, o Arch é conhecido por atualizações bobas que podem fazer seu Wi-Fi parar de funcionar (embora o motivo disso seja também um atrativo), o é bom ter uma versão LTS do Kernel para dar boot caso necessário.

    pacstrap /mnt linux linux-lts linux-firmware base base-devel nano

### Crie o arquivo de referência para montagem das partições no Start

    genfstab /mnt >> /mnt/etc/fstab

### Entre no chroot

O arch possuí seu próprio chroot.

    arch-chroot /

### Configure seu idioma preferido

Descomente os idiomas que pretente usar.

    nano /etc/locale.gen

Gere o locale.

    locale-gen

Exporte a configuração e aplique as mudanças antes de reiniciar export, ex:

    export LANG=pt_BR.UTF-8

Configure para o próximo reincio

    echo "LANG=pt_BR.UTF-8" >> /etc/locale.conf

### Configurações de teclado para o próximo reinicio

Essa configuração habilitara br-abnt2 para o sistema fora da interface gráfica.

    echo "KEYMAP=br-abnt2" >> /etc/vconsole.conf

Configure o teclado para interface gráfica e a maioria dos outros softwares.

    localectl set-x11-keymap br abnt2

### Defina seu localtime

Obs: Se você não usa UTC use o segundo comando, se sim, o primeiro.

    ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime

    hwclock --systohc --localtime

### Defina o nome da máquina

    echo "mymachine" >>  /etc/hostname

### Desativar speaker (opicional)

Se você tiver em um desktop com speaker (o beep mesmo), pode querer sumir com esses barulhos irritantes que vem como warning

    echo "blacklist pcspkr" >> "/etc/modprobe.d/nobeep.conf"

### Habilite cores e doces no pacman (opicional)

Edite o arquivo de configuração do pacman, procure por Candy com CTRL + W e descomente essa linha, escreva abaixo mesmo que não, ILoveCandy.

    nano /etc/pacman.conf

Rode uma atualização de pacotes e veja a mágica

    pacman -Syu

### Iniciar ambiente Ramdisk

Carregue o sistema na memória inicialmente com

    mkinitcpio -p linux

### Configure o boot manager

Não vou ensinar a usar o GRUB mas você pode ver na [documentação](https://wiki.archlinux.org/index.php/GRUB) caso queria fazer dual boot fácil com outros sistemas. Se for fazer assim apenas pule esse passo.

Instale o systemd-boot em /boot

    bootctl install

Crie 3 arquivos

/boot/loader/entries/arch.conf

    title Arch Linux
    linux /vmlinuz-linux
    initrd /initramfs-linux.img
    options root=/dev/sda6 rw

/boot/loader/entries/arch-lts.conf

    title Arch LTS
    linux /vmlinuz-linux-lts
    initrd /initramfs-linux.img
    options root=/dev/sda6 rw

/boot/loader/loader.conf

    timeout 2
    default arch

Se quiser que o LTS seja o padrão pode substituir por arch-lts, ele puxará pelo nome do arquivo.

### Crie e configure seu usuário

    useradd -m -g users -G wheel  username

Você pode querer rodar comandos como usuário root por ele, então descomente `%wheel ALL=(ALL) ALL` em `/etc/sudores`.

Configure senhas com

    password username
    password root

Caso vá usar o sudo no seu usuário, o que é muito recomendado, desabilite seu usuário root

    password -l root

Isso irá inspirar a senha do usuário e ele ficará inacessível.

### Conexão com a Internet

Quando iniciarmos o sistema previamente instalado o Arch já não habilitara o Dhcp sozinho, se você só for utilizar conexão cabeada pode sistemente habilitar serviço por padrão.

    systemctl enable dhcpcd

Se for utilizar Wi-Fi com uma interface gráfica como Gnome ou KDE instale o NetworkManager.

    pacman -S networkmanager
    pacman -S network-manager-applet (Interfaces mais simples como XFCE vão precisar)
    systemctl enable NetworkManager

### Instalando o Gnome

Você pode simplesmente rodar

    pacman -S gnome gnome-extras
    systemctl enable gdm

Mas se você odiar pacotes inuteis como eu, vai preferir rodar:

    sudo pacman -S gnome-shell gnome-control-center gdm gnome-terminal gnome-shell-extensions gnome-settings-daemon gnome-menus gnome-keyring
    systemctl enable gdm

### Reinicie o sistema

Saia do chroot, desmonte as partições e reinicie

    exit
    umount -R /mnt
    reboot

### Divirta-se
