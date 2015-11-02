SET(INC_FILES
	Analyzer.h
	DotSceneExport.h
    Exporter.h
	ImageCompressor.h
	ImageLoader.h
	LogManager.h
	Optimizer.h
	stdafx.h
)
SET(SRC_FILES
	AnalyzerGeometry.cpp
	AnalyzerMaterial.cpp
    AnalyzerSkeleton.cpp
    dllmain.cpp
	DotSceneExport.cpp
	Exporter.cpp
	ImageCompressor.cpp
	ImageLoader.cpp
	LogManager.cpp
	oiramImpl.cpp
	Optimizer.cpp
	OptimizerAnimation.cpp
	OptimizerGeometry.cpp
	OptimizerPhysX.cpp
	stdafx.cpp
)

SOURCE_GROUP("include" FILES ${INC})
SOURCE_GROUP("src" FILES ${SRC})

include_directories(../dependencies/OGRE/include)
include_directories(../dependencies)

add_definitions(-DNO_VIEW_EXTENDED)

add_library(oiramImpl SHARED
	${INC_FILES} ${SRC_FILES}
)