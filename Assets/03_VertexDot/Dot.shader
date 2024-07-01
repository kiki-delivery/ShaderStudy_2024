Shader "CustomShader/VertexDot"
{
	Properties
	{
		_MainTex("RGB", 2D) = "white"{}
		_Color("Color", COLOR) = (1,1,1,1)	
		_Color2("Color2", COLOR) = (1,1,1,1)
		_controll("Controll", Range(0, 10)) = 1
	}

	SubShader
	{
		Tags
		{
			"RenderPipeline" = "UniversalPipeline"
			"RenderType" = "Opaque"
			"Queue" = "Geometry"
		}

		Pass
		{
			Name "Universal Forward"
			Tags { "LightMode" = "UniversalForward" }


			HLSLPROGRAM

			#pragma prefer_hlslcc gles	
			#pragma exclude_renderers d3d11_9x
			#pragma vertex vert
			#pragma fragment frag

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"        	


			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};


			struct v2f
			{
				float4 vertex  	: SV_POSITION;
				float2 uv : TEXCOORD0;

			};
			
			float4 _MainTex_ST;
			float4 _Color;
			float4 _Color2;
			float _controll;
			sampler2D _MainTex;

			v2f vert(appdata v)
			{
				v2f o;
				float3 normal = TransformObjectToWorldNormal(v.normal);
				o.vertex = TransformObjectToHClip(v.vertex.xyz) + float4(normal * _controll, 0);
				o.uv = TransformObjectToWorld(v.vertex.xyz).xy;
				return o;
			}

			
			half4 frag(v2f i) : SV_Target
			{				
				return lerp(_Color, _Color2, i.uv.y);
			}
			ENDHLSL
		}

		}
}