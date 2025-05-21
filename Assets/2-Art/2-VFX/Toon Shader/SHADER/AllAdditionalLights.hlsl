#ifndef ADDITIONAL_LIGHT_INCLUDED
#define ADDITIONAL_LIGHT_INCLUDED

// Obtiene la luz principal (Directional Light)
void MainLight_float(float3 WorldPos, out float3 Direction, out float3 Color, out float Attenuation)
{
#ifdef SHADERGRAPH_PREVIEW
        Direction = normalize(float3(1.0f, 1.0f, 0.0f));
        Color = 1.0f;
        Attenuation = 1.0f;
#else
    Light mainLight = GetMainLight();
    Direction = mainLight.direction;
    Color = mainLight.color;
    Attenuation = mainLight.distanceAttenuation;
#endif
}

// Obtiene una luz adicional específica
void AdditionalLight_float(float3 WorldPos, int lightID, out float3 Direction, out float3 Color, out float Attenuation)
{
#ifndef SHADERGRAPH_PREVIEW
    int lightCount = GetAdditionalLightsCount();

    if (lightID < lightCount)
    {
        Light light = GetAdditionalLight(lightID, WorldPos);
        Direction = light.direction;
        Color = light.color;
        Attenuation = light.distanceAttenuation;
    }
    else
    {
        Direction = float3(0, 0, 0);
        Color = float3(0, 0, 0);
        Attenuation = 0;
    }
#else
        Direction = normalize(float3(1.0f, 1.0f, 0.0f));
        Color = float3(1,1,1);
        Attenuation = 1.0f;
#endif
}

// Calcula todas las luces adicionales
void AllAdditionalLights_float(float3 WorldPos, float3 WorldNormal, float2 CutoffThresholds, out float3 LightColor)
{
    LightColor = 0.0f;

#ifndef SHADERGRAPH_PREVIEW
    int lightCount = GetAdditionalLightsCount();

    for (int i = 0; i < lightCount; ++i)
    {
        Light light = GetAdditionalLight(i, WorldPos);
        float intensity = smoothstep(CutoffThresholds.x, CutoffThresholds.y, dot(light.direction, WorldNormal));
        LightColor += light.color * light.distanceAttenuation * intensity;
    }
#endif
}

#endif // ADDITIONAL_LIGHT_INCLUDED
