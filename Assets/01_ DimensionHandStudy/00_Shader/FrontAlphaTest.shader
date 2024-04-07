Shader "DimensionHandStudy/FrontAlphaTest"
{
	Properties
	{
		_MainTex("RGB", 2D) = "white"{}		
		_Color("Color", COLOR) = (1,1,1,1)		
		_CircleSize("CircleSize", float) = 1
		_RingSize("RingSize", float) = 1

		[Enum(UnityEngine.Rendering.BlendMode)]
        _SrcFactor("Src Factor", Float) = 5
        [Enum(UnityEngine.Rendering.BlendMode)]
        _DstFactor("Dst Factor", Float) = 10
        [Enum(UnityEngine.Rendering.BlendOp)]
        _Opp("Operation", Float) = 0
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
					Ref 3
					Comp Equal
					Pass keep
					fail keep
					ZFail keep
				}
				Blend[_SrcFactor][_DstFactor]
				BlendOp[_Opp]


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
					float4 screenPosition : TEXCOORD1;
					float3 worldPosition : color;
				};
				

				float3 _Position;
				float4 _MainTex_ST;
				sampler2D _MainTex;
				sampler2D _GlobalRenderTexture;
				float _Radius;
				float4 _Color;
				float _CircleSize;
				float _RingSize;

				v2f vert(appdata v)
				{
					v2f o;
					// 버텍스 공간을 카메라 클립 공간으로 변환
					o.vertex = TransformObjectToHClip(v.vertex.xyz);					
					o.worldPosition = TransformObjectToWorld(v.vertex.xyz);
					o.screenPosition = ComputeScreenPos(o.vertex);
					o.uv = v.uv.xy;
					return o;
				}

				float circle(float2 uv)
				{
					return distance(abs(uv), 0);
				}

				float GetCircleInCheck(float2 uv)
				{
					float temp = abs(uv.x)- _CircleSize< 0 ? 1 : 0;
					float temp2 = abs(uv.y) - _CircleSize < 0 ? 1 : 0;
					return temp * temp2;
				}
				
				half4 frag(v2f i) : SV_Target
				{							
					float2 uv = (i.uv - 0.5) * 2;
					//if( circle(uv) > _CircleSize) discard;
					float a = smoothstep(0.5, 0.7, circle(uv));

					float4 tex = tex2D(_MainTex, uv + frac(_Time.x));

					float2 textureCoordinate = i.screenPosition.xy / i.screenPosition.w;
					float4 screen = tex2D(_GlobalRenderTexture, textureCoordinate + uv * 0.05 + tex.rg * 0.005 * a * a );
					float4 color = tex * a;

					return screen + color ;
				}
				ENDHLSL
			}

		}
}