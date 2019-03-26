#import "AXSceneViewController.h"
#import "headers.h"

AXSceneViewController* mainViewController;



static UIImage* getAppIcon(SBApplication* app){
    
    SBApplicationInfo* info = [app info];
    
    if([info hasHiddenTag]) return nil;
    
    SBApplicationIcon* icon = [[%c(SBApplicationIcon) alloc] initWithApplication:app];
    
    return [icon getUnmaskedIconImage:2];

}



%hook SBIconController

-(void)viewDidAppear:(BOOL)animated{
    
    %orig;
    
    if(mainViewController == nil){
        
        mainViewController = [[AXSceneViewController alloc] init];
        
        
        NSArray<SBApplication*>* apps = [[%c(SBApplicationController) sharedInstance] allApplications];
        
        for(SBApplication* app in apps){
            
            UIImage* texture = getAppIcon(app);
            
            if(texture == nil) continue;
            
            [mainViewController spawnBoxWithBundleID:[app bundleIdentifier] image:texture];
            
        }
        
    }

    [self.view addSubview:mainViewController.view];

    
    //[[%c(LSApplicationWorkspace) defaultWorkspace] openApplicationWithBundleID:@"com.apple.mobilesafari"];
    
    
}

%end



%ctor{
    
    [[NSBundle bundleWithPath:@"/System/Library/Frameworks/SceneKit.framework"] load];
    
}
