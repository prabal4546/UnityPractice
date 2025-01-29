using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using UnityEngine;

public class NativePlugin : System.IDisposable
{
    #if UNITY_IOS && !UNITY_EDITOR
    [DllImport("__Internal")]
    private static extern void UpdateBulletCountiOS(int count);

    [DllImport("__Internal")]
    private static extern void UpdateDisplayNumberiOS(int number);
    #endif

    public void UpdateBulletCount(int count)
    {
        #if UNITY_IOS && !UNITY_EDITOR
        UpdateBulletCountiOS(count);
        #endif
    }

    public void UpdateDisplayNumber(int number)
    {
        #if UNITY_IOS && !UNITY_EDITOR
        UpdateDisplayNumberiOS(number);
        #endif
    }

    public void Dispose() { }
}
