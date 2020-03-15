#import "AXControllerView.h"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface AXControllerView ()

@end

@implementation AXControllerView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //NSLog(@"touches began");
    
    UITouch* touch = [touches anyObject];
    
    CGPoint p = [touch locationInView:self];
    
    if(self.frame.size.height / 2 > p.y){
        
        self.isTappedTop = YES;
        
    }
    
    self.isOn = YES;
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //NSLog(@"touches ended");
    self.isTappedTop = NO;
    self.isOn = NO;
    
}

@end

