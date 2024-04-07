Shader "DimensionHandStudy/DimensionControl"
{
	Properties
	{
		_MainTex("RGB", 2D) = "white"{}		
		_Color("Color", COLOR) = (1,1,1,1)		

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
					Ref 2
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
					float3 worldPosition : color;
				};
				

				float3 _Position;
				float4 _MainTex_ST;
				sampler2D _MainTex;
				float _Radius;
				float4 _Color;
				float _CircleSize;

				v2f vert(appdata v)
				{
					v2f o;
					// 버텍스 공간을 카메라 클립 공간으로 변환
					o.vertex = TransformObjectToHClip(v.vertex.xyz);					
					o.worldPosition = TransformObjectToWorld(v.vertex.xyz);
					o.uv = v.uv.xy;
					return o;
				}

				float circle(float2 uv)
				{
					return distance(0.5, uv);
				}
				
				half4 frag(v2f i) : SV_Target
				{									
					if( circle(i.uv) > _CircleSize) discard;
					return _Color;
					//return color;
				}
				ENDHLSL
			}

		}
}