#import "NativeState.h"

id<SetsNativeState> nativeStateSetter;

// Called from Swift. Can we hide this from the C# DllImport()?
void RegisterNativeStateSetter(id<SetsNativeState> setter) {
    nativeStateSetter = setter;
}

/* Called from Unity. Interop marshals argument from C# delegate to C function pointer.
   See section on marshalling delegates:
   learn.microsoft.com/en-us/dotnet/framework/interop/default-marshalling-behavior */
void OnSetNativeState(SetNativeStateCallback callback) {
    nativeStateSetter.setNativeState = callback;
}

// Add implementation for updating bullet count
void OnUpdateBulletCount(UpdateBulletCountCallback callback) {
    nativeStateSetter.updateBulletCount = callback;
}

// Implementation of the bullet count update function that will be called from Unity
void UpdateBulletCount(int count) {
    if (nativeStateSetter && nativeStateSetter.updateBulletCount) {
        nativeStateSetter.updateBulletCount(count);
    }
}

// Add the function that matches the C# DllImport name
void UpdateBulletCountiOS(int count) {
    UpdateBulletCount(count);
}
