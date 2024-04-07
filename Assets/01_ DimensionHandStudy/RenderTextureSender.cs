using UnityEngine;

[ExecuteInEditMode, ImageEffectAllowedInSceneView]
public class RenderTextureSender : MonoBehaviour
{
    [SerializeField] RenderTexture _renderTexture;

    void Update()
    {
        Shader.SetGlobalTexture("_GlobalRenderTexture", _renderTexture);
    }
}
