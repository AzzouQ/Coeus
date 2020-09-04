#import "CoeusToggleListController.h"

#define INDEX_TOGGLE ([self indexOfSpecifier:specifier] - 3)

@implementation CoeusToggleListController

- (void)viewWillAppear:(BOOL)animated {

	[super viewWillAppear:animated];

	[self reload];
}

- (void)setSpecifier:(PSSpecifier *)specifier {

	prefs = [[HBPreferences alloc] initWithIdentifier:@"com.azzou.coeusprefs"];

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

	NSArray *toggleList = [prefs objectForKey:@"toggleList"];

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

	NSMutableArray *toggleList = [[prefs objectForKey:@"toggleList"] mutableCopy];

	[toggleList removeObjectAtIndex:INDEX_TOGGLE];

	[prefs setObject:toggleList forKey:@"toggleList"];
}

- (void)saveToggle:(PSSpecifier *)specifier {

	NSMutableArray *toggleList = [[prefs objectForKey:@"toggleList"] mutableCopy];
	if (!(toggleList)) {
		toggleList = [[NSMutableArray alloc] init];
	}

	[toggleList addObject:[self initToggleWithSpecifier:specifier]];

	[prefs setObject:toggleList forKey:@"toggleList"];
}

- (NSMutableDictionary *)initToggleWithSpecifier:(PSSpecifier *)specifier {

	NSMutableDictionary *toggle = [[NSMutableDictionary alloc] init];

	[toggle setObject:[specifier name] forKey:@"name"];
	[toggle setObject:@"Switch" forKey:@"glyphName"];
	[toggle setObject:[NSNumber numberWithBool:NO] forKey:@"isSFSymbols"];
	[toggle setObject:[NSNumber numberWithFloat:20] forKey:@"sfSymbolsSize"];
	[toggle setObject:[NSNumber numberWithInteger:4] forKey:@"sfSymbolsWeight"];
	[toggle setObject:[NSNumber numberWithInteger:2] forKey:@"sfSymbolsScale"];
	[toggle setObject:[self getEventIdentifier] forKey:@"eventIdentifier"];
	

	return toggle;
}

- (NSString *)getEventIdentifier {

	NSMutableArray *toggleList = [prefs objectForKey:@"toggleList"];
	NSInteger newID = 0;
	NSInteger tempID = 0;

	for (NSDictionary *toggleDict in toggleList) {
		tempID = [[[[toggleDict objectForKey:@"eventIdentifier"] componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] integerValue];
		if (tempID > newID) {
			newID = tempID; 
		}
	}

	return [NSString stringWithFormat:@"com.azzou.coeus.toggle%ld", newID + 1];
}

- (void)setToggleController:(PSSpecifier *)specifier {

	CoeusToggleController *toggleController = [[CoeusToggleController alloc] initWithSpecifier:specifier toggleIndex:INDEX_TOGGLE];

	[self.navigationController pushViewController:toggleController animated:YES];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)atIndex toIndexPath:(NSIndexPath *)toIndex {

	NSMutableArray *toggleList = [[prefs objectForKey:@"toggleList"] mutableCopy];
	NSMutableDictionary *toggle = [[toggleList objectAtIndex:atIndex.row] mutableCopy];

	[toggleList removeObject:toggle];
	[toggleList insertObject:toggle atIndex:toIndex.row];

	[prefs setObject:toggleList forKey:@"toggleList"];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)atIndex {

   return YES;
}

- (BOOL)shouldReloadSpecifiersOnResume {

	return false;
}

@end