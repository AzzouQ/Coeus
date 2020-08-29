#import "CoeusModuleListController.h"

@implementation CoeusModuleListController

- (instancetype)init {

	self = [super init];

	if (self) {
		CoeusAppearanceSettings *appearanceSettings = [[CoeusAppearanceSettings alloc] init];
		self.hb_appearanceSettings = appearanceSettings;
	}

	return self;
}

- (id)specifiers {

	return _specifiers;
}

- (void)setSpecifier:(PSSpecifier *)specifier {

	[self loadFromSpecifier:specifier];
	[super setSpecifier:specifier];
}

- (void)loadFromSpecifier:(PSSpecifier *)specifier {

	NSString *sub = [specifier propertyForKey:@"CoeusSub"];
	NSString *title = [specifier name];

	_specifiers = [[self loadSpecifiersFromPlistName:sub target:self] retain];

	[self setTitle:title];
	[self.navigationItem setTitle:title];
}

- (BOOL)shouldReloadSpecifiersOnResume {

	return false;
}

@end