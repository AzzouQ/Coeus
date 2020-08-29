#import <ControlCenterUIKit/CCUIRoundButton.h>
#import <ControlCenterUIKit/CCUILabeledRoundButton.h>
#import <ControlCenterUIKit/CCUILabeledRoundButtonViewController.h>
#import <Flipswitch/Flipswitch.h>

#import "CoeusLAEvent.h"

@interface CoeusUILabeledRoundButtonViewController : CCUILabeledRoundButtonViewController

@property (nonatomic, retain) CoeusLAEvent *event;
@property (nonatomic, retain) LAEvent *LAEvent;
@property (nonatomic, retain) NSString *listenerName;

- (id)initWithToggle:(NSArray *)toggle;

@end