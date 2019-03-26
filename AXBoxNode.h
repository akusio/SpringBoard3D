#import <SceneKit/SceneKit.h>

@interface AXBoxNode : SCNNode

@property (nonatomic) NSString* identifier;

+(AXBoxNode*)boxWithBundleID:(NSString*)bid;

@end

