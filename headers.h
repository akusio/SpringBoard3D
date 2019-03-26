
@interface SBIconController : UIViewController
@end

@interface LSApplicationWorkspace
+(LSApplicationWorkspace*)defaultWorkspace;
-(BOOL)openApplicationWithBundleID:(NSString*)bundleID;
@end



@interface SBApplicationInfo : NSObject

-(BOOL)hasHiddenTag;

@end


@interface SBApplication : NSObject

-(SBApplicationInfo*)info;
-(NSString*)bundleIdentifier;

@end

@interface SBApplicationIcon : NSObject

-(id)initWithApplication:(SBApplication*)arg1;
-(id)getUnmaskedIconImage:(int)arg1;

@end

@interface SBApplicationController : NSObject

+(id)sharedInstance;
-(id)allApplications;
-(SBApplication*)applicationWithBundleIdentifier:(NSString*)arg1;

@end

@interface SBActivationSettings : NSObject

@end

@interface SBUIController : NSObject

+(instancetype)sharedInstance;
-(void)activateApplication:(id)arg1 fromIcon:(id)arg2 location:(long long)arg3 activationSettings:(id)arg4 actions:(id)arg5;

@end
