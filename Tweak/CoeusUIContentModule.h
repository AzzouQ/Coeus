#import <ControlCenterUIKit/ControlCenterUIKit.h>

#import "CoeusUIModuleContentViewController.h"

typedef struct {
	NSUInteger width;
	NSUInteger height;
} CCUILayoutSize;

@interface CoeusUIContentModule : NSObject <CCUIContentModule>

@property(readonly, nonatomic) CoeusUIModuleContentViewController *contentViewController;
@property(readonly, nonatomic) UIViewController *backgroundViewController;

@end