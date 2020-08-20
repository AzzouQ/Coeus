#import <ControlCenterUIKit/CCUIRoundButton.h>
#import <ControlCenterUIKit/CCUILabeledRoundButton.h>
#import <ControlCenterUIKit/CCUILabeledRoundButtonViewController.h>

#import "CoeusLAEvent.h"

@interface CoeusUILabeledRoundButtonViewController : CCUILabeledRoundButtonViewController

@property (nonatomic, retain) CoeusLAEvent *event;
@property (nonatomic, assign) NSString *eventIdentifier;

- (id)initWithEventIdentifier:(NSString *)eventIdentifier;

@end