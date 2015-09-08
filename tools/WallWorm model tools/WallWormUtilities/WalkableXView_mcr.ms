macroScript WW_Face_Walkable
buttonText:"WW Face Walkable" 
category:"wallworm.com"
tooltip:"WW Display Walkable" 
(

on isChecked return 

xViewChecker.getCheckerName xViewChecker.activeIndex == "WW Face Walkable" and xViewChecker.on == true

on execute do 

if (xViewChecker.getCheckerName xViewChecker.activeIndex == "WW Face Walkable" and xViewChecker.on == true)

then

xViewChecker.on = false

else

( 

local theIndex = 0

for i = 1 to xViewChecker.getNumCheckers() do

if xViewChecker.getCheckerName i == "WW Face Walkable" do theIndex = i

if theIndex > 0 do   

(

xViewChecker.setActiveCheckerID (xViewChecker.getCheckerID theIndex)

xViewChecker.on = true

)

)

)
