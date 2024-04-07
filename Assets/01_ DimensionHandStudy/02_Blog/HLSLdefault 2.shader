Shader "CustomShader/Sphere"
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

			ZTest always 

			Stencil
			{
				Ref 2
				Comp Equal
				Pass keep								
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
				float3 normal : NORMAL;
			};


			struct v2f
			{
				float4 vertex  	: SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
				float3 worldPosition : TEXCOORD1; 

			};
			
			float4 _MainTex_ST;
			float4 _Color;
			sampler2D _MainTex;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = TransformObjectToHClip(v.vertex.xyz);
				o.worldPosition = TransformObjectToWorld(v.vertex.xyz);
				o.uv = v.uv.xy;
				o.normal = TransformObjectToWorldNormal (v.normal);
				return o;
			}

			
			half4 frag(v2f i) : SV_Target
			{
				float4 shadowCoord = TransformWorldToShadowCoord(i.worldPosition);
				Light light = GetMainLight();

				float3 lightDir = normalize(light.direction);
				float3 normal = normalize(i.normal);  

  				float NdotL = saturate(dot(lightDir, normal));
				float3 Ambient = SampleSH(normal);

				float4 finalColor = 1;		
				finalColor.rgb = (NdotL * light.shadowAttenuation * _Color.rgb) + (Ambient * _Color.rgb);
                finalColor.a = _Color.a;

				return finalColor;
			}
			ENDHLSL
		}

		Pass //그림자 패스입니다.
        {
            Name "ShadowCaster"
            Tags{"LightMode" = "ShadowCaster"}  

            ZWrite On
            ZTest LEqual
            ColorMask 0
            Cull Front

            HLSLPROGRAM

            #pragma vertex ShadowPassVertex
            #pragma fragment ShadowPassFragment

            #include "Packages/com.unity.render-pipelines.universal/Shaders/SimpleLitInput.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/ShadowCasterPass.hlsl"
            ENDHLSL
        }

        Pass //깊이 패스입니다 .
        {
            Name "DepthOnly"
            Tags{"LightMode" = "DepthOnly"} 

            ZWrite On
            ColorMask 0
            Cull Front

            HLSLPROGRAM
            #pragma exclude_renderers gles gles3 glcore
            #pragma target 4.5

            #pragma vertex DepthOnlyVertex
            #pragma fragment DepthOnlyFragment

            #include "Packages/com.unity.render-pipelines.universal/Shaders/SimpleLitInput.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Shaders/DepthOnlyPass.hlsl"
            ENDHLSL
        }

		}
}