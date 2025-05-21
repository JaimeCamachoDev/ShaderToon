using UnityEngine;
using UnityEditor;

[ExecuteInEditMode] // Permite que el script funcione en el editor
public class StoreMainLightData : MonoBehaviour
{
    public Material material;
    public bool lockLight; // Ahora es un bool para mayor claridad.
    public Color color;
    public Vector3 lightDirection;
    public Light customLight; // Ahora puedes elegir cualquier luz
    private float intensity;
    private void Start()
    {
        if (customLight == null) Debug.LogError("No se ha asignado una luz.");
    }

    private void Update()
    {
        if (material == null) return;
        if (customLight == null) return;

        // Guardamos el estado de LockLight en el material (convertimos bool a float)
        material.SetFloat("_LockLight", lockLight ? 1.0f : 0.0f);

        if (!lockLight) // Solo actualizamos si LockLight está en FALSE
        {
            // Si la luz es Directional, usamos su forward, si no, calculamos su dirección hacia el objeto
            if (customLight.type == LightType.Directional)
            {
                lightDirection = -customLight.transform.forward;
            }
            else
            {
                // Para Point Light o Spot Light, dirección desde la luz al objeto
                lightDirection = (transform.position - customLight.transform.position).normalized;
            }

            color = customLight.color;
            intensity = customLight.intensity;
        }

        // Enviamos los valores al material
        material.SetFloat("_StoredIntensity", intensity);
        material.SetVector("_StoredLightDirection", lightDirection);
        material.SetColor("_StoredLightColor", color);
        //material.SetVector("_CustomLightDirection", lightDirection); // NUEVO
        //material.SetColor("_CustomLightColor", color); // NUEVO
    }
}