#import <ControlCenterUIKit/ControlCenterUIKit.h>

#import "CoeusUIModuleContentViewController.h"

typedef struct {
    unsigned long long width;
    unsigned long long height;
} CCUILayoutSize;

@interface CoeusUIContentModule : NSObject <CCUIContentModule>

@property(readonly, nonatomic) CoeusUIModuleContentViewController *contentViewController;
@property(readonly, nonatomic) UIViewController *backgroundViewController;

@end