#import "CoeusModuleListController.h"

@implementation CoeusModuleListController

- (instancetype)init {

	if (!(self = [super init])) {
		return self;
	}

	CoeusAppearanceSettings *appearanceSettings = [[CoeusAppearanceSettings alloc] init];
	self.hb_appearanceSettings = appearanceSettings;

	return self;
}

- (void)setSpecifier:(PSSpecifier *)specifier {

	_specifiers = [[self loadSpecifiersFromPlistName:@"Module" target:self] retain];

	[self setTitle:[specifier name]];
	[self.navigationItem setTitle:[specifier name]];

	[super setSpecifier:specifier];
}

- (BOOL)shouldReloadSpecifiersOnResume {

	return NO;
}

@end