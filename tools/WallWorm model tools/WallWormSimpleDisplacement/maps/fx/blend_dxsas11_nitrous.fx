// Simple blended effect with illumination and Vertex color support
// Neil Hazzard, GDC Demo
// converted to DX11 by Chipicao
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

Texture2D <float4> TextureTop 
<
	string UIName = "Top Texture";
	string ResourceType = "2D";
>;

Texture2D <float4> TextureBottom 
< 
	string UIName = "Bottom Texture";
	string ResourceType = "2D";
>;
	
	
SamplerState topSampler
{
	FILTER = MIN_MAG_MIP_LINEAR;
	ADDRESSU = WRAP;
	ADDRESSV = WRAP;
};

SamplerState bottomSampler
{
	FILTER = MIN_MAG_MIP_LINEAR;
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
	float4 Col1	= TextureTop.Sample( topSampler, psIn.UV1 );
	float4 Col2	= TextureBottom.Sample( bottomSampler, psIn.UV2 );
	
	psOut.Colour.rgb = Col1.rgb * psIn.Colour.a;
	psOut.Colour.rgb += Col2.rgb * (1.0f - psIn.Colour.a);
	psOut.Colour.rgb *= psIn.Colour.rgb;
	psOut.Colour.a = 1.0f;
	return psOut;
}

RasterizerState DataCulling
{
	FillMode = SOLID;
	CullMode = FRONT;
	FrontCounterClockwise = TRUE;
};

DepthStencilState DepthOn
{
	DepthEnable = TRUE;
	DepthWriteMask = ALL;
};

technique11 Blend_Realistic_11
{
    pass p0
	{		
		SetVertexShader(CompileShader(vs_5_0, VS()));
		SetGeometryShader( NULL );
		SetPixelShader(CompileShader(ps_5_0, PS()));
		SetRasterizerState( DataCulling );
		//SetDepthStencilState( DepthOn, 0 );
    }
}

technique11 Blend_Shaded_11
{
    pass p0
	{		
		SetVertexShader(CompileShader(vs_5_0, VS()));
		SetGeometryShader( NULL );
		SetPixelShader(CompileShader(ps_5_0, PS()));
		SetRasterizerState( DataCulling );
		SetDepthStencilState( DepthOn, 0 );
    }
}





technique10 Blend_Realistic_10
{
    pass p0
	{		
		SetVertexShader(CompileShader(vs_4_0, VS()));
		SetGeometryShader( NULL );
		SetPixelShader(CompileShader(ps_4_0, PS()));
		SetRasterizerState( DataCulling );
		//SetDepthStencilState( DepthOn, 0 );
    }
}

technique10 Blend_Blend_Shaded_10
{
    pass p0
	{		
		SetVertexShader(CompileShader(vs_4_0, VS()));
		SetGeometryShader( NULL );
		SetPixelShader(CompileShader(ps_4_0, PS()));
		SetRasterizerState( DataCulling );
		SetDepthStencilState( DepthOn, 0 );
    }
}
