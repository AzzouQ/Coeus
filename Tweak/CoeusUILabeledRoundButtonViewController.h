#import <ControlCenterUIKit/CCUIRoundButton.h>
#import <ControlCenterUIKit/CCUILabeledRoundButton.h>
#import <ControlCenterUIKit/CCUILabeledRoundButtonViewController.h>
#import <Flipswitch/Flipswitch.h>
#include <CSColorPicker/CSColorPicker.h>

#import "CoeusLAEvent.h"

@interface CoeusUILabeledRoundButtonViewController : CCUILabeledRoundButtonViewController

@property (nonatomic, assign) NSDictionary *toggleDict;

@property (nonatomic, retain) CoeusLAEvent *event;
@property (nonatomic, retain) LAEvent *LAEvent;
@property (nonatomic, retain) NSString *listenerName;

- (id)initWithToggle:(NSDictionary *)toggleDict;

@end