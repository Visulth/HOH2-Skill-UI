﻿#Requires AutoHotkey v2.0
#HotIf WinActive("ahk_exe HWR2.exe")

;; -- HOTKEYS TO TOGGLE EACH SKILL'S UI -- ;;

~F1::
{
	skillData[1].enabled := !(skillData[1].enabled)
	InitializeOverlay()
}

~F2::
{
	skillData[2].enabled := !(skillData[2].enabled)
	InitializeOverlay()
}

~F3::
{
	skillData[3].enabled := !(skillData[3].enabled)
	InitializeOverlay()
}

~F4::
{
	skillData[4].enabled := !(skillData[4].enabled)
	InitializeOverlay()
}

;; Switches UI mode between 3 or 4 skills (including right click)
~F5::
{
	global skillsMax
	skillsMax := skillsMax + 1
	
	if (skillsMax > 4)
	{
		skillsMax := 3
	}
	
	InitializeOverlay()
}

~F6::
{
	global detectChannelling
	detectChannelling := !detectChannelling
}

;; -- UI Sizes -- ;;
squareSize := 8 	; Solid fill size in px
borderSize := 3 	; Border thickness in px
spacing := 8 		; Space in px between each skill UI
yOffset := 50 		; Vertical offset from the center of the screen. Increase to move lower.

detectChannelling := false
hideWhenUnfocused := true ; Hides the UI when HOH2 is not focused. Can sometimes hide the UI in unintended situations, so set to false in that case.

;; -- Cooldown Colors -- ;;
;; Change these if you want the skills to remain on-screen when on cooldown
;; Set to "Silver" to be invisible
; cooldownColor := "808080" ; When on CD: Solid Gray
; cooldownColor := "000000" ; When on CD: Solid Black
cooldownColor := "Silver" ; When on CD: Silver for transparency

threshold := 150 ; Brightness threshold for ready skills. 


;; -- Skill Colors -- ;;
skillColors := Map(
    "RightClick", "8B4513",  		; Brown
    "Skill1", "0000FF",      		; Blue
    "Skill2", "FFFF00",      		; Yellow
    "Skill3", "e10000",      		; Red, FF0000, cd0000
	"RightClickShine", "ff7f23",	; Light brown for channelling/shine, ff6a00, db6d1e
	"Skill1Shine", "00feff", 		; Pale Blue  ; d2d2ff, 00feff
	"Skill2Shine", "ffffa9", 		; Pale Yellow, ffffb2, ffffa9
	"Skill3Shine", "FF0000"  		; Light Red, ffc0c0
)

shiningSkills := Map()

;; -- Skill Order -- ;;
;; You can change the order the skills are drawn below, by changing the "order" parameter

skillData := [	
	{ name: "RightClick", order: 1, enabled: true, borderColor: unset, guiColor: unset, wasActive: 0},
    { name: "Skill1", order: 2, enabled: true, borderColor: unset, guiColor: unset, wasActive: 0 },
	{ name: "Skill2", order: 3, enabled: true, borderColor: unset, guiColor: unset, wasActive: 0 },
    { name: "Skill3", order: 4, enabled: true, borderColor: unset, guiColor: unset, wasActive: 0 }
]

;; -- SKILL SAMPLING POSITIONS --
;; Customize the sampled X positions for your resolution (which changes slightly based on how many skills you have specced)
;; These default values of below work on my resolution of 2560x1440.
;; These refer to the X coordinates of the pixel to be sampled to figure out if the skill is on or off cooldown.
;; How to Find Your sampleX and Y:
;;		1. Take a screenshot.
;;		2. Open image in an editor like Photoshop or Gimp
;;		3. Get the x,y coordinates of a single pixel on each skill border.
;;			This should be a pixel along the top edge of each skill border, slightly off-centre.
;;			The Y-value should be the same for all the skills, so you can just worry about the X coordinate.
;; The Channel parameter is a position a few pixels from the 12 o' clock position on the Right Click
;; which indicates if the skill is channelling since the CD freezes when being held.

skillPositions := [
	{skillCount: 3, RightClick: 1125, Skill1: 1505, Skill2: 1598, Skill3: 0, Channel: 1151, sampleY: 1354},
	{skillCount: 4, RightClick: 1090, Skill1: 1466, Skill2: 1557, Skill3: 1652, Channel: 1102, sampleY: 1354}
]

sortedSkills := Map()

