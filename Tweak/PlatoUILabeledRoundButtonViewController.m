#import "PlatoUILabeledRoundButtonViewController.h"

@implementation PlatoUILabeledRoundButtonViewController

- (instancetype)initWithEventIdentifier:(NSString *)eventIdentifier {

	if ((self = [super initWithGlyphImage:[UIImage imageNamed:@"Power" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil] highlightColor:[UIColor systemBlueColor] useLightStyle:YES])) {
		self.eventIdentifier = eventIdentifier;
		self.event = [[PlatoLAEvent alloc] initWithEventIdentifier:eventIdentifier];
		return self;
	}

	return self;
}

- (void)buttonTapped:(id)arg1 {

	[super buttonTapped:arg1];

	[LASharedActivator sendEventToListener:[LAEvent eventWithName:self.eventIdentifier mode:[LASharedActivator currentEventMode]]];
}

- (BOOL)_canShowWhileLocked {
	return YES;
}

@end