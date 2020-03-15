#import <UIKit/UIKit.h>

@interface AXControllerView : UIView

@property (nonatomic) BOOL isOn;

@property (nonatomic) BOOL isTappedTop;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;

@end


