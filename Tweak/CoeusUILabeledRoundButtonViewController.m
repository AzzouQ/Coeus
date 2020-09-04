#import "CoeusUILabeledRoundButtonViewController.h"

@implementation CoeusUILabeledRoundButtonViewController

- (instancetype)initWithToggle:(NSDictionary *)toggle {

	UIImage *image = (([[toggle objectForKey:@"isSFSymbols"] boolValue])
	? [UIImage systemImageNamed:[toggle objectForKey:@"glyphName"] withConfiguration:[UIImageSymbolConfiguration
	configurationWithPointSize:[[toggle objectForKey:@"sfSymbolsSize"] floatValue]
	weight:[[toggle objectForKey:@"sfSymbolsWeight"] integerValue]
	scale:[[toggle objectForKey:@"sfSymbolsScale"] integerValue]]]
	: [UIImage imageNamed:[toggle objectForKey:@"glyphName"] inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil]);

	if (!(image)) image = [UIImage imageNamed:@"Switch" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];

	if (!(self = [super initWithGlyphImage:image highlightColor:[UIColor systemBlueColor] useLightStyle:YES])) {
		return self;
	}

	if ((self.event = [[CoeusLAEvent alloc] initWithToggle:toggle])) {
		self.LAEvent = [LAEvent eventWithName:[toggle objectForKey:@"eventIdentifier"] mode:[LASharedActivator currentEventMode]];
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