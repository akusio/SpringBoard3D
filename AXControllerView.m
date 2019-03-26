#import "AXControllerView.h"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface AXControllerView ()

@end

@implementation AXControllerView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //NSLog(@"touches began");
    self.isOn = YES;
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //NSLog(@"touches ended");
    self.isOn = NO;
    
}

@end

