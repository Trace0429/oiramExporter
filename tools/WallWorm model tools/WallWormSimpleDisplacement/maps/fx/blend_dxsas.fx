// Simple blended effect with illumination and Vertex color support
// Neil Hazzard, GDC Demo
///////////////////////////////////////////////////////////////////

string ParamID = "0x0001";


float Script : STANDARDSGLOBAL <
	string UIWidget = "none";
	string ScriptClass = "object";
	string ScriptOrder = "standard";
	string ScriptOutput = "color";
	string Script = "Technique=blend;";
> = 0.8; // version #


float4x4 WorldViewProjection : WorldViewProjection < string UIWidget = "None"; >;

int texcoord0 : Texcoord
<
	int Texcoord = 0;
	int MapChannel = 0;
	string UIWidget = "None";
>;

int texcoord1 : Texcoord
<
	int Texcoord = 1;
	int MapChannel = -2;
	string UIWidget = "None";
>;

int texcoord2 : Texcoord
<
	int Texcoord = 2;
	int MapChannel = -1;
	string UIWidget = "None";
>;

int texcoord3 : Texcoord
<
	int Texcoord = 3;
	int MapChannel = 1;
	string UIWidget = "None";
>;

Texture TextureTop 
<
	string UIName = "Top Texture";
>;

Texture TextureBottom 
< 
	string UIName = "Bottom Texture";
>;
	
	
sampler2D topSampler = sampler_state
{
	Texture = <TextureTop>;
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
	ADDRESSU = WRAP;
	ADDRESSV = WRAP;
};

sampler2D bottomSampler = sampler_state 
{
	Texture = <TextureBottom>;
	MinFilter = Linear;
	MagFilter = Linear;
	MipFilter = Linear;
	ADDRESSU = WRAP;
	ADDRESSV = WRAP;
};


struct VSIn
{
	float3 Position		: POSITION;
	float3 Colour		: TEXCOORD0;
	float3 Alpha		: TEXCOORD1;
	float3 Illum		: TEXCOORD2;
	float2 UV		: TEXCOORD3;
};

struct VSOut
{
	float4 Position	 	: POSITION;
	float4 Colour		: COLOR0;
   	float2 UV1		: TEXCOORD0;
   	float2 UV2		: TEXCOORD1;
};

struct PSOut
{
	float4 Colour		: COLOR0;
};

VSOut VS(VSIn vsIn) 
{
	VSOut vsOut;                                                                                                                                                                                                                                                                                                                                   
   	vsOut.Position	= mul(float4(vsIn.Position, 1.0f), WorldViewProjection);
   	vsOut.Colour.rgb = vsIn.Colour * vsIn.Illum;
	vsOut.Colour.a	= vsIn.Alpha.x;
   	vsOut.UV1 = vsIn.UV;
   	vsOut.UV2 = vsIn.UV;
   	return vsOut;
}

PSOut PS( VSOut psIn )
{
	PSOut psOut;
	float3 Col1	= tex2D( topSampler, psIn.UV1 );
	float3 Col2	= tex2D( bottomSampler, psIn.UV2 );
	
	psOut.Colour.rgb = Col1 * psIn.Colour.a;
	psOut.Colour.rgb += Col2 * (1.0f - psIn.Colour.a);
	psOut.Colour.rgb *= psIn.Colour.rgb;
	psOut.Colour.a = 1.0f;
	return psOut;
}


technique Blend<
	string script = "Pass=p0;";
> {
    pass p0 <
		string script = "Draw=Geometry;";
    > {		
		AlphaBlendEnable	= TRUE;
		DestBlend		= InvSrcAlpha;  
		SrcBlend		= SrcAlpha;
		VertexShader		= compile vs_1_1 VS();
		PixelShader		= compile ps_1_1 PS();
    }
}