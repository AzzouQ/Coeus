#import <ControlCenterUIKit/CCUIRoundButton.h>
#import <ControlCenterUIKit/CCUILabeledRoundButton.h>
#import <ControlCenterUIKit/CCUILabeledRoundButtonViewController.h>

#import "PlatoLAEvent.h"

@interface PlatoUILabeledRoundButtonViewController : CCUILabeledRoundButtonViewController

@property (nonatomic, retain) PlatoLAEvent *event;
@property (nonatomic, assign) NSString *eventIdentifier;

- (id)initWithEventIdentifier:(NSString *)eventIdentifier;

@end