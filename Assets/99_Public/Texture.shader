Shader "Public/Texture"
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
					float3 worldPosition : color;
				};


				struct v2f
				{
					float4 vertex  	: SV_POSITION;
					float2 uv : TEXCOORD0;
					float3 worldPosition : color;
				};


				float3 _Position;
				float4 _MainTex_ST;
				sampler2D _MainTex;
				float _Radius;
				float4 _Color;

				v2f vert(appdata v)
				{
					v2f o;
					// 버텍스 공간을 카메라 클립 공간으로 변환
					o.vertex = TransformObjectToHClip(v.vertex.xyz);
					o.worldPosition = TransformObjectToWorld(v.vertex.xyz);
					o.uv = v.uv.xy;
					return o;
				}

				half4 frag(v2f i) : SV_Target
				{
					float4 color = tex2D(_MainTex, i.uv);
					return color;
				}
				ENDHLSL
			}

		}
}