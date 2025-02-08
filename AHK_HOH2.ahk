#Requires AutoHotkey v2.0
#HotIf WinActive("ahk_exe HWR2.exe")

; Constants

squareSize := 8
borderSize := 3
spacing := 8
yOffset := 50

centerX := (A_ScreenWidth // 2)
centerY := (A_ScreenHeight // 2) + yOffset

;cooldownColor := "808080" ; When on CD: Solid Gray
;cooldownColor := "000000" ; When on CD: Solid Black
cooldownColor := "Silver" ; When on CD: Silver for transparency

; Colors
skillColors := Map(
    "RightClick", "8B4513",  ; Brown
    "Skill1", "0000FF",      ; Blue
    "Skill2", "FFFF00",      ; Yellow
    "Skill3", "FF0000"       ; Red
)

skillOrder := Map(
	"RightClick", 0,
	"Skill1", 1,
	"Skill2", 2,
	"Skill3", 3
)

; Calculate skill positions relative to center
skillData := [	
	{ name: "RightClick", sampleX: 1067, sampleY: 1354, enabled: true, borderColor: unset, guiColor: unset},
    { name: "Skill1", sampleX: 1461, sampleY: 1354, enabled: true, borderColor: unset, guiColor: unset },
	{ name: "Skill2", sampleX: 1554, sampleY: 1354, enabled: true, borderColor: unset, guiColor: unset },
    { name: "Skill3", sampleX: 1646, sampleY: 1354, enabled: true, borderColor: unset, guiColor: unset }
]

numSkills := 0

; Create skill dots

;myGui := Gui(, "Skill Cooldowns")

global myGui

;GetSlotXPos(skillSlot, dotLength, numMargins, spacing) 
;{
;	return centerX - (((numMargins * spacing) + (numSkills * dotLength))/2) + (skillSlot * (dotLength+spacing))
;}

InitializeOverlay()
{
	; Create GUI
	
	;if (IsSet(myGui)) 
	;{
	;	myGui.Destroy()
	;}
	
	myGui := Gui(, "Skill Cooldowns")
	myGui.Opt("+AlwaysOnTop -Caption +ToolWindow")
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
	;nextXPos := GetSlotXPos(

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
		
		;skill.borderColor := myGui.Add("Progress", "x" xPos-borderSize " y" yPos-borderSize " w" squareSize+(2*borderSize) " h" squareSize+(2*borderSize) " Background000000")
		;skill.borderColor := myGui.Add("Progress", "x" xPos-borderSize " y" yPos-borderSize " w" squareSize+(2*borderSize) " h" squareSize+(2*borderSize) " Background" skillBorderColor)
		
		nextXPos := xPos + spacing + squareSize + (2*borderSize)		
	}

	; Show GUI centered beneath character

	;myGui.Show("x" centerX - 20 " y" centerY - 10 " NoActivate")
	myGui.Show("x" 0 " y" 0 " NoActivate")
}

InitializeOverlay()

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

;myGui.Show("x" 0 " y" 0 " NoActivate")

; Timer to update cooldown colors

SetTimer(UpdateOverlay, 100)

; UpdateOverlay()

; Function to update colors dynamically
UpdateOverlay() {

	;if (numSkills < 1)
	;{
	;	return
	;}

    global myGui, skillData, skillColors, cooldownColor

    threshold := 200  ; Brightness threshold for ready skills

    for skill in skillData {
	
		if (!skill.enabled)
		{
			skill.guiColor.Opt("Background" "Silver")
			skill.borderColor.Opt("Background" "Silver")
			continue
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