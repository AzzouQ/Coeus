#import <Cephei/HBPreferences.h>
#import <ControlCenterUIKit/ControlCenterUIKit.h>

#import "PlatoUIModuleContentViewController.h"

typedef struct {
	unsigned long long width;
	unsigned long long height;
} CCUILayoutSize;

HBPreferences *prefs;

@interface PlatoUIModule : NSObject <CCUIContentModule>

@property(readonly, nonatomic) PlatoUIModuleContentViewController *contentViewController;
@property(readonly, nonatomic) UIViewController *backgroundViewController;

@end