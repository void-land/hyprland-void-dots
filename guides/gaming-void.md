# Gaming Guide with GameMode and MangoHud on Void Linux

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

## Setup Ps4 Controller via Bluetooth

The bluez and bluetoothd service need to setup.

Add current user to input,bluetooth group.

```bash
sudo usermod -aG bluetooth,input hesam
```

Inside this file : /etc/bluetooth/main.conf
edit ControllerMode to bredr

## Run Steam games with GameMode and MangoHud and GameScope

Modify the game's launch options on Steam to use the created script. Right-click on the game in your Steam Library, choose "Properties," and under the "General" tab, click on "Set Launch Options." Enter the following command:

- Enable GameMode :
  ```gamemoderun %command%```

- Enable MangoHud :
  - ```env MANGOHUD=1 %command%```
  - ```mangohud %command%```

- Enable GameScope :
  - with fsr : ```gamescope -f -F fsr -- %command%```
  - with gamemode : ```gamemoderun gamescope -f -F fsr -- %command%```

  - downscale resolution :
    - ```gamescope -f -F fsr -w 1980 -h 1080 -W 1600 -H 900 -- %command%```
    - ```gamescope -f -F fsr -w 3440 -h 1440 -W 1600 -H 900 -- %command%```

  - upscale resolution : ```gamescope -f -F fsr -w 1280 -h 720 -W 1600 -H 900 -S integer -- %command%```

  - fps cap : ```gamescope -f -F fsr -r 30 -- %command%```


## Disable Fps Cap on Valve Game

```bash
gamemoderun mangohud %command% +fps_max 0
```
