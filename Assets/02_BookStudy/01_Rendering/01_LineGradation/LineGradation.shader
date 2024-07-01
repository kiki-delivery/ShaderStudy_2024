Shader "BookStudy/LineGradation"
{
	Properties
	{		
		_Color1("Color1", COLOR) = (1,1,1,1)	
		_Color2("Color2", COLOR) = (1,1,1,1)	
		_LineCount("LineCount", Range(1, 100)) = 10
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
			int _LineCount;	

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = TransformObjectToHClip(v.vertex.xyz);
				o.uv = v.uv.xy;
				return o;
			}

			
			// 대각선 그리는 수식 밝기(L) = x + y를 수식으로 바꾸면 y = -x + L; 
			// 여기서 -1이 기울기, 기울기 만큼 대각선이 기울어짐
			// L = 2x + y => L/2 = x + y/2 는 같은 기울기
			// _LineCount원리는 0.1과 0.2사이에도 0.11, 0.145가 있다는걸 생각하면됨
			half4 frag(v2f i) : SV_Target
			{
				// floor : 내림한 정수 리턴 내림 = 소수값 다 짜르기
				float2 uv = (i.uv * 2 -1);
				uv = abs(((uv.x + uv.y) * _LineCount));
				float temp = floor(uv) % 2 == 0 ? frac(uv) : 1 - frac(uv);								
				float4 color = lerp(_Color1, _Color2, temp);
				return color;
			}
			ENDHLSL
		}

		}
}