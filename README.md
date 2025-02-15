# Darktide HUD Buff Stacks Mod

A HUD mod to show darktide stacks

Requires [Darktide Mod Loader](https://github.com/Darktide-Mod-Framework/Darktide-Mod-Loader), installation instructions are also in that project.

This mod will by default display all buffs (and debuffs) that have multiple stacks and have a limited duration. You may disable any of them in the mod options. You may also modify their display colour and whether they will display their labels.

If you want to change the display labels, you can change it in `scripts\mods\BuffStackHUD\BuffStackHUD_localization.lua`

You may add more buffs by adding their entries into `scripts\mods\BuffStackHUD\BuffStackHUD_localization.lua` (It must use localization file because it will be loaded first and is the only chance for their localization entries to be loaded in). By adding individual entries into `local override_buffs` or grouping multiple buffs into a single setting and display label using `mod.group_overrides`

This mod by defaults display up to 6 buffs, you can increase this by changing `buff_count` variable in `scripts\mods\BuffStackHUD\HudElementStackBuff.lua`, note modifying the layout like this may overlap with other elements.