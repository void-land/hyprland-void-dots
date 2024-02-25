# Steam Gaming Guide with GameMode and MangoHud on Void Linux

## Prerequisites

- Steam : steam
- Steam Libs : libgcc-32bit libstdc++-32bit libdrm-32bit libglvnd-32bit mesa-dri-32bit
- GameMode : gamemode
- MangoHud : MangoHud MangoHud-32bit
- Vulkan Libs : Vulkan-Headers Vulkan-Tools Vulkan-ValidationLayers-32bit mesa-vulkan-radeon mesa-vulkan-radeon-32bit vulkan-loader vulkan-loader-32bit libspa-vulkan libspa-vulkan-32bit amdvlk

## Run Steam games with GameMode and MangoHud

Modify the game's launch options on Steam to use the created script. Right-click on the game in your Steam Library, choose "Properties," and under the "General" tab, click on "Set Launch Options." Enter the following command:

```bash
gamemoderun mangohud %command% 
```
or

```bash
mangohud gamemoderun  %command%
```

## Disable Fps Cap on Valve Game

```bash
gamemoderun mangohud %command% +fps_max 0
```