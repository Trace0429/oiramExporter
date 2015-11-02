SET(INC_FILES
	OgreRenderSystemComponent.h
	OgreSerializerComponent.h
    stdafx.h
	zip.h
)
SET(SRC_FILES
	dllmain.cpp
	OgreRenderSystemComponent.cpp
    OgreSerializerComponent.cpp
    stdafx.cpp
	zip.cpp
)

SOURCE_GROUP("include" FILES ${INC})
SOURCE_GROUP("src" FILES ${SRC})

include_directories(../dependencies/OGRE/include)
include_directories(../dependencies)

add_definitions(-DNO_VIEW_EXTENDED)

add_library(OgreComponent SHARED
	${INC_FILES} ${SRC_FILES}
)