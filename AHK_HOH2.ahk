﻿#Requires AutoHotkey v2.0
#HotIf WinActive("ahk_exe HWR2.exe")

;; -- HOTKEYS TO TOGGLE EACH SKILL UI -- ;;

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

;; -- UI Sizes -- ;;
squareSize := 8 	; Solid fill size in px
borderSize := 3 	; Border thickness in px
spacing := 8 		; Space in px between each skill UI
yOffset := 50 		; Vertical offset from the center of the screen. Increase to move lower.

centerX := (A_ScreenWidth // 2)
centerY := (A_ScreenHeight // 2) + yOffset

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
    "RightClick", "8B4513",  ; Brown
    "Skill1", "0000FF",      ; Blue
    "Skill2", "FFFF00",      ; Yellow
    "Skill3", "FF0000"       ; Red
)

;; -- WIP NOT FUNCTIONAL YET -- ;;
;skillOrder := Map(
;	"RightClick", 0,
;	"Skill1", 1,
;	"Skill2", 2,
;	"Skill3", 3
;)

;; -- SKILL INFO --
;; Customize sampleX and sampleY for your resolution.
;; These default values of (1067,1354), (1461,1354), (1554,1354), (1646,1354) work on my resolution of 2560x1440.
;; These refer to the X and Y coordinates of the pixel to be sampled to figure out if the skill is on or off cooldown.
;; How to Find Your sampleX and Y:
;;		1. Take a screenshot.
;;		2. Open image in an editor like Photoshop or Gimp
;;		3. Get the x,y coordinates of a single pixel on each skill border.
;;			This should be a pixel along the top edge of each skill border, slightly off-centre.
;;			The Y-value should be the same for all the skills, so you can just worry about the X coordinate.

;; You can also change the order of the skills by swapping the sample order 
;; (e.g., if you want to see skill2 before skill1, you'd swap their sampleX values below)

skillData := [	
	{ name: "RightClick", sampleX: 1067, sampleY: 1354, enabled: true, borderColor: unset, guiColor: unset},
    { name: "Skill1", sampleX: 1461, sampleY: 1354, enabled: true, borderColor: unset, guiColor: unset },
	{ name: "Skill2", sampleX: 1554, sampleY: 1354, enabled: true, borderColor: unset, guiColor: unset },
    { name: "Skill3", sampleX: 1646, sampleY: 1354, enabled: true, borderColor: unset, guiColor: unset }
]

numSkills := 0

global myGui

;; -- WIP NOT FUNCTIONAL YET -- ;;
;GetSlotXPos(skillSlot, dotLength, numMargins, spacing) 
;{
;	return centerX - (((numMargins * spacing) + (numSkills * dotLength))/2) + (skillSlot * (dotLength+spacing))
;}

InitializeOverlay()
{
	; Create GUI
	myGui := Gui(, "Skill Cooldowns")
	
	;myGui.Opt("+AlwaysOnTop -Caption +ToolWindow")
	myGui.Opt("+AlwaysOnTop -Caption +E0x8000000 ")
	
	myGui.BackColor := "Silver"  ; Required for transparency
	WinSetTransColor("Silver", myGui)  ; Make black background fully transparent

	numSkills := 0
	
	for skill in skillData
	{
		if (skill.enabled)
		{
			numSkills := numSkills + 1
		}
	}
	
	;MsgBox(numSkills " skills active")

	dotLength := squareSize + (borderSize * 2)
	
	numMargins := Max(numSkills - 1, 0)

	nextXPos := centerX - (((numMargins * spacing) + (numSkills * dotLength))/2)
	;nextXPos := 0

	for skill in skillData {

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
	;myGui.Show("x" centerX - 20 " y" centerY - 10 " NoActivate")
	myGui.Show("x" 0 " y" 0 " NoActivate")
}

InitializeOverlay()

; Timer to update cooldown colors
SetTimer(UpdateOverlay, 100)

; UpdateOverlay()

; Function to update colors dynamically

UpdateOverlay() {

    global myGui, skillData, skillColors, cooldownColor

    for skill in skillData {
	
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
	
		color := PixelGetColor(skill.sampleX, skill.sampleY)
        hexColor := Format("{:06X}", color)

        ; Extract RGB values
        red := Integer("0x" SubStr(hexColor, 1, 2))
        green := Integer("0x" SubStr(hexColor, 3, 2))
        blue := Integer("0x" SubStr(hexColor, 5, 2))

        ; Calculate brightness
        brightness := (0.299 * red) + (0.587 * green) + (0.114 * blue)

        ; Set color (gray if cooldown, original if ready)
        newColor := (brightness > threshold) ? skillColors[skill.name] : cooldownColor
		
		newBorder := (brightness > threshold) ? "Black" : cooldownColor

        ; Update color dynamically
        skill.guiColor.Opt("Background" newColor)
		skill.borderColor.Opt("Background" newBorder)
    }
}
#HotIf