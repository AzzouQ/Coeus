#import "CoeusUILabeledRoundButtonViewController.h"

@implementation CoeusUILabeledRoundButtonViewController

- (instancetype)initWithToggle:(NSArray *)toggle {

	UIImage *image = (([[toggle objectAtIndex:3] boolValue])
	? [UIImage systemImageNamed:[toggle objectAtIndex:2] withConfiguration:[UIImageSymbolConfiguration configurationWithPointSize:[[toggle objectAtIndex:4] floatValue] weight:[[toggle objectAtIndex:5] integerValue] scale:[[toggle objectAtIndex:6] integerValue]]]
	: [UIImage imageNamed:[toggle objectAtIndex:2] inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil]);

	if (!(image)) image = [UIImage imageNamed:@"Switch" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];

	if (!(self = [super initWithGlyphImage:image highlightColor:[UIColor systemBlueColor] useLightStyle:YES])) {
		return self;
	}

	if ((self.event = [[CoeusLAEvent alloc] initWithToggle:toggle])) {
		self.LAEvent = [LAEvent eventWithName:self.event.eventIdentifier mode:[LASharedActivator currentEventMode]];
		self.listenerName = [LASharedActivator assignedListenerNameForEvent:self.LAEvent];
	}

	return self;
}

- (void)buttonTapped:(id)arg1 {

	[LASharedActivator sendEventToListener:self.LAEvent];

	if (self.LAEvent.handled) {
		if ([self.listenerName containsString:@"switch-"]) {
  			[super buttonTapped:arg1];
			[super setSubtitle:([self.subtitle isEqualToString:@"Enabled"] ? @"Disabled" : @"Enabled")];
		}
    }
}

- (void)viewDidLoad {

	FSSwitchPanel *fsp = [FSSwitchPanel sharedPanel];
	NSString *switchIdentifier = [self.listenerName stringByReplacingOccurrencesOfString:@"switch-flip." withString:@""];

	if ([self.listenerName containsString:@"switch-"]) {
		switchIdentifier = [switchIdentifier stringByReplacingOccurrencesOfString:@"switch-on." withString:@""];
		switchIdentifier = [switchIdentifier stringByReplacingOccurrencesOfString:@"switch-off." withString:@""];

		FSSwitchState state = [fsp stateForSwitchIdentifier:switchIdentifier];

		if (FSSwitchStateOn == state) {
			[super setEnabled:YES];
			[super setSubtitle:@"Enabled"];
		} else {
			[super setSubtitle:@"Disabled"];
		}
	}
}

- (BOOL)_canShowWhileLocked {

	return YES;
}

@end