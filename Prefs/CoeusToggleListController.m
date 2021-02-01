#import "CoeusToggleListController.h"

@implementation CoeusToggleListController

// Get the specifiers that aren't built manually from the plist
- (id)specifiers {

	if (_specifiers == nil) {
		_specifiers = [self loadSpecifiersFromPlistName:@"ToggleList" target:self];
	}

	return _specifiers;
}

// You know those already
- (void)viewWillAppear:(BOOL)animated {

	[super viewWillAppear:animated];

	[self reload];
}

// You know those already
- (void)viewDidLoad {

	[super viewDidLoad];

	[self loadSpecifierFromToggleList];
	[self reload];
}

// Get the specifiers that are already created and saved in the prefs
- (void)loadSpecifierFromToggleList {

	NSArray *toggleList = [prefs objectForKey:@"toggleList"];
	NSMutableArray *specifierList = [[NSMutableArray alloc] init];

	for (NSDictionary *toggle in toggleList) {
		[specifierList addObject:[self createToggleSpecifier:[toggle objectForKey:@"name"]]];
	}
	[self insertContiguousSpecifiers:specifierList atEndOfGroup:1];
}

// Create a specifier and get it ready to be added to our list
- (PSSpecifier *)createToggleSpecifier:(NSString *)name {

	PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:name target:self set:NULL get:NULL detail:NSClassFromString(@"CoeusToggleController") cell:PSLinkCell edit:Nil];

	[specifier setButtonAction:@selector(setToggleController:)];
	[specifier setProperty:NSStringFromSelector(@selector(removeToggle:)) forKey:@"deletionAction"];

	return specifier;
}

// Display the alert used to set a name to the Specifier (You don't need that)
- (void)addToggleAlert {

	UIAlertController *addToggleAlert = [UIAlertController alertControllerWithTitle:@"Add Toggle" message:@"Choose a name for your toggle" preferredStyle:UIAlertControllerStyleAlert];	
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:nil];
	UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		[self saveToggle:[self createToggleSpecifier:[addToggleAlert.textFields[0] text]]];
	}];

	[addToggleAlert addTextFieldWithConfigurationHandler:^(UITextField *tf){}];
	[addToggleAlert addAction:cancelAction];
	[addToggleAlert addAction:addAction];

	[self presentViewController:addToggleAlert animated:YES completion:nil];
}

// Remove the specifier from our prefs
- (void)removeToggle:(PSSpecifier *)specifier {

	NSMutableArray *toggleList = [[prefs objectForKey:@"toggleList"] mutableCopy];

	[toggleList removeObjectAtIndex:[self indexPathForSpecifier:specifier].row];

	[prefs setObject:toggleList forKey:@"toggleList"];
}

// Add new specifier
- (void)saveToggle:(PSSpecifier *)specifier {

	// Look if prefs contains specifier already, if not, init the list
	NSMutableArray *toggleList = [[prefs objectForKey:@"toggleList"] mutableCopy];
	if (!(toggleList)) {
		toggleList = [[NSMutableArray alloc] init];
	}

	// Add new specifier to the prefs
	[toggleList addObject:[self createToggleWithSpecifier:specifier]];
	[prefs setObject:toggleList forKey:@"toggleList"];

	// Add new specifier to the Controller
	[self insertSpecifier:specifier atEndOfGroup:1];
}

// Init the toggle on preferences, you don't need that
- (NSMutableDictionary *)createToggleWithSpecifier:(PSSpecifier *)specifier {

	NSMutableDictionary *toggle = [[NSMutableDictionary alloc] init];

	[toggle setObject:[specifier name] forKey:@"name"];
	[toggle setObject:@"Switch" forKey:@"glyphName"];
	[toggle setObject:[NSNumber numberWithBool:NO] forKey:@"isSFSymbols"];
	[toggle setObject:[NSNumber numberWithFloat:20] forKey:@"sfSymbolsSize"];
	[toggle setObject:[NSNumber numberWithInteger:4] forKey:@"sfSymbolsWeight"];
	[toggle setObject:[NSNumber numberWithInteger:2] forKey:@"sfSymbolsScale"];
	[toggle setObject:[NSNumber numberWithBool:NO] forKey:@"isHighlightColor"];
	[toggle setObject:[UIColor cscp_hexStringFromColor:[UIColor systemBlueColor] alpha:YES] forKey:@"highlightColor"];
	[toggle setObject:[NSNumber numberWithBool:NO] forKey:@"isConfirmation"];
	[toggle setObject:[self getEventIdentifier] forKey:@"eventIdentifier"];

	return toggle;
}


// Coeus only, activator related, you don't need that
- (NSString *)getEventIdentifier {

	NSMutableArray *toggleList = [prefs objectForKey:@"toggleList"];
	NSInteger newID = 0;
	NSInteger oldID = 0;

	for (NSDictionary *toggleDict in toggleList) {
		oldID = [[[[toggleDict objectForKey:@"eventIdentifier"] componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""] integerValue];
		if (oldID > newID) {
			newID = oldID; 
		}
	}

	return [NSString stringWithFormat:@"com.azzou.coeus.toggle%ld", newID + 1];
}

// Coeus only, used to make the toggle clickable, you don't need that
- (void)setToggleController:(PSSpecifier *)specifier {

	CoeusToggleController *toggleController = [[CoeusToggleController alloc] initWithSpecifier:specifier toggleIndex:[self indexPathForSpecifier:specifier].row];

	[self.navigationController pushViewController:toggleController animated:YES];
}

// Rearrange the list, you don't need that
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)atIndex toIndexPath:(NSIndexPath *)toIndex {

	NSMutableArray *toggleList = [[prefs objectForKey:@"toggleList"] mutableCopy];
	NSDictionary *toggle = [toggleList objectAtIndex:atIndex.row];

	[toggleList removeObject:toggle];
	[toggleList insertObject:toggle atIndex:toIndex.row];

	[self _moveSpecifierAtIndex:[self indexForIndexPath:atIndex] toIndex:[self indexForIndexPath:toIndex] animated:NO];

	[prefs setObject:toggleList forKey:@"toggleList"];

	[tableView reloadData];
}

// Modify the icon on the right of the list, you don't need that
- (void)editDoneTapped {

	NSArray *specifierList = [self specifiersInGroup:1];

	[super editDoneTapped];

	for (PSSpecifier *specifier in specifierList) {
		[specifier setButtonAction:([self editable] ? Nil : @selector(setToggleController:))];
	}
}

// Rearrange the list, you don't need that
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)atIndex {
	return YES;
}

// No idea of what it that
- (BOOL)shouldReloadSpecifiersOnResume {
	return NO;
}

@end
