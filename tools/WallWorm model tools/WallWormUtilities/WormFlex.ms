/*
Wall Worm VTA Helper Function
http://www.wallworm.com

Make a keyframe for every slot in a Morph or Morph-O-Matic modifier

Copyright (c) 2011 by Shawn Olson http://www.shawnolson.net


Function will find a Morph modifier (or Di-O-Matic's Morph-O-Matic modifier)
and apply a keyframe for each channel at 100 weight.

Steps to quicken the creation of VTA flex files for Source.
*/

try(destroyDialog  wwmt_WormFlex)catch(

)

include "$scripts/WallWorm.com/common/flexfuncs.ms"

rollout wwmt_WormFlex "Worm Flex Tools" width:206 height:104
(
	button btn1 "Flex Prep Selected" pos:[12,10] width:181 height:68 toolTip:"Prepare a mesh with a Morpher or Morph-O-Matic modifier for exporting as a VTA."
	HyperLink cust2 "Understanding VTA/Flex Export" pos:[13,80] width:181 height:20 address:"http://wallworm.com/projects/utilities/docs/using/making_facial_animations.html" color:(color 0 0 255) hovercolor:(color 255 0 0) visitedcolor:(color 0 0 255)
	on btn1 pressed do
	(
		macros.run "wallworm.com" "WallWormVTAPrepSelMCR"
	)
)

createDialog wwmt_WormFlex