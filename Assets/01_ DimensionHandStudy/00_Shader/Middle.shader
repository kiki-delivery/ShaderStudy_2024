Shader "DimensionHandStudy/Middle"
{
	Properties
	{
		_MainTex("RGB", 2D) = "white"{}
		_Color("Color", COLOR) = (1,1,1,1)	
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
					Comp Always    
					Pass Replace
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

				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = TransformObjectToHClip(v.vertex.xyz);
					o.uv = v.uv.xy;
					return o;
				}
				
				half4 frag(v2f i) : SV_Target
				{
					float4 color = tex2D(_MainTex, i.uv);
					return _Color;
				}
				ENDHLSL
			}

		}
}