#import "AXBoxNode.h"
#import <Foundation/Foundation.h>



@implementation AXBoxNode

+(AXBoxNode*)boxWithBundleID:(NSString *)bid{
    
    AXBoxNode* node = [AXBoxNode node];
    node.identifier = bid;
    node.geometry = [SCNBox boxWithWidth:1 height:1 length:1 chamferRadius:0.02];
    node.physicsBody = [SCNPhysicsBody bodyWithType:SCNPhysicsBodyTypeDynamic shape:[SCNPhysicsShape shapeWithGeometry:node.geometry options:nil]];
    node.position = SCNVector3Make(0, 4, 0);
    
    return node;
    
}

@end
