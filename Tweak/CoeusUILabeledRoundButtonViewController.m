#import "CoeusUILabeledRoundButtonViewController.h"

@implementation CoeusUILabeledRoundButtonViewController

- (instancetype)initWithEventIdentifier:(NSString *)eventIdentifier {

	if ((self.event = [[CoeusLAEvent alloc] initWithEventIdentifier:eventIdentifier])) {
		self.LAEvent = [LAEvent eventWithName:self.event.eventIdentifier mode:[LASharedActivator currentEventMode]];
		self.listenerName = [LASharedActivator assignedListenerNameForEvent:self.LAEvent];
	}
	UIImage *image;
	if (!(image = [LASharedActivator iconForListenerName:self.listenerName])) {
		image = [UIImage imageNamed:@"Power" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
	}
	// [super setEnabled:YES];
	// [super setInoperative:YES];
	// [self setEnabled:YES];
	// [self setInoperative:YES];
	if ((self = [super initWithGlyphImage:image highlightColor:[UIColor systemBlueColor] useLightStyle:YES])) {

		return self;
	}
	// [super setEnabled:YES];
	// [super setInoperative:YES];
	// [self setEnabled:YES];
	// [self setInoperative:YES];
	return self;
}

- (void)buttonTapped:(id)arg1 {

	[LASharedActivator sendEventToListener:self.LAEvent];

	if (self.LAEvent.handled) {
		if ([self.listenerName containsString:@"switch-"]) {
  			[super buttonTapped:arg1];
		}
    }
}

- (BOOL)_canShowWhileLocked {

	return YES;
}

@end