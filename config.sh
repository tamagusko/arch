#!/usr/bin/env bash

# based on https://github.com/johnynfulleffect/ArchMatic

VERSION="0.1"
AUTHOR="Tiago Tamagusko"
CONTACT="tamagusko@gmail.com"

echo "-------------------------------------------------"
echo "Arch Linux custom configuration v$VERSION"
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
    'linux-lts'
    'skype'
    'zoom'
    'unzip'
    'heroku-cli'
    'timeshift'
    'papirus-icon-theme'
    'vim'
    'zsh'
    'oh-my-zsh-git'
    'spaceship'
    'fzf'
    'zsh-autosuggestions'
    'zsh-syntax-highlighting'
    'xed'
    'code'
    'hunspell'
    'hunspell-en'
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
xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p '/commands/custom/<Primary><Alt>e' -s thunar
xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p '/commands/custom/<Super>v' -s code
xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p '/commands/custom/<Primary><Alt>p' -s gnome-pomodoro
xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p '/commands/custom/<Primary><Super>space' -s xfce4-popup-whiskermenu
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
