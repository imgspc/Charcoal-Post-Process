// Amplify Shader Editor - Visual Shader Editing Tool
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>
#if UNITY_POST_PROCESSING_STACK_V2
using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess( typeof( CharcoalPPSRenderer ), PostProcessEvent.AfterStack, "Charcoal", true )]
public sealed class CharcoalPPSSettings : PostProcessEffectSettings
{
	[Tooltip( "Paper Texture" )]
	public TextureParameter _PaperTexture = new TextureParameter {  };
	[Tooltip( "Ambient Shading Exposure" )]
	public FloatParameter _AmbientShadingExposure = new FloatParameter { value = 2f };
	[Tooltip( "Directional Light Exposure" )]
	public FloatParameter _DirectionalLightExposure = new FloatParameter { value = 4f };
}

public sealed class CharcoalPPSRenderer : PostProcessEffectRenderer<CharcoalPPSSettings>
{
	public override void Render( PostProcessRenderContext context )
	{
		var sheet = context.propertySheets.Get( Shader.Find( "Charcoal" ) );
		if(settings._PaperTexture.value != null) sheet.properties.SetTexture( "_PaperTexture", settings._PaperTexture );
		sheet.properties.SetFloat( "_AmbientShadingExposure", settings._AmbientShadingExposure );
		sheet.properties.SetFloat( "_DirectionalLightExposure", settings._DirectionalLightExposure );
		context.command.BlitFullscreenTriangle( context.source, context.destination, sheet, 0 );
	}
}
#endif
