#import <Metal/MTLTexture.h>

struct NativeState {
    const float scale;
    const bool visible;
    const char* _Nonnull spotlight;
    const int textureWidth;
    const int textureHeight;
    const __unsafe_unretained id<MTLTexture> _Nullable texture;
    const int bulletCount;  // Add bullet count to the struct
};

typedef void (*SetNativeStateCallback)(struct NativeState nextState);
typedef void (*UpdateBulletCountCallback)(int count);  // Add callback for bullet count updates

@protocol SetsNativeState
/* Function pointer that will be used to send state from Swift to Unity.
   Encapsulation within a protocol lets us take advantage of Swift's didSet property observer. */
@property (nullable) SetNativeStateCallback setNativeState;
@property (nullable) UpdateBulletCountCallback updateBulletCountiOS;  // Add property for bullet count updates
@end

__attribute__ ((visibility("default")))
void RegisterNativeStateSetter(id<SetsNativeState> _Nonnull setter);

// Add function declaration for updating bullet count
__attribute__ ((visibility("default")))
void UpdateBulletCount(int count);

// Add function declaration for iOS-specific bullet count update
__attribute__ ((visibility("default")))
void UpdateBulletCountiOS(int count);
