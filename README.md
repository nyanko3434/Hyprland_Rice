# Hyprland Rice / My Dotfiles

Config files for my Arch Linux + Hyprland setup.  
These dotfiles let me version, sync, and deploy my setup easily across machines.

---

## 📁 Repository Structure

```text
Hyprland_Rice/
├── dotfiles/
│ └── .config/
│ ├── hypr/
│ │ ├── scripts/
│ │ ├── wallpapers/
│ │ ├── hypridle.conf
│ │ ├── hyprland.conf
│ │ ├── hyprpaper.conf
│ │ └── hyprsunset.conf
│ │
│ ├── kitty/
│ │ ├── GruvBox_Darkhard.conf
│ │ ├── kitty.conf
│ │ ├── kitty.conf.bak
│ │ └── kitty.conf.original
│ │
│ ├── swaylock/
│ │ └── config
│ │
│ ├── waybar/
│ │ ├── scripts/
│ │ ├── config
│ │ ├── modules.json
│ │ ├── power_menu.xml
│ │ └── style.css
│ │
│ ├── wlogout/
│ │ ├── icons/
│ │ ├── colors.css
│ │ ├── layout
│ │ └── style.css
│ │
│ └── wofi/
│ ├── config
│ └── style.css
│
├── README.md
└── stow.sh
```

---

## 🖼 Screenshots / Preview

Here are a few images from my Hyprland setup:

### 🧠 Hyprland Overview
![Window Layout](images/window.png)

### 🔔 Waybar
![Waybar Preview](https://github.com/nyanko3434/Hyprland_Rice/blob/main/Images/waybar.png?raw=true)

### 🐈 Terminal (Kitty)
![Terminal Preview](images/terminal.png)

### 🔍 Wofi Menu
![Wofi Preview](images/wofi.png)

### 🔒 Swaylock
![Swaylock Preview](images/swaylock.png)

## 🛠 Installation / Bootstrap

To set up your config on a new machine:

```bash
# Clone the repo
git clone https://github.com/yourusername/Hyprland_Rice.git ~/Hyprland_Rice
cd ~/Hyprland_Rice

# Run the install / bootstrap script (for example using stow)
./stow.sh
```
Note :
Requiers stow package<br>
For Arch Users
```bash
yay -S stow
```
Modify stow.sh according to location of clone repo
```text
stow -d [Clone repo location] -t ~/ dotfiles
```
