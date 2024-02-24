# Steam Gaming Guide with GameMode and MangoHud on Void Linux

## Prerequisites

- Steam installed : steam
- Steam Libs installed : libgcc-32bit libstdc++-32bit libdrm-32bit libglvnd-32bit mesa-dri-32bit
- GameMode installed : gamemode
- MangoHud installed : MangoHud

## Run Steam games with GameMode and MangoHud

Modify the game's launch options on Steam to use the created script. Right-click on the game in your Steam Library, choose "Properties," and under the "General" tab, click on "Set Launch Options." Enter the following command:

```bash
gamemoderun mangohud %command%
```