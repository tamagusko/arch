#!/usr/bin/env bash

# based on https://github.com/johnynfulleffect/ArchMatic

VERSION="0.3.0"
DATE="2022-06-30"
AUTHOR="Tiago Tamagusko"
CONTACT="tamagusko@gmail.com"

echo "-------------------------------------------------"
echo "Arch Linux custom configuration v$VERSION ($DATE)"
echo "by $AUTHOR <$CONTACT>"
echo "-------------------------------------------------"

# update packages
echo
echo "UPDATING PACKAGES"
echo
sudo pacman -S archlinux-keyring && sudo pacman -Syu

# install extra softwares
echo
echo "INSTALLING EXTRA SOFTWARES"
echo

PKGS=(
    'python38'
    'skype'
    'zoom'
    'unzip'
    'heroku-cli'
    'timeshift'
    'papirus-icon-theme'
    'vim'
    'zsh'
    'oh-my-zsh-git'
    'fzf'
    'zsh-autosuggestions'
    'zsh-syntax-highlighting'
    'fail2ban'
    'xed'
    'code'
    'hunspell'
    'hunspell-en_us'
    'hunspell-pt-br'
    'okular'
    'dropbox'
    'vlc'
    'TeXstudio'
    'ghostwriter'
    'gnome-pomodoro'
    'hardiinfo'
    'htop'
    'gtop'
    'speedtest-cli'
    'slack-desktop'
    'p7zip'
    'unrar'
    'ufw' # firewall
)

for PKG in "${PKGS[@]}"; do
    echo "INSTALLING: ${PKG}"
    sudo pacman -S "$PKG" --noconfirm --needed
done

# solve oh my zsh themes loading bug
echo
echo "SOLVE OH MY ZSH THEMES BUG"
echo

sudo pacman -R grml-zsh-config

# add shortcuts
echo
echo "Add shortcuts"
echo

# application shortcuts
xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p '/commands/custom/<Primary><Alt>t' -s xfce4-terminal
xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p '/commands/custom/<Super>t' -s xfce4-terminal --drop-down
xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p '/commands/custom/<Primary><Alt>e' -s thunar
xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p '/commands/custom/<Super>v' -s code
xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p '/commands/custom/<Primary><Alt>p' -s gnome-pomodoro
xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p '/commands/custom/<Primary>>space' -s xfce4-popup-whiskermenu

# window manager shortcuts
xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p '/commands/custom/<Primary>q' -s close_window_key
xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p '/commands/custom/<Super>Left' -s tile_left_key
xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p '/commands/custom/<Super>Right' -s tile_right_key
xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p '/commands/custom/<Super>Up' -s tile_up_key
xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p '/commands/custom/<Super>Down' -s tile_down_key
xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p '/commands/custom/<Primary>Left' -s move_window_left_workspace_key
xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p '/commands/custom/<Primary>Right' -s move_window_right_workspace_key
xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p '/commands/custom/<Alt>Left' -s left_workspace_key
xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p '/commands/custom/<Alt>Right' -s right_workspace_key
xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p '/commands/custom/<Super>Page_Up' -s tile_up_right_key
xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p '/commands/custom/<Super>Page_Down' -s tile_down_right_key
xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p '/commands/custom/<Super>Home' -s tile_up_left_key
xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p '/commands/custom/<Super>End' -s tile_down_left_key

echo "-------------------------------------------------"
echo "Secure Linux                                     "
echo "-------------------------------------------------"

# --- Setup UFW rules
ufw allow 80/tcp
ufw allow 443/tcp
ufw default deny incoming
ufw default allow outgoing
ufw enable

# --- Harden /etc/sysctl.conf
sysctl kernel.modules_disabled=1
sysctl -a
sysctl -A
sysctl mib
sysctl net.ipv4.conf.all.rp_filter
sysctl -a --pattern 'net.ipv4.conf.(eth|wlan)0.arp'

# --- PREVENT IP SPOOFS
cat <<EOF > /etc/host.conf
order bind,hosts
multi on
EOF

# --- Enable ufw
systemctl enable ufw
systemctl start ufw

# --- Enable fail2ban
curl https://raw.githubusercontent.com/johnynfulleffect/secure-linux/master/jail.local -o /etc/fail2ban/jail.local
systemctl enable fail2ban
systemctl start fail2ban

echo "-------------------------------------------------"
echo "Configure zsh                                   "
echo "-------------------------------------------------"

#-- Setup Alias in $HOME/zsh/aliasrc
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>! ~/.zshrc

sudo curl https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -o /usr/share/fonts/TTF/MesloLGS%20NF%20Regular.ttf
sudo chmod 0444 MesloLGS%20NF%20Regular.ttf
sudo curl https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -o /usr/share/fonts/TTF/MesloLGS%20NF%20Bold.ttf
sudo chmod 0444 MesloLGS%20NF%20Bold.ttf
sudo curl https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -o /usr/share/fonts/TTF/MesloLGS%20NF%20Italic.ttf
sudo chmod 0444 MesloLGS%20NF%20Italic.ttf
sudo curl https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -o /usr/share/fonts/TTF/MesloLGS%20NF%20Bold%20Italic.ttf
sudo chmod 0444 MesloLGS%20NF%20Bold%20Italic.ttf

fc-cache

# add zshrc custom aliases
echo 'alias py38=python3.8' >>! ~/.zshrc
echo 'alias cd..="cd .."' >>! ~/.zshrc
echo 'alias h="history"' >>! ~/.zshrc
echo 'alias vi=vim' >>! ~/.zshrc
echo 'alias svi="sudo vim"' >>! ~/.zshrc
echo 'alias srun="python -m uvicorn --port 5000 --host 127.0.0.1 main:app --reload"' >>! ~/.zshrc
echo 'alias yolov5env="source /home/t1/Downloads/yolov5_training_env/bin/activate"' >>! ~/.zshrc
echo 'alias gitignorebig="find . -size +100M | cat >> .gitignore"' >>! ~/.zshrc
echo 'alias venvactivate="source .venv/bin/activate"' >>! ~/.zshrc
echo 'alias venv38create="python3.8 -m virtualenv .venv"' >>! ~/.zshrc
