using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class GameController : MonoBehaviour
{
    public Button unityButton;  
    private int bulletCount = 10;

    void Start()
    {
        if (unityButton != null)
        {
            RectTransform rectTransform = unityButton.GetComponent<RectTransform>();
            rectTransform.anchorMin = new Vector2(0.5f, 1f);
            rectTransform.anchorMax = new Vector2(0.5f, 1f);
            rectTransform.anchoredPosition = new Vector2(0f, -100f);  // Adjust this value to position below Swift button
            
            unityButton.interactable = false;
        }
    }

    public void OnFireButtonPressed()
    {
        if (bulletCount > 0)
        {
            bulletCount--;
            using (var plugin = new NativePlugin())
            {
                plugin.UpdateBulletCount(bulletCount);
            }
        }
    }
}
