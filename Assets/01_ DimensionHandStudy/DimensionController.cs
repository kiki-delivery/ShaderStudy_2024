using UnityEngine;

public class DimensionController : MonoBehaviour
{
    [SerializeField] GameObject _dementionView;

    DimentionViewer _dimentionViewer;

    void Update()
    {
        if(Input.GetMouseButtonDown(0))
        {
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            RaycastHit hit;

            if (Physics.Raycast(ray, out hit, 100f))
            {
                Vector3 hitPos = hit.point;                

                GameObject item = Instantiate(_dementionView);
                _dimentionViewer = item.GetComponent<DimentionViewer>();
                item.transform.position = hitPos;
            }
        }

        if (Input.GetMouseButton(0))
        {
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            RaycastHit hit;

            if (Physics.Raycast(ray, out hit, 100f))
            {
                Vector3 hitPos = hit.point;                
                _dimentionViewer.transform.position = hitPos;
            }            
        }

        if(Input.GetMouseButtonUp(0))
        {
            _dimentionViewer.Dissolve();
        }
    }

}
