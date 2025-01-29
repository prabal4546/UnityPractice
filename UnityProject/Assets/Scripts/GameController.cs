using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;  // Add TextMeshPro namespace
using System;

public class GameController : MonoBehaviour
{
    public Button unityButton;
    public TextMeshProUGUI numberDisplay;  // Reference to TextMeshPro UI component
    private int displayNumber = 0;  // The number to display
    private int bulletCount = 10;

    void Awake()
    {
        Debug.Log("[GameController] Awake called");
        
        if (numberDisplay == null)
        {
            Debug.LogError("[GameController] NumberDisplay reference is missing!");
        }
        else
        {
            Debug.Log("[GameController] NumberDisplay reference is valid");
        }
    }

    void Start()
    {
        Debug.Log("[GameController] Start called");
        
        if (unityButton != null)
        {
            RectTransform rectTransform = unityButton.GetComponent<RectTransform>();
            rectTransform.anchorMin = new Vector2(0.5f, 1f);
            rectTransform.anchorMax = new Vector2(0.5f, 1f);
            rectTransform.anchoredPosition = new Vector2(0f, -100f);  // Adjust this value to position below Swift button
            
            unityButton.interactable = false;
            Debug.Log("[GameController] Unity button configured");
        }

        if (numberDisplay != null)
        {
            UpdateDisplayNumber(displayNumber);
            Debug.Log("[GameController] Initial number display updated");
        }
    }

    // Method for handling string messages from Swift
    public void UpdateDisplayNumber(string numberStr)
    {
        Debug.Log($"[GameController] UpdateDisplayNumber called with string: {numberStr}");
        if (int.TryParse(numberStr, out int number))
        {
            UpdateDisplayNumber(number);
        }
        else
        {
            Debug.LogError($"[GameController] Could not parse number from string: {numberStr}");
        }
    }

    // Method for handling integer values
    public void UpdateDisplayNumber(int newNumber)
    {
        Debug.Log($"[GameController] UpdateDisplayNumber called with value: {newNumber}");
        try
        {
            displayNumber = newNumber;
            if (numberDisplay != null)
            {
                numberDisplay.text = newNumber.ToString();
                Debug.Log($"[GameController] Successfully updated display to: {newNumber}");
                
                // Check text properties
                Debug.Log($"[GameController] Text properties - Color: {numberDisplay.color}, Size: {numberDisplay.fontSize}, Text: '{numberDisplay.text}'");
            }
            else
            {
                Debug.LogError("[GameController] NumberDisplay is null when trying to update!");
            }
        }
        catch (Exception e)
        {
            Debug.LogError($"[GameController] Error updating display number: {e.Message}\n{e.StackTrace}");
        }
    }

    public void OnFireButtonPressed()
    {
        Debug.Log("[GameController] OnFireButtonPressed called");
        if (bulletCount > 0)
        {
            bulletCount--;
            using (var plugin = new NativePlugin())
            {
                plugin.UpdateBulletCount(bulletCount);
                Debug.Log($"[GameController] Bullet count updated to: {bulletCount}");
            }
        }
    }
}
