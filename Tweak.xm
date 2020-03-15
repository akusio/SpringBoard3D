#import "AXSceneViewController.h"
#import "headers.h"

AXSceneViewController* mainViewController;



static UIImage* getAppIcon(SBApplication* app){
    
    SBApplicationInfo* info = [app info];
    
    if([info hasHiddenTag]) return nil;
    
    SBApplicationIcon* icon = [[%c(SBApplicationIcon) alloc] initWithApplication:app];
    
    struct SBIconImageInfo iconInfo;
    
    iconInfo.size = CGSizeMake(128, 128);
    iconInfo.scale = 2.0;
    iconInfo.continuousCornerRadius = 0;
    
    return [icon unmaskedIconImageWithInfo:iconInfo];

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
            
            NSLog(@"[AXIO] %@, %@", [app bundleIdentifier], texture);
            
            [mainViewController spawnBoxWithBundleID:[app bundleIdentifier] image:texture];
            
            NSLog(@"[AXIO]");
            
        }
        
        
    }

    [self.view addSubview:mainViewController.view];

    
    //[[%c(LSApplicationWorkspace) defaultWorkspace] openApplicationWithBundleID:@"com.apple.mobilesafari"];
    
    
}

%end

/*
%hook SBUIController

-(void)activateApplication:(id)arg1 fromIcon:(id)arg2 location:(id)arg3 activationSettings:(id)arg4 actions:(id)arg5{
    
    NSLog(@"[AXIO]arg1(%@)\n\narg2(%@)\n\narg3(%@)\n\narg4(%@)\n\narg5(%@)", arg1, arg2, arg3, arg4, arg5);
    
    return %orig;
    
}

%end
*/

%ctor{
    
    [[NSBundle bundleWithPath:@"/System/Library/Frameworks/SceneKit.framework"] load];
    
}
