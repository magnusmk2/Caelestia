<h1 align=center>Magnus's Caelestia Shell</h1>

<div align=center>

![GitHub last commit](https://img.shields.io/github/last-commit/magnusmk2/Caelestia?style=for-the-badge&labelColor=101418&color=9ccbfb)
![GitHub Repo stars](https://img.shields.io/github/stars/magnusmk2/Caelestia?style=for-the-badge&labelColor=101418&color=b9c8da)
![GitHub repo size](https://img.shields.io/github/repo-size/magnusmk2/Caelestia?style=for-the-badge&labelColor=101418&color=d3bfe6)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&style=for-the-badge&labelColor=101418)](https://github.com/pre-commit/pre-commit)

</div>

> **🚀 Enhanced Fork**: This is Magnus's customized version of Caelestia with advanced network management, monitor information system, and comprehensive development infrastructure.

https://github.com/user-attachments/assets/0840f496-575c-4ca6-83a8-87bb01a85c5f

## ✨ Magnus's Enhancements

This fork includes several custom enhancements beyond the original Caelestia shell:

- **🌐 Advanced Network Management**: Enhanced network information display with connection details
- **🖥️ Monitor Information System**: Comprehensive monitor management with detailed hardware info
- **⚡ BitDepth Service**: Dynamic color depth management for optimal display quality
- **🔧 Development Infrastructure**: Pre-commit hooks, GitHub Actions, and automated quality assurance
- **📊 Performance Monitoring**: Real-time system resource tracking and visualization

## Components

- Widgets: [`Quickshell`](https://quickshell.outfoxxed.me)
- Window manager: [`Hyprland`](https://hyprland.org)
- Original project: [`caelestia-dots`](https://github.com/caelestia-dots)
- Fork maintainer: [`magnusmk2`](https://github.com/magnusmk2)

## Installation

> [!IMPORTANT]
> This is Magnus's enhanced fork with custom network and monitor management features.
> For the original Caelestia installation, see [caelestia-dots](https://github.com/caelestia-dots/caelestia).

### From Source (Recommended)

This enhanced version is best installed from source to get all the custom features and latest improvements:

### Dependencies

- [`caelestia-cli`](https://github.com/caelestia-dots/cli)
- [`quickshell-git`](https://quickshell.outfoxxed.me) - this has to be the git version, not the latest tagged version
- [`ddcutil`](https://github.com/rockowitz/ddcutil)
- [`brightnessctl`](https://github.com/Hummer12007/brightnessctl)
- [`app2unit`](https://github.com/Vladimir-csp/app2unit)
- [`cava`](https://github.com/karlstav/cava)
- [`networkmanager`](https://networkmanager.dev)
- [`lm-sensors`](https://github.com/lm-sensors/lm-sensors)
- [`fish`](https://github.com/fish-shell/fish-shell)
- [`aubio`](https://github.com/aubio/aubio)
- [`libpipewire`](https://pipewire.org)
- `glibc`
- `qt6-declarative`
- `gcc-libs`
- [`material-symbols`](https://fonts.google.com/icons)
- [`caskaydia-cove-nerd`](https://www.nerdfonts.com/font-downloads)
- [`grim`](https://gitlab.freedesktop.org/emersion/grim)
- [`swappy`](https://github.com/jtheoof/swappy)
- [`libqalculate`](https://github.com/Qalculate/libqalculate)

### Installation Steps

1. **Install dependencies** (see list above)

2. **Clone Magnus's enhanced fork**:

```sh
cd $XDG_CONFIG_HOME/quickshell
git clone https://github.com/magnusmk2/Caelestia.git caelestia
cd caelestia
```

3. **Set up development environment** (optional but recommended):

```sh
# Install pre-commit hooks for quality assurance
./setup-precommit.sh
```

4. **Compile the beat detector**:

```sh
g++ -std=c++17 -Wall -Wextra -I/usr/include/pipewire-0.3 -I/usr/include/spa-0.2 -I/usr/include/aubio -o beat_detector assets/cpp/beat-detector.cpp -lpipewire-0.3 -laubio
sudo mkdir -p /usr/lib/caelestia
sudo mv beat_detector /usr/lib/caelestia/beat_detector
```

> [!TIP]
> The beat detector can actually be installed anywhere. However, if it is not installed to the default
> location of `/usr/lib/caelestia/beat_detector`, you must set the environment variable `CAELESTIA_BD_PATH`
> to wherever you have installed the beat detector.

## Usage

The shell can be started via the `caelestia shell -d` command or `qs -c caelestia`.
If the entire caelestia dots are installed, the shell will be autostarted on login
via an `exec-once` in the hyprland config.

### Shortcuts/IPC

All keybinds are accessible via Hyprland [global shortcuts](https://wiki.hyprland.org/Configuring/Binds/#dbus-global-shortcuts).
If using the entire caelestia dots, the keybinds are already configured for you.
Otherwise, [this file](https://github.com/caelestia-dots/caelestia/blob/main/hypr/hyprland/keybinds.conf#L1-L39)
contains an example on how to use global shortcuts.

All IPC commands can be accessed via `caelestia shell ...`. For example

```sh
caelestia shell mpris getActive trackTitle
```

The list of IPC commands can be shown via `caelestia shell -s`:

```
$ caelestia shell -s
target drawers
  function toggle(drawer: string): void
  function list(): string
target notifs
  function clear(): void
target lock
  function lock(): void
  function unlock(): void
  function isLocked(): bool
target mpris
  function playPause(): void
  function getActive(prop: string): string
  function next(): void
  function stop(): void
  function play(): void
  function list(): string
  function pause(): void
  function previous(): void
target picker
  function openFreeze(): void
  function open(): void
target wallpaper
  function set(path: string): void
  function get(): string
  function list(): string
```

### PFP/Wallpapers

The profile picture for the dashboard is read from the file `~/.face`, so to set
it you can copy your image to there or set it via the dashboard.

The wallpapers for the wallpaper switcher are read from `~/Pictures/Wallpapers`
by default. To change it, change the wallpapers path in `~/.config/caelestia/shell.json`.

To set the wallpaper, you can use the command `caelestia wallpaper`. Use `caelestia wallpaper -h` for more info about
the command.

## Updating

To update Magnus's enhanced fork:

```sh
cd $XDG_CONFIG_HOME/quickshell/caelestia
git pull origin main
```

> [!TIP]
> If you have pre-commit hooks installed, they will automatically validate any changes during updates.

## 🔧 Development & Contributing

This fork includes comprehensive development infrastructure:

### Pre-commit Hooks

- **Automatic code formatting** with Prettier
- **Syntax validation** for YAML, JSON, XML files
- **Structure validation** ensuring required directories exist
- **Custom validation** for Magnus's network/monitor enhancements
- **Commit message standards** using conventional commits
- **Performance**: ~1.3 seconds execution time

### GitHub Actions Workflows

- **build-and-test**: Nix flake validation and build testing
- **lint-qml**: QML code quality checks
- **validate-structure**: Project structure verification
- **check-customizations**: Validation of custom enhancements

### Setting Up Development Environment

```sh
# Install pre-commit hooks (recommended for contributors)
./setup-precommit.sh

# Manual pre-commit installation
pip install pre-commit
pre-commit install
```

## Configuring

All configuration options should be put in `~/.config/caelestia/shell.json`. This file is _not_ created by
default, you must create it manually.

> [!NOTE]
> The example configuration only includes recommended configuration options. For more advanced customisation
> such as modifying the size of individual items or changing constants in the code, there are some other
> options which can be found in the source files in the `config` directory.

<details><summary>Example configuration</summary>

```json
{
  "appearance": {
    "anim": {
      "durations": {
        "scale": 1
      }
    },
    "font": {
      "family": {
        "material": "Material Symbols Rounded",
        "mono": "CaskaydiaCove NF",
        "sans": "Rubik"
      },
      "size": {
        "scale": 1
      }
    },
    "padding": {
      "scale": 1
    },
    "rounding": {
      "scale": 1
    },
    "spacing": {
      "scale": 1
    },
    "transparency": {
      "enabled": false,
      "base": 0.85,
      "layers": 0.4
    }
  },
  "general": {
    "apps": {
      "terminal": ["foot"],
      "audio": ["pavucontrol"]
    }
  },
  "background": {
    "desktopClock": {
      "enabled": false
    },
    "enabled": true,
    "visualiser": {
      "enabled": true,
      "autoHide": true,
      "rounding": 1,
      "spacing": 1
    }
  },
  "bar": {
    "dragThreshold": 20,
    "entries": [
      {
        "id": "logo",
        "enabled": true
      },
      {
        "id": "workspaces",
        "enabled": true
      },
      {
        "id": "spacer",
        "enabled": true
      },
      {
        "id": "activeWindow",
        "enabled": true
      },
      {
        "id": "spacer",
        "enabled": true
      },
      {
        "id": "tray",
        "enabled": true
      },
      {
        "id": "clock",
        "enabled": true
      },
      {
        "id": "statusIcons",
        "enabled": true
      },
      {
        "id": "power",
        "enabled": true
      },
      {
        "id": "idleInhibitor",
        "enabled": false
      }
    ],
    "persistent": true,
    "showOnHover": true,
    "status": {
      "showAudio": false,
      "showBattery": true,
      "showBluetooth": true,
      "showKbLayout": false,
      "showNetwork": true
    },
    "tray": {
      "background": false,
      "recolour": false
    },
    "workspaces": {
      "activeIndicator": true,
      "activeLabel": "󰮯",
      "activeTrail": false,
      "label": "  ",
      "occupiedBg": false,
      "occupiedLabel": "󰮯",
      "perMonitorWorkspaces": true,
      "showWindows": true,
      "shown": 5
    }
  },
  "border": {
    "rounding": 25,
    "thickness": 10
  },
  "dashboard": {
    "enabled": true,
    "dragThreshold": 50,
    "mediaUpdateInterval": 500,
    "showOnHover": true
  },
  "launcher": {
    "actionPrefix": ">",
    "dragThreshold": 50,
    "vimKeybinds": false,
    "enableDangerousActions": false,
    "maxShown": 8,
    "maxWallpapers": 9,
    "specialPrefix": "@",
    "useFuzzy": {
      "apps": false,
      "actions": false,
      "schemes": false,
      "variants": false,
      "wallpapers": false
    }
  },
  "lock": {
    "recolourLogo": false
  },
  "notifs": {
    "actionOnClick": false,
    "clearThreshold": 0.3,
    "defaultExpireTimeout": 5000,
    "expandThreshold": 20,
    "expire": false
  },
  "osd": {
    "hideDelay": 2000
  },
  "paths": {
    "mediaGif": "root:/assets/bongocat.gif",
    "sessionGif": "root:/assets/kurukuru.gif",
    "wallpaperDir": "~/Pictures/Wallpapers"
  },
  "services": {
    "audioIncrement": 0.1,
    "defaultPlayer": "Spotify",
    "gpuType": "",
    "playerAliases": [
      {
        "com.github.th_ch.youtube_music": "YT Music"
      }
    ],
    "weatherLocation": "",
    "useFahrenheit": false,
    "useTwelveHourClock": false,
    "smartScheme": true,
    "visualiserBars": 45
  },
  "session": {
    "dragThreshold": 30,
    "vimKeybinds": false,
    "commands": {
      "logout": ["loginctl", "terminate-user", ""],
      "shutdown": ["systemctl", "poweroff"],
      "hibernate": ["systemctl", "hibernate"],
      "reboot": ["systemctl", "reboot"]
    }
  }
}
```

</details>

## FAQ

### My screen is flickering, help pls!

Try disabling VRR in the hyprland config. You can do this by adding the following to `~/.config/caelestia/hypr-user.conf`:

```conf
misc {
    vrr = 0
}
```

### I want to make my own changes to the hyprland config!

You can add your custom hyprland configs to `~/.config/caelestia/hypr-user.conf`.

### I want to make my own changes to other stuff!

See the [manual installation](https://github.com/caelestia-dots/shell?tab=readme-ov-file#manual-installation) section
for the corresponding repo.

### I want to disable XXX feature!

Please read the [configuring](https://github.com/caelestia-dots/shell?tab=readme-ov-file#configuring) section in the readme.
If there is no corresponding option, make feature request.

### How do I make my colour scheme change with my wallpaper?

Set a wallpaper via the launcher or `caelestia wallpaper` and set the scheme to the dynamic scheme via the launcher
or `caelestia scheme set`. e.g.

```sh
caelestia wallpaper -f <path/to/file>
caelestia scheme set -n dynamic
```

### My wallpapers aren't showing up in the launcher!

The launcher pulls wallpapers from `~/Pictures/Wallpapers` by default. You can change this in the config. Additionally,
the launcher only shows an odd number of wallpapers at one time. If you only have 2 wallpapers, consider getting more
(or just putting one).

## Credits

### Original Caelestia Project

This fork is based on the excellent work by the [Caelestia team](https://github.com/caelestia-dots):

- Original shell design and implementation
- Core QuickShell integration
- Base system services and components

### Magnus's Enhancements

- **🌐 Network Management System**: Advanced network information display and connection management
- **🖥️ Monitor Information Service**: Comprehensive monitor hardware detection and management
- **⚡ BitDepth Service**: Dynamic color depth optimization for display quality
- **🔧 Development Infrastructure**: Pre-commit hooks, GitHub Actions, automated quality assurance
- **📊 Performance Monitoring**: Enhanced system resource tracking and visualization

### Community Thanks

Thanks to the Hyprland discord community (especially the homies in #rice-discussion) for all the help and suggestions
for improving these dots!

A special thanks to [@outfoxxed](https://github.com/outfoxxed) for making Quickshell and the effort put into fixing issues
and implementing various feature requests.

Another special thanks to [@end_4](https://github.com/end-4) for his [config](https://github.com/end-4/dots-hyprland)
which helped with learning how to use Quickshell.

### Inspiration Sources

- [Axenide/Ax-Shell](https://github.com/Axenide/Ax-Shell)
- [caelestia-dots/shell](https://github.com/caelestia-dots/shell) - Original project

## Repository Stats 📈

<a href="https://www.star-history.com/#magnusmk2/Caelestia&caelestia-dots/shell&Date">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=magnusmk2/Caelestia,caelestia-dots/shell&type=Date&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=magnusmk2/Caelestia,caelestia-dots/shell&type=Date" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=magnusmk2/Caelestia,caelestia-dots/shell&type=Date" />
 </picture>
</a>

---

<div align="center">

**🚀 Enhanced by Magnus** | **⭐ Based on Caelestia** | **🔧 Powered by QuickShell**

</div>
