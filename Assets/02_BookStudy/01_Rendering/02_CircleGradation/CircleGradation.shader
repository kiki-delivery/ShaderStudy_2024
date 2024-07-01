Shader "BookStudy/Rendering/CircleGradation"
{
	Properties
	{		
		_Color1("Color1", COLOR) = (1,1,1,1)	
		_Color2("Color2", COLOR) = (1,1,1,1)	
		_radian1("radian1", Range(0, 2)) = 1
		_radian2("radian2", Range(0, 2)) = 1
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
			};


			struct v2f
			{
				float4 vertex  	: SV_POSITION;
				float2 uv : TEXCOORD0;

			};
						
			float4 _Color1;
			float4 _Color2;		
			float _radian1;	
			float _radian2;	

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = TransformObjectToHClip(v.vertex.xyz);
				o.uv = v.uv.xy;
				return o;
			}
						
			half4 frag(v2f i) : SV_Target
			{				
				float2 uv = (i.uv * 2 -1);
				float temp = distance(uv, 0);
				temp = _radian1 < temp  && temp < _radian2 ? 1 : smoothstep(0.5, 0.8, distance(uv, 0));
				float4 color = lerp(_Color1, _Color2, temp);
				return color;
			}
			ENDHLSL
		}

		}
}