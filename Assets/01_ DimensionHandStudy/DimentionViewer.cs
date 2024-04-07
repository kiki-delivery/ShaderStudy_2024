using System.Collections;
using UnityEngine;

public class DimentionViewer : MonoBehaviour
{
    [SerializeField, Range(0.1f, 2.7f)] float _circleSizeLimit = 1;
    [SerializeField] float _speed = 1;

    [SerializeField] Material[] _materials;
    [SerializeField] GameObject _child;
    [SerializeField] Material _childMaterial;
    [SerializeField, Range(0.01f, 0.05f)] float _childCircleSize = 0.01f;

    float time = 0f;    

    void Awake()
    {
        _materials = GetComponent<Renderer>().materials;
        _childMaterial = _child.GetComponent<Renderer>().material;
    }

    void Start()
    {
        StartCoroutine("AppearCoroutine");
    }

    public void Appear()
    {
        StopCoroutine("DisoolveCoroutine");
        StartCoroutine("AppearCoroutine");
    }

    public void Dissolve()
    {
        StopCoroutine("AppearCoroutine");
        StartCoroutine("DisoolveCoroutine");
    }


    IEnumerator AppearCoroutine()
    {
        while (time < _circleSizeLimit)
        {
            time += Time.deltaTime * _speed;
            foreach (Material material in _materials)
            {
                material.SetFloat("_CircleSize", time);
            }
            //_childMaterial.SetFloat("_CircleSize", time);
            yield return null;
        }        
    }
    
    IEnumerator DisoolveCoroutine()
    {
        while (time > 0)
        {
            time -= Time.deltaTime * _speed;
            foreach (Material material in _materials)
            {
                material.SetFloat("_CircleSize", time);
            }
            //_childMaterial.SetFloat("_CircleSize", time + _childCircleSize);
            yield return null;
        }

        Destroy(gameObject);
    }
}
