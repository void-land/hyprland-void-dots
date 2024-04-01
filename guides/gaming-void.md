# Gaming guide with GameMode and MangoHud on void linux

## Prerequisites

- Steam : steam
- Lutris : lutris
- Gamehub : gamehub
- Heroic Games Launcher : ["heroic"](https://heroicgameslauncher.com/)
- Emulation apps : rpcs3 - rpcsx2
- Steam Libs : libgcc-32bit libstdc++-32bit libdrm-32bit libglvnd-32bit mesa-dri-32bit
- GameMode : gamemode gamescope
- MangoHud : MangoHud MangoHud-32bit
- Vulkan Libs : Vulkan-Headers Vulkan-Tools Vulkan-ValidationLayers-32bit mesa-vulkan-radeon mesa-vulkan-radeon-32bit vulkan-loader vulkan-loader-32bit libspa-vulkan libspa-vulkan-32bit amdvlk

## Setup Ps4 controller via bluetooth

The bluez and bluetoothd service need to setup.

Add current user to input,bluetooth group.

```bash
sudo usermod -aG bluetooth,input hesam
```

Inside this file : /etc/bluetooth/main.conf
edit ControllerMode to bredr

## Run steam games with GameMode and MangoHud and GameScope

Modify the game's launch options on Steam to use the created script. Right-click on the game in your Steam Library, choose "Properties," and under the "General" tab, click on "Set Launch Options." Enter the following command:

- Enable GameMode :
  ```gamemoderun %command%```

- Enable MangoHud :
  - ```MANGOHUD=1 %command%```
  - ```mangohud %command%```

- Enable GameScope :
  - run fullscreen : ```gamescope -f -- %command%```
  - with fsr : ```gamescope -F fsr | nis -- %command%```
  - with gamemode and manoghud : ```MANGOHUD=1 gamescope -- gamemoderun %command%```

  - downscale resolution :
    - ```gamescope fsr -w 1980 -h 1080 -W 1600 -H 900 -- %command%```
    - ```gamescope fsr -w 3440 -h 1440 -W 1600 -H 900 -- %command%```

  - upscale resolution : ```gamescope -w 1280 -h 720 -W 1600 -H 900 -S integer -- %command%```

  - fps cap : ```gamescope -r 30 -- %command%```

## Example command

```bash
MANGOHUD=1 gamescope -W 1980 -H 1080 -r 75 -s 0.4 -f -e -F fsr -- gamemoderun %command%
```
