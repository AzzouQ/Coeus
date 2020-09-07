#import "CoeusUILabeledRoundButtonViewController.h"

@implementation CoeusUILabeledRoundButtonViewController

- (instancetype)initWithToggle:(NSDictionary *)toggleDict {

	self.toggleDict = toggleDict;

	UIImage *image = nil;
	UIColor *color = ([[self.toggleDict objectForKey:@"isHighlightColor"] boolValue] ? LCPParseColorString([self.toggleDict objectForKey:@"highlightColor"], nil) : [UIColor systemBlueColor]);

	if ([[self.toggleDict objectForKey:@"isSFSymbols"] boolValue]) {
		if (@available(iOS 13.0, *)) {
			image = [UIImage systemImageNamed:[self.toggleDict objectForKey:@"glyphName"] withConfiguration:[UIImageSymbolConfiguration
			configurationWithPointSize:[[self.toggleDict objectForKey:@"sfSymbolsSize"] floatValue]
			weight:[[self.toggleDict objectForKey:@"sfSymbolsWeight"] integerValue]
			scale:[[self.toggleDict objectForKey:@"sfSymbolsScale"] integerValue]]];
		} 
	} else {
		image = [UIImage imageNamed:[NSString stringWithFormat:@"Glyphs/%@", [self.toggleDict objectForKey:@"glyphName"]] inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
	}

	if (!(image)) image = [UIImage imageNamed:@"Glyphs/Switch" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];

	if (!(self = [super initWithGlyphImage:image highlightColor:color useLightStyle:YES])) {
		return self;
	}

	if ((self.event = [[CoeusLAEvent alloc] initWithToggle:self.toggleDict])) {
		self.LAEvent = [LAEvent eventWithName:[self.toggleDict objectForKey:@"eventIdentifier"] mode:[LASharedActivator currentEventMode]];
		self.listenerName = [LASharedActivator assignedListenerNameForEvent:self.LAEvent];
	}

	return self;
}

- (void)viewDidLoad {

	[super viewDidLoad];

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

- (void)performButtonTapped:(id)arg1 {

	[LASharedActivator sendEventToListener:self.LAEvent];
	if (self.LAEvent.handled) {
		if ([self.listenerName containsString:@"switch-"]) {
			[super buttonTapped:arg1];
			[super setSubtitle:([self.subtitle isEqualToString:@"Enabled"] ? @"Disabled" : @"Enabled")];
		}
	}
}

- (void)useConfirmation:(id)arg1 {

	UIAlertController*buttonTappedAlert = [UIAlertController alertControllerWithTitle:[self.toggleDict objectForKey:@"name"] message:@"Are you sure to continue ?" preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDestructive handler:nil];
	UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		[self performButtonTapped:arg1];
	}];

	if (@available(iOS 13.0, *)) buttonTappedAlert.overrideUserInterfaceStyle = UIScreen.mainScreen.traitCollection.userInterfaceStyle;

	[buttonTappedAlert addAction:cancelAction];
	[buttonTappedAlert addAction:confirmAction];

	[self presentViewController:buttonTappedAlert animated:YES completion:nil];
}

- (void)buttonTapped:(id)arg1 {

	if ([[self.toggleDict objectForKey:@"isConfirmation"] boolValue]) {
		[self useConfirmation:arg1];
	} else {
		[self performButtonTapped:arg1];
	}
}

- (BOOL)_canShowWhileLocked {

	return YES;
}

@end