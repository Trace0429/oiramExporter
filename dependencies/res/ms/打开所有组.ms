--作者：飞浪
--Author:Feilang
--www.cgplusplus.com
--------------------------------------------------
--欢迎使用场景助手4.0 

----开源奉献----

---------------------------------------------------
--场景助手4.0		2011-04-01
--场景助手3.0		2009-08-01
--场景助手2.6		2009-03-30
--场景助手2.0		2008-08-06
--场景助手1.0		2008-05-27
fn openAllGroups obj =
(
	sourceObj = for i in obj where not isOpenGroupHead i collect i
	if sourceObj.count != 0 then for o in sourceObj do setGroupOpen o true else return true
	for j in 1 to sourceObj.count do openAllGroups sourceObj
)
(	if selection.count != 0 then
		obj = for i in selection where CGplusplusFunc.notHiddenOrFrozen i and isGroupHead i collect i
	else obj = for i in objects where CGplusplusFunc.notHiddenOrFrozen i and isGroupHead i collect i
		fl_openAllGroups obj
)
