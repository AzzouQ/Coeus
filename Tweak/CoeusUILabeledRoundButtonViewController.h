#import <ControlCenterUIKit/CCUIRoundButton.h>
#import <ControlCenterUIKit/CCUILabeledRoundButton.h>
#import <ControlCenterUIKit/CCUILabeledRoundButtonViewController.h>
#import <Flipswitch/Flipswitch.h>
#include <CSColorPicker/CSColorPicker.h>

#import "CoeusLAEvent.h"

@interface CoeusUILabeledRoundButtonViewController : CCUILabeledRoundButtonViewController

@property (nonatomic, strong) NSDictionary *toggleDict;

@property (nonatomic, strong) CoeusLAEvent *event;
@property (nonatomic, strong) LAEvent *LAEvent;
@property (nonatomic, strong) NSString *listenerName;

- (id)initWithToggle:(NSDictionary *)toggleDict;

@end