Shader "DimensionHandStudy/Front"
{
	Properties
	{
		_MainTex("RGB", 2D) = "white"{}
		_Color("Color", COLOR) = (1,1,1,1)	
		_CircleSize("CircleSize", float) = 1
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

				ZTest Always
				Stencil
				{
					Ref 1
					Comp Equal
					Pass IncrSat
					fail keep
					ZFail keep
				}


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

			
				float4 _MainTex_ST;
				sampler2D _MainTex;
				float4 _Color;
				float _CircleSize;

				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = TransformObjectToHClip(v.vertex.xyz);
					o.uv = v.uv.xy;
					return o;
				}
				
				float circle(float2 uv)
				{
					return distance(0, uv);
				}

				half4 frag(v2f i) : SV_Target
				{										
					float2 uv = (i.uv - 0.5) * 2;
					if( circle(uv) > _CircleSize) discard;
					return _Color;
				}
				ENDHLSL
			}

		}
}