/*

Wall Worm DXF importer
http://www.wallworm.com

This script will allow you to pick a DXF file to import as a level.

Copyright (c) 2012 by Shawn Olson
All Rights Reserved

http://www.shawnolson.net

*/


fileIn "$scripts/WallWorm.com/importers/importer_functions.ms"
fileIn "$scripts/WallWorm.com/rollouts/dxf_import.ms"

try (destroyDialog wallwormDXFImport) catch ()


createDialog wallwormDXFImport