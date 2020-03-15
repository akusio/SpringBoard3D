#import "AXSceneViewController.h"
#import "AXControllerView.h"
#import "AXBoxNode.h"
#import "headers.h"


@interface AXSceneViewController () <UIGestureRecognizerDelegate, SCNSceneRendererDelegate>

@property SCNNode* mainCamera;
@property AXControllerView* controller;

@end

@implementation AXSceneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SCNView* view = [[SCNView alloc] initWithFrame:[[UIScreen mainScreen] bounds] options:nil];
    self.view = view;
    view.delegate = self;
    //view.allowsCameraControl = YES;
    
    
    SCNScene* scene = [SCNScene scene];
    scene.lightingEnvironment.contents = [UIColor blueColor];
    scene.background.contents = [UIColor grayColor];
    
    
    SCNNode* cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    //special effects (battery drain)
    //cameraNode.camera.wantsHDR = YES;
    //cameraNode.camera.contrast = 2.0;
    //cameraNode.camera.screenSpaceAmbientOcclusionRadius = 0.1;
    //cameraNode.camera.screenSpaceAmbientOcclusionIntensity = 1.0;
    //cameraNode.camera.wantsDepthOfField = YES;
    //cameraNode.camera.focusDistance = 1.5;
    //cameraNode.camera.fStop = 1.6;
    //cameraNode.camera.bloomBlurRadius = 2.0;
    //cameraNode.camera.bloomIntensity = 2.0;
    cameraNode.position = SCNVector3Make(0, 2, 0);
    self.mainCamera = cameraNode;
    
    
    SCNNode* floorNode = [SCNNode node];
    SCNFloor* floor = [SCNFloor floor];
    floorNode.physicsBody = [SCNPhysicsBody bodyWithType:0 shape:[SCNPhysicsShape shapeWithGeometry:floor options:nil]];
    floorNode.geometry = floor;
    
    
    SCNNode* lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeDirectional;
    lightNode.light.intensity = 800.0;
    lightNode.light.castsShadow = YES;
    lightNode.light.orthographicScale = 16;
    lightNode.light.shadowMapSize = CGSizeMake(1024, 1024);
    lightNode.light.maximumShadowDistance = 60;
    lightNode.light.shadowCascadeCount = 4;
    lightNode.rotation = SCNVector4Make(0.5, 0.25, 0, -1.0);
    
    
    SCNNode* ambientNode = [SCNNode node];
    ambientNode.light = [SCNLight light];
    ambientNode.light.type = SCNLightTypeAmbient;
    ambientNode.light.intensity = 250.0;
    
    
    [scene.rootNode addChildNode:lightNode];
    [scene.rootNode addChildNode:ambientNode];
    [scene.rootNode addChildNode:cameraNode];
    [scene.rootNode addChildNode:floorNode];
    
    view.scene = scene;
    
    
    AXControllerView* controller = [[AXControllerView alloc] initWithFrame:CGRectMake(20, 400, 100, 200)];
    controller.backgroundColor = [UIColor whiteColor];
    self.controller = controller;
    
    [self.view addSubview:controller];
    
    
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    pan.cancelsTouchesInView = NO;
    tap.cancelsTouchesInView = NO;
    pan.delegate = self;
    tap.delegate = self;
    [self.view addGestureRecognizer:pan];
    [self.view addGestureRecognizer:tap];
    
    view.playing = YES;
    
}

-(void)spawnBoxWithBundleID:(NSString*)bid image:(UIImage*)img{
    
    SCNView* view = (SCNView*)self.view;
    AXBoxNode* box = [AXBoxNode boxWithBundleID:bid];
    box.geometry.firstMaterial.diffuse.contents = img;
    [view.scene.rootNode addChildNode:box];
    
}


-(void)handlePan:(UIPanGestureRecognizer*)sender{
    
    SCNVector3 e = self.mainCamera.eulerAngles;
    
    CGPoint vel = [sender velocityInView:self.view];
    
    self.mainCamera.eulerAngles = SCNVector3Make(e.x + vel.y * -0.00005, e.y + vel.x * -0.00005, e.z);
    
}

-(void)handleTap:(UITapGestureRecognizer*)sender{
    
    SCNView* scnView = (SCNView*)self.view;
    CGPoint p = [sender locationInView:scnView];
    NSArray<SCNHitTestResult*>* hitResult = [scnView hitTest:p options:nil];
    
    if([hitResult count] > 0){
        
        if([hitResult[0].node isKindOfClass:[AXBoxNode class]]){
        
            NSLog(@"[AXIO]hit %@", hitResult[0].node);
            AXBoxNode* node = (AXBoxNode*)hitResult[0].node;
            
            SBApplication* app = [[NSClassFromString(@"SBApplicationController") sharedInstance] applicationWithBundleIdentifier:node.identifier];
            
            SBApplicationIcon* icon = [[NSClassFromString(@"SBApplicationIcon") alloc] initWithApplication:app];
            
            SBActivationSettings* empty = [[NSClassFromString(@"SBActivationSettings") alloc] init];
            
            [[NSClassFromString(@"SBUIController") sharedInstance] activateApplication:app fromIcon:icon location:NSClassFromString(@"SBIconLocationRoot") activationSettings:empty actions:nil];
            
        }
        
    }
    
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    //NSLog(@"%@", [touch view]);
    
    if([[touch view] isEqual:self.view]){
        
        return YES;
        
    }
    
    return NO;
    
}

-(void)renderer:(id<SCNSceneRenderer>)renderer updateAtTime:(NSTimeInterval)time{
    
    if(self.controller.isOn && self.controller.isTappedTop){
        
        SCNVector3 forward = self.mainCamera.worldFront;
        SCNVector3 pos = self.mainCamera.position;
        float speed = 0.1;
        self.mainCamera.position = SCNVector3Make(pos.x + forward.x * speed,
                                                  pos.y + forward.y * speed,
                                                  pos.z + forward.z * speed);
        
    }else if(self.controller.isOn && !self.controller.isTappedTop){
        
        SCNVector3 forward = self.mainCamera.worldFront;
        SCNVector3 pos = self.mainCamera.position;
        float speed = 0.1;
        self.mainCamera.position = SCNVector3Make(pos.x - forward.x * speed,
                                                  pos.y - forward.y * speed,
                                                  pos.z - forward.z * speed);
        
    }
    
}

@end
