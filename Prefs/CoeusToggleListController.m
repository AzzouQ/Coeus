#import "CoeusToggleListController.h"

@implementation CoeusToggleListController

- (id)specifiers {

	return _specifiers;
}

- (void)viewWillAppear:(BOOL)animated {

	[super viewWillAppear:animated];

	[self reload];
}

- (void)loadFromSpecifier:(PSSpecifier *)specifier {

	NSString *sub = [specifier propertyForKey:@"CoeusSub"];
	NSString *title = [specifier name];
	NSMutableArray *toggleList = [[[HBPreferences alloc] initWithIdentifier:@"com.azzou.coeusprefs"] objectForKey:@"toggleList"];

	_specifiers = [[self loadSpecifiersFromPlistName:sub target:self] retain];

	for (NSArray *toggle in toggleList) {
		[self addSpecifier:[self createToggleSpecifier:[toggle objectAtIndex:0] index:[toggle objectAtIndex:1] glyph:[toggle objectAtIndex:2] sfSymbols:[toggle objectAtIndex:3]]];
	}

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

- (PSSpecifier *)createToggleSpecifier:(NSString *)name index:(NSNumber *)index glyph:(NSString *)glyph sfSymbols:(NSNumber *)sfSymbols {

	PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:name
	target:self
	set:NULL
	get:NULL
	detail:NSClassFromString(@"CoeusToggleController")
	cell:PSLinkCell
	edit:Nil];

	[specifier setProperty:@"Toggle" forKey:@"CoeusSub"];
	[specifier setProperty:index forKey:@"Index"];
	[specifier setProperty:glyph forKey:@"Glyph"];
	[specifier setProperty:sfSymbols forKey:@"SFSymbols"];
	[specifier setButtonAction:@selector(setToggleController:)];
	[specifier setProperty:NSStringFromSelector(@selector(removeToggle:)) forKey:PSDeletionActionKey];

	return specifier;
}

- (void)addToggle {

	prefs = [[HBPreferences alloc] initWithIdentifier:@"com.azzou.coeusprefs"];

	UIAlertController *addAlert = [UIAlertController alertControllerWithTitle:@"Add Toggle"
	message:@"Choose a name for your toggle"
	preferredStyle:UIAlertControllerStyleAlert];
	
	[addAlert addTextFieldWithConfigurationHandler:^(UITextField *tf){}];
	
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
	UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
		PSSpecifier *toggleSpecifier = [self createToggleSpecifier:[addAlert.textFields[0] text] index:[NSNumber numberWithInteger:[[prefs objectForKey:@"toggleList"] count]] glyph:@"Switch" sfSymbols:[NSNumber numberWithBool:NO]];
		[self saveToggle:toggleSpecifier];
		[self addSpecifier:toggleSpecifier];
		[self reload];
	}];

	[addAlert addAction:addAction];
	[addAlert addAction:cancelAction];

	[self presentViewController:addAlert animated:YES completion:nil];
}

- (NSMutableArray *)getToggle:(PSSpecifier *)specifier {

	NSString *name = [specifier name];
	NSNumber *index = [specifier propertyForKey:@"Index"];
	NSString *glyph = [specifier propertyForKey:@"Glyph"];
	NSNumber *sfSymbols = [specifier propertyForKey:@"SFSymbols"];

	return [[NSMutableArray alloc] initWithObjects:name, index, glyph, sfSymbols, nil];
}

- (void)saveToggle:(PSSpecifier *)specifier {

	prefs = [[HBPreferences alloc] initWithIdentifier:@"com.azzou.coeusprefs"];
	NSMutableArray *toggleList = [[prefs objectForKey:@"toggleList"] mutableCopy];
	if (!(toggleList)) {
		toggleList = [[NSMutableArray alloc] init];
	}

	[toggleList addObject:[self getToggle:specifier]];

	[prefs setObject:toggleList forKey:@"toggleList"];
}

- (void)removeToggle:(PSSpecifier *)specifier {

	prefs = [[HBPreferences alloc] initWithIdentifier:@"com.azzou.coeusprefs"];
	NSMutableArray *toggleList = [[prefs objectForKey:@"toggleList"] mutableCopy];

	[toggleList removeObject:[self getToggle:specifier]];

	[prefs setObject:toggleList forKey:@"toggleList"];
}

- (void)setToggleController:(PSSpecifier *)specifier {
	CoeusToggleController *toggleController = [[CoeusToggleController alloc] initWithSpecifier:specifier];
	[self.navigationController pushViewController:toggleController animated:YES];
}

@end