centerX := (A_ScreenWidth // 2)
centerY := (A_ScreenHeight // 2) + yOffset

numSkills := 0
skillsMax := 4

global myGui

InitializeOverlay()
{
	; Create GUI
	myGui := Gui(, "Skill Cooldowns")
	
	myGui.Opt("+AlwaysOnTop -Caption +ToolWindow +E0x20")
	;myGui.Opt("+AlwaysOnTop -Caption +E0x8000000 +E0x20")
	
	myGui.BackColor := "Silver"  ; Required for transparency
	WinSetTransColor("Silver", myGui)  ; Make black background fully transparent

	numSkills := 0
	
	for skill in skillData
	{
		if (numSkills = skillsMax)
		{
			skill.enabled := false
		}
	
		if (skill.enabled)
		{
			numSkills++
		}
		
		sortedSkills[skill.order] := skill
	}
	
	numSkills := Min(numSkills, skillsMax)
	
	;MsgBox(numSkills " skills active")

	dotLength := squareSize + (borderSize * 2)
	
	numMargins := Max(numSkills - 1, 0)

	nextXPos := centerX - (((numMargins * spacing) + (numSkills * dotLength))/2)
	;nextXPos := 0
	
	;for skill in skillData
	for order, _skill in sortedSkills
	{
		skill := _skill
		
		if (!skill.enabled)
		{
			skill.guiColor.Opt("Background" "Silver")
			skill.borderColor.Opt("Background" "Silver")
			
			skill.guiColor.Visible := false
			skill.borderColor.Visible := false
			
			continue
		}
	
		xPos := nextXPos
		;xPos := GetSlotXPos(skillOrder[skill.name], dotLength, numMargins, spacing)
		
		yPos := centerY
		
		skillGuiColor := skillColors[skill.name]
		skillBorderColor := 000000
		
		if (skill.HasOwnProp("borderColor"))
		{
			skill.borderColor.Move(xPos-borderSize, yPos-borderSize, squareSize+(2*borderSize), squareSize+(2*borderSize))
			skill.guiColor.Move(xPos, yPos, squareSize, squareSize)
		}
		else
		{			
			skill.borderColor := myGui.Add("Progress", "x" xPos-borderSize " y" yPos-borderSize " w" squareSize+(2*borderSize) " h" squareSize+(2*borderSize) " Background" skillBorderColor)
			skill.guiColor := myGui.Add("Progress", "x" xPos " y" yPos " w" squareSize " h" squareSize " Background" skillGuiColor)
		}
		
		skill.guiColor.Visible := true
		skill.borderColor.Visible := true
		
		nextXPos := xPos + spacing + squareSize + (2*borderSize)		
	}

	; Show GUI
	myGui.Show("x" 0 " y" 0 " NoActivate")
}

InitializeOverlay()

tick := 0

; Timer to update cooldown colors
SetTimer(UpdateOverlay, 100)
UpdateOverlay()

; Function to update colors dynamically

UpdateOverlay() 
{

    global myGui, skillData, skillColors, cooldownColor, skillPositions, skillsMax, tick, sortedSkills, skillNameMap
	
	skillPos := skillPositions[skillsMax-2]  ; Get the corresponding position set
	
	tick := !tick

    for skill in skillData
	{	
		if (!skill.enabled)
		{
			skill.guiColor.Opt("Background" "Silver")
			skill.borderColor.Opt("Background" "Silver")
			continue
		}
		
		if (hideWhenUnfocused)
		{
			if (WinActive("ahk_exe HWR2.exe"))
			{
				if (!skill.guiColor.Visible) 
					skill.guiColor.Visible := true
				
				if (!skill.borderColor.Visible) 
					skill.borderColor.Visible := true
			}
			else
			{
				if (skill.guiColor.Visible)
					skill.guiColor.Visible := false
				
				if (skill.borderColor.Visible) 
					skill.borderColor.Visible := false
			}
		}	
	
		skillName := skill.name
		
		color := PixelGetColor(skillPos.%skillName%, skillPos.sampleY)
		
		isActive := IsSkillActive(color)
		
		newColor := unset
		
		if (isActive)
		{			
			if (skill.wasActive < 2)
			{
				newColor := skillColors[skill.name . "Shine"]
				newBorder := skillColors[skill.name . "Shine"]
				skill.wasActive++
			}
			else
			{
				newColor := skillColors[skill.name]
				newBorder := "Black"
			}
		}
		else
		{
			newColor := cooldownColor
			newBorder := cooldownColor
			skill.wasActive := 0
		}

        ; Set color (gray if cooldown, original if ready)
        ; newColor := (isActive) ? skillColors[skill.name] : cooldownColor
		; newBorder := (isActive) ? "Black" : cooldownColor
		
		if (detectChannelling and skill.name = "RightClick")
		{
			channelPixel := PixelGetColor(skillPos.Channel, skillPos.sampleY)
			isChannelling := !IsSkillActive(channelPixel)
			
			if (isChannelling)
			{
				if (tick)
				{
					newColor := skillColors["RightClickShine"]
					newBorder := skillColors["RightClickShine"]
				}
				else
				{
					newColor := skillColors[skill.name]
					newBorder := "Black"
				}								
			}
		}

        ; Update color dynamically
        skill.guiColor.Opt("Background" newColor)
		skill.borderColor.Opt("Background" newBorder)
		
		; skill.wasActive := isActive
    }	

	IsSkillActive(pixel)
	{
		hexColor := Format("{:06X}", pixel)
		
		; Extract RGB values
        red := Integer("0x" SubStr(hexColor, 1, 2))
        green := Integer("0x" SubStr(hexColor, 3, 2))
        blue := Integer("0x" SubStr(hexColor, 5, 2))
	
		; Calculate brightness
        brightness := (0.299 * red) + (0.587 * green) + (0.114 * blue)
		
		return (brightness > threshold)
	}
	
}
#HotIf