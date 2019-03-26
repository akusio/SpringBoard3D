#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>

@interface AXSceneViewController : UIViewController <UIGestureRecognizerDelegate, SCNSceneRendererDelegate>

-(void)spawnBoxWithBundleID:(NSString*)bid image:(UIImage*)img;

@end

