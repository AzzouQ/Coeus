#import "CoeusToggleListController.h"

#define INDEX_TOGGLE ([self indexOfSpecifier:specifier] - 3)

@implementation CoeusToggleListController

- (void)viewWillAppear:(BOOL)animated {

	[super viewWillAppear:animated];

	[self reload];
}

- (void)setSpecifier:(PSSpecifier *)specifier {

	[self loadSpecifier:specifier];
	[super setSpecifier:specifier];
}

- (void)loadSpecifier:(PSSpecifier *)specifier {

	NSString *sub = [specifier propertyForKey:@"CoeusSub"];
	NSString *title = [specifier name];

	_specifiers = [[self loadSpecifiersFromPlistName:sub target:self] retain];

	[self loadSpecifierFromToggleList];

	[self setTitle:title];
	[self.navigationItem setTitle:title];
}

- (void)loadSpecifierFromToggleList {

	NSArray *toggleList = [[[HBPreferences alloc] initWithIdentifier:@"com.azzou.coeusprefs"] objectForKey:@"toggleList"];

	for (NSDictionary *toggle in toggleList) {
		[self addToggleSpecifier:[toggle objectForKey:@"name"]];
	}
}

- (PSSpecifier *)addToggleSpecifier:(NSString *)name {

	PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:name target:self set:NULL get:NULL detail:NSClassFromString(@"CoeusToggleController") cell:PSLinkCell edit:Nil];

	[specifier setProperty:@"Toggle" forKey:@"CoeusSub"];
	[specifier setButtonAction:@selector(setToggleController:)];
	[specifier setProperty:NSStringFromSelector(@selector(removeToggle:)) forKey:PSDeletionActionKey];

	[self addSpecifier:specifier];
	return specifier;
}

- (void)addToggleAlert {

	UIAlertController *addToggleAlert = [UIAlertController alertControllerWithTitle:@"Add Toggle" message:@"Choose a name for your toggle" preferredStyle:UIAlertControllerStyleAlert];	
	UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
		PSSpecifier *specifier = [self addToggleSpecifier:[addToggleAlert.textFields[0] text]];
		[self saveToggle:specifier];
	}];
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

	[addToggleAlert addTextFieldWithConfigurationHandler:^(UITextField *tf){}];
	[addToggleAlert addAction:addAction];
	[addToggleAlert addAction:cancelAction];

	[self presentViewController:addToggleAlert animated:YES completion:nil];
}

- (void)removeToggle:(PSSpecifier *)specifier {

	prefs = [[HBPreferences alloc] initWithIdentifier:@"com.azzou.coeusprefs"];
	NSMutableArray *toggleList = [[prefs objectForKey:@"toggleList"] mutableCopy];

	[toggleList removeObjectAtIndex:INDEX_TOGGLE];

	for (NSInteger index = INDEX_TOGGLE; index < [toggleList count]; index++) {

		NSMutableDictionary *toggle = [[toggleList objectAtIndex:index] mutableCopy];

		[toggle setObject:[NSNumber numberWithInteger:index] forKey:@"index"];
		[toggleList replaceObjectAtIndex:index withObject:toggle];
	}

	[prefs setObject:toggleList forKey:@"toggleList"];
}

- (void)saveToggle:(PSSpecifier *)specifier {

	prefs = [[HBPreferences alloc] initWithIdentifier:@"com.azzou.coeusprefs"];
	NSMutableArray *toggleList = [[prefs objectForKey:@"toggleList"] mutableCopy];
	if (!(toggleList)) {
		toggleList = [[NSMutableArray alloc] init];
	}

	NSString *eventIdentifier = [self getEventIdentifier:[[toggleList lastObject] objectForKey:@"eventIdentifier"]];
	[toggleList addObject:[self initToggleWithSpecifier:specifier eventIdentifier:eventIdentifier]];

	[prefs setObject:toggleList forKey:@"toggleList"];
}

- (NSMutableDictionary *)initToggleWithSpecifier:(PSSpecifier *)specifier eventIdentifier:(NSString *)eventIdentifier{

	NSMutableDictionary *toggle = [[NSMutableDictionary alloc] init];

	[toggle setObject:[NSNumber numberWithInteger:INDEX_TOGGLE] forKey:@"index"];
	[toggle setObject:[specifier name] forKey:@"name"];
	[toggle setObject:@"Switch" forKey:@"glyphName"];
	[toggle setObject:[NSNumber numberWithBool:NO] forKey:@"isSFSymbols"];
	[toggle setObject:[NSNumber numberWithFloat:15] forKey:@"sfSymbolsSize"];
	[toggle setObject:[NSNumber numberWithInteger:1] forKey:@"sfSymbolsWeight"];
	[toggle setObject:[NSNumber numberWithInteger:1] forKey:@"sfSymbolsScale"];
	[toggle setObject:eventIdentifier forKey:@"eventIdentifier"];
	

	return toggle;
}

- (NSString *)getEventIdentifier:(NSString *)eventIdentifier {

	NSInteger newID = [[[eventIdentifier componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] integerValue];

	return [NSString stringWithFormat:@"com.azzou.coeus.toggle%ld", newID + 1];
}

- (void)setToggleController:(PSSpecifier *)specifier {

	prefs = [[HBPreferences alloc] initWithIdentifier:@"com.azzou.coeusprefs"];
	NSMutableDictionary *toggle = [[prefs objectForKey:@"toggleList"][INDEX_TOGGLE] mutableCopy];

	CoeusToggleController *toggleController = [[CoeusToggleController alloc] initWithSpecifier:specifier toggle:toggle];

	[self.navigationController pushViewController:toggleController animated:YES];
}

- (BOOL)shouldReloadSpecifiersOnResume {

	return false;
}

@end