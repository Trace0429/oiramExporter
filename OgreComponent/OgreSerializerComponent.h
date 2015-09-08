#ifndef _Ogre_Serializer_hpp__
#define _Ogre_Serializer_hpp__

#include "serializer.h"
#include "zip.h"

namespace oiram
{
	class OgreSerializer : public Serializer
	{
	public:
		OgreSerializer();
		~OgreSerializer();

		const char* getName()const override;
		void exportMaterial(const oiram::MaterialContainer& materials) override;
		void exportMesh(const oiram::Mesh& mesh, const AnimationDesc& animDesc) override;
		void exportSkeleton(const oiram::Skeleton& skeleton, const AnimationDesc& animDesc) override;
		void exportPackage(const std::string& directory, const std::string& name) override;

	public:
		enum OgreVersion
		{
			OgreVer_1_8,
			OgreVer_1_7,
			OgreVer_1_6,

			OgreVer_Num
		};

	private:
		OgreVersion getVersion();

		typedef std::map<std::string, std::vector<std::string>> DependencyMap;
		// 材质脚本
		struct MaterialScript
		{
			std::string			script;			// 脚本
			DependencyMap		dependencyMap;	// 头文件依赖
		};

		void dumpMaterialScript(const oiram::Material& material, DependencyMap& dependencyMap, std::ostringstream& ss);
		std::string dumpPass(const oiram::Material& material, const std::vector<oiram::Material::TextureUnit>& supportTexUnits);
		std::string dumpTextureUnitState(const oiram::Material::TextureSlot& textureSlot, const oiram::Material::UVCoordinateMap& uvCoordinateMap);

		void writeChunkHeader(unsigned short id, unsigned int size, FILE* fp);
		void writeVertexElement(unsigned short source, unsigned short type, unsigned short semantic, unsigned short offset, unsigned short index, FILE* fp);
		void writeGeometry(const oiram::Geometry& geometry, int meshType, FILE* fp);
		void writeBoneAssignment(const oiram::Geometry& geometry, bool isSubMesh, FILE* fp);
	};
}

#endif
