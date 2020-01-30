// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Charcoal"
{
	Properties
	{
		_PaperTexture("Paper Texture", 2D) = "white" {}
		_AmbientShadingExposure("Ambient Shading Exposure", Float) = 2
		_DirectionalLightExposure("Directional Light Exposure", Float) = 4
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		Cull Off
		ZWrite Off
		ZTest Always
		
		Pass
		{
			CGPROGRAM

			

			#pragma vertex Vert
			#pragma fragment Frag
			#pragma target 3.0

			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"
			#include "UnityStandardBRDF.cginc"
			#define ASE_NEEDS_FRAG_SCREEN_POSITION_NORMALIZED

		
			struct ASEAttributesDefault
			{
				float3 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				
			};

			struct ASEVaryingsDefault
			{
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD0;
				float2 texcoordStereo : TEXCOORD1;
			#if STEREO_INSTANCING_ENABLED
				uint stereoTargetEyeIndex : SV_RenderTargetArrayIndex;
			#endif
				float4 ase_texcoord2 : TEXCOORD2;
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform sampler2D _CameraGBufferTexture0;
			uniform sampler2D _PaperTexture;
			uniform float4 _PaperTexture_ST;
			uniform float _AmbientShadingExposure;
			uniform sampler2D _CameraGBufferTexture2;
			uniform float _DirectionalLightExposure;


			//This is a late directive
			

			float2 TransformTriangleVertexToUV (float2 vertex)
			{
				float2 uv = (vertex + 1.0) * 0.5;
				return uv;
			}

			ASEVaryingsDefault Vert( ASEAttributesDefault v  )
			{
				ASEVaryingsDefault o;
				o.vertex = float4(v.vertex.xy, 0.0, 1.0);
				o.texcoord = TransformTriangleVertexToUV (v.vertex.xy);
#if UNITY_UV_STARTS_AT_TOP
				o.texcoord = o.texcoord * float2(1.0, -1.0) + float2(0.0, 1.0);
#endif
				o.texcoordStereo = TransformStereoScreenSpaceTex (o.texcoord, 1.0);

				v.texcoord = o.texcoordStereo;
				float4 ase_ppsScreenPosVertexNorm = float4(o.texcoordStereo,0,1);

				float3 ase_worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.ase_texcoord2.xyz = ase_worldPos;
				
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord2.w = 0;

				return o;
			}

			float4 Frag (ASEVaryingsDefault i  ) : SV_Target
			{
				float4 ase_ppsScreenPosFragNorm = float4(i.texcoordStereo,0,1);

				float2 uv_PaperTexture = i.texcoord.xy * _PaperTexture_ST.xy + _PaperTexture_ST.zw;
				float4 tex2DNode10 = tex2D( _PaperTexture, uv_PaperTexture );
				float3 ase_worldPos = i.ase_texcoord2.xyz;
				float3 worldSpaceLightDir = Unity_SafeNormalize(UnityWorldSpaceLightDir(ase_worldPos));
				float4 temp_output_13_0 = ( ase_ppsScreenPosFragNorm + ( tex2DNode10.r * 0.001 ) );
				float3 tex2DNode2 = UnpackNormal( tex2D( _CameraGBufferTexture2, temp_output_13_0.xy ) );
				float dotResult16 = dot( worldSpaceLightDir , tex2DNode2 );
				float clampResult35 = clamp( dotResult16 , 0.1 , 1.0 );
				float3 tex2DNode62 = UnpackNormal( tex2D( _CameraGBufferTexture2, ( temp_output_13_0 + float4( float2( 0.00025,0.00025 ), 0.0 , 0.0 ) ).xy ) );
				float3 tex2DNode77 = UnpackNormal( tex2D( _CameraGBufferTexture2, ( ase_ppsScreenPosFragNorm + float4( float2( -0.00025,-0.00025 ), 0.0 , 0.0 ) ).xy ) );
				float3 tex2DNode83 = UnpackNormal( tex2D( _CameraGBufferTexture2, ( ase_ppsScreenPosFragNorm + float4( float2( -0.00025,0.00025 ), 0.0 , 0.0 ) ).xy ) );
				float3 tex2DNode89 = UnpackNormal( tex2D( _CameraGBufferTexture2, ( ase_ppsScreenPosFragNorm + float4( float2( 0.00025,-0.00025 ), 0.0 , 0.0 ) ).xy ) );
				float4 temp_cast_10 = (( saturate( ( ( ( 1.0 - saturate( tex2D( _CameraGBufferTexture0, ( ase_ppsScreenPosFragNorm + ( tex2DNode10.r * 0.001 ) ).xy ).a ) ) + 0.4 ) * _AmbientShadingExposure ) ) * saturate( ( saturate( ( clampResult35 * _DirectionalLightExposure ) ) * ( ( 1.0 - ( length( ddx( tex2DNode2 ) ) + length( ddy( tex2DNode2 ) ) ) ) * ( 1.0 - ( length( ddx( tex2DNode62 ) ) + length( ddy( tex2DNode62 ) ) ) ) * ( 1.0 - ( length( ddx( tex2DNode77 ) ) + length( ddy( tex2DNode77 ) ) ) ) * ( 1.0 - ( length( ddx( tex2DNode83 ) ) + length( ddy( tex2DNode83 ) ) ) ) * ( 1.0 - ( length( ddx( tex2DNode89 ) ) + length( ddy( tex2DNode89 ) ) ) ) ) ) ) )).xxxx;
				

				float4 color = temp_cast_10;
				
				return color;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=17700
561;284;1203;572;2557.029;489.1365;1;True;True
Node;AmplifyShaderEditor.SamplerNode;10;-2205.393,-291.9412;Inherit;True;Property;_PaperTexture;Paper Texture;0;0;Create;True;0;0;False;0;-1;c0ac3092f87216643bfd1671cb75b57f;c0ac3092f87216643bfd1671cb75b57f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-1429.612,9.008291;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.001;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;12;-1958.546,-807.0631;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;95;-1401.688,1100.698;Inherit;False;Constant;_Vector3;Vector 3;5;0;Create;True;0;0;False;0;0.00025,-0.00025;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ScreenPosInputsNode;67;-1410.835,258.552;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;93;-1405.269,656.9289;Inherit;False;Constant;_Vector1;Vector 1;5;0;Create;True;0;0;False;0;-0.00025,-0.00025;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;94;-1423.576,869.0868;Inherit;False;Constant;_Vector2;Vector 2;5;0;Create;True;0;0;False;0;-0.00025,0.00025;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-1271.502,-102.3441;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;68;-1388.75,477.0156;Inherit;False;Constant;_Vector0;Vector 0;5;0;Create;True;0;0;False;0;0.00025,0.00025;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;90;-1086.583,590.3942;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;91;-1138.775,775.7717;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;92;-1114.909,1043.759;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TexturePropertyNode;70;-1156.224,75.21478;Inherit;True;Global;_CameraGBufferTexture2;_CameraGBufferTexture2;4;0;Create;True;0;0;False;0;None;None;False;bump;Auto;Texture2D;-1;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SimpleAddOpNode;69;-1131.152,325.2334;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;62;-830.0917,237.1003;Inherit;True;Property;_Buffer2;Buffer2;2;0;Fetch;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;77;-867.1298,538.6291;Inherit;True;Property;_Buffer2;Buffer2;2;0;Fetch;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;-1369.854,-620.6684;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.001;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;89;-905.8231,1074.38;Inherit;True;Property;_Buffer2;Buffer2;2;0;Fetch;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;83;-894.9282,801.4504;Inherit;True;Property;_Buffer2;Buffer2;2;0;Fetch;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-824.3779,-9.5576;Inherit;True;Property;_NormalBuffer1;NormalBuffer1;0;0;Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;40;-1033.799,-803.1357;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.DdxOpNode;98;-482.6694,803.4491;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DdyOpNode;79;-503.1218,932.1854;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;23;-728.5595,-272.4375;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DdyOpNode;85;-510.7034,1205.115;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DdyOpNode;5;-432.5716,121.1773;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DdyOpNode;73;-475.3235,669.3641;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DdxOpNode;57;-433.896,251.3644;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DdxOpNode;97;-470.4571,544.9867;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DdyOpNode;59;-438.2854,367.8353;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DdxOpNode;3;-428.1822,4.70645;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DdxOpNode;99;-519.681,1071.787;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LengthOpNode;58;-211.0911,272.8919;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;36;-765.1252,-829.4984;Inherit;True;Global;_CameraGBufferTexture0;_CameraGBufferTexture0;3;1;[HDR];Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LengthOpNode;80;-297.0999,942.3192;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;16;-387.4886,-244.6627;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;75;-248.1292,574.4207;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;56;-226.5497,131.3111;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;81;-275.9276,837.2421;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;60;-232.2634,377.9691;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;87;-283.509,1110.171;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;86;-304.6813,1215.248;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;74;-269.3015,679.4979;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;33;-205.3774,26.23392;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;42;-454.1447,-728.0885;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;35;-188.8137,-222.323;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;82;-71.53169,912.4316;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;76;-43.73332,649.6103;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-47.80525,86.37292;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;88;-79.11313,1185.361;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-313.454,-93.28535;Inherit;False;Property;_DirectionalLightExposure;Directional Light Exposure;2;0;Create;True;0;0;False;0;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;61;-6.695232,348.0815;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;72;103.3566,632.0643;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;84;107.5352,1181.001;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;48;-303.6806,-726.7125;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;35.59624,-215.8991;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;63;179.9532,343.7215;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;78;115.1166,908.0723;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;34;122.6355,89.70325;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;71;494.2363,505.5175;Inherit;False;5;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;53;-133.6274,-720.0193;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.4;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;-246.2646,-602.3117;Inherit;False;Property;_AmbientShadingExposure;Ambient Shading Exposure;1;0;Create;True;0;0;False;0;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;46;314.573,-192.5484;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;64.68683,-695.9541;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;760.7954,-164.6566;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;49;257.7286,-700.079;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;27;1004.98,-175.8792;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;1459.228,-680.4001;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1602.695,-681.4814;Float;False;True;-1;2;ASEMaterialInspector;0;2;Charcoal;32139be9c1eb75640a847f011acf3bcf;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;True;2;False;-1;False;False;True;2;False;-1;True;7;False;-1;False;False;False;0;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;0
WireConnection;15;0;10;1
WireConnection;13;0;12;0
WireConnection;13;1;15;0
WireConnection;90;0;67;0
WireConnection;90;1;93;0
WireConnection;91;0;67;0
WireConnection;91;1;94;0
WireConnection;92;0;67;0
WireConnection;92;1;95;0
WireConnection;69;0;13;0
WireConnection;69;1;68;0
WireConnection;62;0;70;0
WireConnection;62;1;69;0
WireConnection;77;0;70;0
WireConnection;77;1;90;0
WireConnection;39;0;10;1
WireConnection;89;0;70;0
WireConnection;89;1;92;0
WireConnection;83;0;70;0
WireConnection;83;1;91;0
WireConnection;2;0;70;0
WireConnection;2;1;13;0
WireConnection;40;0;12;0
WireConnection;40;1;39;0
WireConnection;98;0;83;0
WireConnection;79;0;83;0
WireConnection;85;0;89;0
WireConnection;5;0;2;0
WireConnection;73;0;77;0
WireConnection;57;0;62;0
WireConnection;97;0;77;0
WireConnection;59;0;62;0
WireConnection;3;0;2;0
WireConnection;99;0;89;0
WireConnection;58;0;57;0
WireConnection;36;1;40;0
WireConnection;80;0;79;0
WireConnection;16;0;23;0
WireConnection;16;1;2;0
WireConnection;75;0;97;0
WireConnection;56;0;5;0
WireConnection;81;0;98;0
WireConnection;60;0;59;0
WireConnection;87;0;99;0
WireConnection;86;0;85;0
WireConnection;74;0;73;0
WireConnection;33;0;3;0
WireConnection;42;0;36;4
WireConnection;35;0;16;0
WireConnection;82;0;81;0
WireConnection;82;1;80;0
WireConnection;76;0;75;0
WireConnection;76;1;74;0
WireConnection;7;0;33;0
WireConnection;7;1;56;0
WireConnection;88;0;87;0
WireConnection;88;1;86;0
WireConnection;61;0;58;0
WireConnection;61;1;60;0
WireConnection;72;0;76;0
WireConnection;84;0;88;0
WireConnection;48;0;42;0
WireConnection;25;0;35;0
WireConnection;25;1;26;0
WireConnection;63;0;61;0
WireConnection;78;0;82;0
WireConnection;34;0;7;0
WireConnection;71;0;34;0
WireConnection;71;1;63;0
WireConnection;71;2;72;0
WireConnection;71;3;78;0
WireConnection;71;4;84;0
WireConnection;53;0;48;0
WireConnection;46;0;25;0
WireConnection;51;0;53;0
WireConnection;51;1;50;0
WireConnection;24;0;46;0
WireConnection;24;1;71;0
WireConnection;49;0;51;0
WireConnection;27;0;24;0
WireConnection;37;0;49;0
WireConnection;37;1;27;0
WireConnection;0;0;37;0
ASEEND*/
//CHKSM=85B541A407F7641E73D07F8C21AD55946F86F1E7