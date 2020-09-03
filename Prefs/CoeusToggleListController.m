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
		[self addSpecifier:[self createSpecifierFromToggle:[toggle objectAtIndex:0] index:[toggle objectAtIndex:1] glyphName:[toggle objectAtIndex:2] isSFSymbols:[toggle objectAtIndex:3] sfSymbolsSize:[toggle objectAtIndex:4] sfSymbolsWeight:[toggle objectAtIndex:5] sfSymbolsScale:[toggle objectAtIndex:6]]];
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

- (PSSpecifier *)createSpecifierFromToggle:(NSString *)name index:(NSNumber *)index glyphName:(NSString *)glyphName isSFSymbols:(NSNumber *)isSFSymbols sfSymbolsSize:(NSNumber *)sfSymbolsSize sfSymbolsWeight:(NSNumber *)sfSymbolsWeight sfSymbolsScale:(NSNumber *)sfSymbolsScale {

	PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:name
	target:self
	set:NULL
	get:NULL
	detail:NSClassFromString(@"CoeusToggleController")
	cell:PSLinkCell
	edit:Nil];

	[specifier setProperty:@"Toggle" forKey:@"CoeusSub"];
	[specifier setProperty:index forKey:@"index"];
	[specifier setProperty:glyphName forKey:@"glyphName"];
	[specifier setProperty:isSFSymbols forKey:@"isSFSymbols"];
	[specifier setProperty:sfSymbolsSize forKey:@"sfSymbolsSize"];
	[specifier setProperty:sfSymbolsWeight forKey:@"sfSymbolsWeight"];
	[specifier setProperty:sfSymbolsScale forKey:@"sfSymbolsScale"];
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
		PSSpecifier *toggleSpecifier = [self createSpecifierFromToggle:[addAlert.textFields[0] text] index:[NSNumber numberWithInteger:[[prefs objectForKey:@"toggleList"] count]] glyphName:@"Switch" isSFSymbols:[NSNumber numberWithBool:NO] sfSymbolsSize:[NSNumber numberWithFloat:15] sfSymbolsWeight:[NSNumber numberWithInteger:1] sfSymbolsScale:[NSNumber numberWithInteger:1]];
		[self saveToggle:toggleSpecifier];
		[self addSpecifier:toggleSpecifier];
		[self reload];
	}];

	[addAlert addAction:addAction];
	[addAlert addAction:cancelAction];

	[self presentViewController:addAlert animated:YES completion:nil];
}

- (NSMutableArray *)getToggleFromSpecifier:(PSSpecifier *)specifier {

	NSString *name = [specifier name];
	NSNumber *index = [specifier propertyForKey:@"index"];
	NSString *glyphName = [specifier propertyForKey:@"glyphName"];
	NSNumber *isSFSymbols = [specifier propertyForKey:@"isSFSymbols"];
	NSNumber *sfSymbolsSize = [specifier propertyForKey:@"sfSymbolsSize"];
	NSNumber *sfSymbolsWeight = [specifier propertyForKey:@"sfSymbolsWeight"];
	NSNumber *sfSymbolsScale = [specifier propertyForKey:@"sfSymbolsScale"];

	return [[NSMutableArray alloc] initWithObjects:name, index, glyphName, isSFSymbols, sfSymbolsSize, sfSymbolsWeight, sfSymbolsScale, nil];
}

- (void)saveToggle:(PSSpecifier *)specifier {

	prefs = [[HBPreferences alloc] initWithIdentifier:@"com.azzou.coeusprefs"];
	NSMutableArray *toggleList = [[prefs objectForKey:@"toggleList"] mutableCopy];
	if (!(toggleList)) {
		toggleList = [[NSMutableArray alloc] init];
	}

	[toggleList addObject:[self getToggleFromSpecifier:specifier]];

	[prefs setObject:toggleList forKey:@"toggleList"];
}

- (void)removeToggle:(PSSpecifier *)specifier {

	prefs = [[HBPreferences alloc] initWithIdentifier:@"com.azzou.coeusprefs"];
	NSMutableArray *toggleList = [[prefs objectForKey:@"toggleList"] mutableCopy];

	[toggleList removeObject:[self getToggleFromSpecifier:specifier]];

	[prefs setObject:toggleList forKey:@"toggleList"];
}

- (void)setToggleController:(PSSpecifier *)specifier {
	CoeusToggleController *toggleController = [[CoeusToggleController alloc] initWithSpecifier:specifier];
	[self.navigationController pushViewController:toggleController animated:YES];
}

@end