#import "CoeusToggleController.h"

@implementation CoeusToggleController

- (instancetype)init {

	if (!(self = [super init])) {
		return self;
	}

	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveToggle)];
	self.navigationItem.rightBarButtonItem = addButton;

	return self;
}

- (id)specifiers {

	return _specifiers;
}

- (void)loadFromSpecifier:(PSSpecifier *)specifier {

	NSString *sub = [specifier propertyForKey:@"CoeusSub"];
	NSString *title = [specifier name];

	_specifiers = [[self loadSpecifiersFromPlistName:sub target:self] retain];

	[self setTitle:title];
	[self.navigationItem setTitle:title];
}

- (void)setSpecifier:(PSSpecifier *)specifier {

	[self loadFromSpecifier:specifier];
	[super setSpecifier:specifier];
}

- (BOOL)shouldReloadSpecifiersOnResume {

	return false;
}

- (PSSpecifier *)createSpec:(NSString *)name {

	PSSpecifier *newToggle = [PSSpecifier preferenceSpecifierNamed:name
	target:self
	set:NULL
	get:NULL
	detail:[CoeusToggleController class]
	cell:PSLinkCell
	edit:Nil];

	[newToggle setProperty:@"Toggle" forKey:@"CoeusSub"];
	[newToggle setProperty:NSStringFromSelector(@selector(removeToggle:)) forKey:PSDeletionActionKey];

	return newToggle;
}

- (void)saveToggle {
	NSLog(@"Test");
}

@end