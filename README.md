# AHK v2 Script for Heroes of Hammerwatch 2.

## Features

- Provides a Skill UI to show Skill Cooldowns just beneath your character.
- Individual skill trackers are toggleable
- Supports 2 or 3 skills
- Shows when Right Click is channelling
- Currently supports 2560x1440p out of the box, other resolutions must be customized (though I can update the script if I receive the particular positions)

![Skill UI](https://github.com/user-attachments/assets/b59c2164-1a88-427b-828f-26489ebd43ef)

The program works by using AHK's sampling features to check pixel colour and compares brightness (yellowish to be available, greyish to be unavailable).

For resolutions other than 2560x1440p, you will have to configure which pixels to be sampled (5 pixel coordinates, one for each skill, and an extra one for checking if right click is channelling or not) based on your resolution.

These parameters are inside of **skillPositions**, with a unique X position for each skill and a universal **sampleY**. 
The game's UI changes depending if you have 2 skills or less, so there's two configurations required (though you can skip configuring 2 if you always use 3)

## Usage

Once running, by default the UI hides when HOH2 is not in focus. 

F1, F2, F3, and F4 toggle if the skill's UI shows up (e.g., if you only want to see Right Click, or Skill 4, etc)

F5 switches from 3 skill mode to 2 skill mode.

F6 enables channelling for Right Click -- when enabled, the Right Click icon flashes while the skill is held down.

If the UI doesn't show up ever, it might be having trouble detecting when a skill is available (or unavailable if it always shows up and doesn't disappear per skill) 
Brightness, gamma, etc can all interfere with the detection.
Try increasing **threshold** to make it more sensitive, or decrease to reduce sensitivity.

## Installation Instructions:

- Download AHK v2 here: https://www.autohotkey.com/v2/
- Download the AHK_HOH2.ahk script from above

After AHK v2 is installed, double click the script to run it.

You can close the script and AHK by exiting the program via the tray icon.

## Customizable Parameters

Inside of the script, there is a lot that can be customized:
- UI fill size and colours
- Border size and colours
- UI spacing
- Brightness threshold (for detecting when a skill is active or not; some non-standard gamma/brightness settings might require tweaking)
- Whether channelling is enabled by default (currently set to false by default because the channelling pixel shows up in some unintended menus)
- Keybinds for skills 1-4, skill mode (either 2 or 3 skills), channelling toggle

## Custom Resolution Sampling Instructions:
![Skill UI Instructions](https://github.com/user-attachments/assets/36733b8b-faa0-41e7-b3e5-6c90faf201f2)

When sampling, make sure you don't sample *too far* to the left, since it will show the skill as activated when it's at 95% cooldown.

## WIP:

- Need to add custom skill ordering
- Disable channelling pixel from showing up in some menus
