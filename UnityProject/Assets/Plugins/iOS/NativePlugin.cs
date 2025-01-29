using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using UnityEngine;

public class NativePlugin : System.IDisposable
{
    #if UNITY_IOS && !UNITY_EDITOR
    [DllImport("__Internal")]
    private static extern void UpdateBulletCountiOS(int count);
    #endif

    public void UpdateBulletCount(int count)
    {
        #if UNITY_IOS && !UNITY_EDITOR
        UpdateBulletCountiOS(count);
        #endif
    }

    public void Dispose() { }
}
