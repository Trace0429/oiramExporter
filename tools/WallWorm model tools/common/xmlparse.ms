XmlPath="C:\Users\Shawn\AppData\Local\Autodesk\3dsMax\2012 - 64bit\enu\scripts\WallWorm.com\config\presets.xml"
 XmlDoc=dotNetObject "system.xml.xmlDocument"
 if doesFileExist XmlPath then
 (
 XmlDoc.load XmlPath
 DocElem = XmlDoc.documentElement
	print (DocElem.InnerXml)
 if DocElem!=undefined then
 (
 presetCount = DocElem.firstChild.ChildNodes.count
 for i=0 to presetCount-1 do 
(
 Anim=DocElem.ChildNodes.itemOf[i]
print Anim.InnerXml
 )
 ) else messagebox "DocElem is Undefined"
 ) else messagebox "Xml File does not exist"
