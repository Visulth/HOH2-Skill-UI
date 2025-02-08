# AHK v2 Script for Heroes of Hammerwatch 2.

## Provides a Skill UI to show Skill Cooldowns just beneath your character.

![Skill UI](https://github.com/user-attachments/assets/b59c2164-1a88-427b-828f-26489ebd43ef)

The program works by using AHK's sampling features to check pixel colour and compares brightness (yellowish to be available, greyish to be unavailable).

You will have to configure which pixels to be sampled (4 pixel coordinates, one for each skill) based on your resolution.

These parameters are inside of **skillData** called **sampleX** and **sampleY**

By default this program works on my resolution of 2560x1440.

## Sampling Instructions:
![Skill UI Instructions](https://github.com/user-attachments/assets/36733b8b-faa0-41e7-b3e5-6c90faf201f2)

## Installation Instructions:

Download AHK v2 here: https://www.autohotkey.com/v2/

After installing, double click the script to run it.

You can close the script and AHK by exiting the program via the tray icon.

## WIP:

- Need to add custom skill ordering
