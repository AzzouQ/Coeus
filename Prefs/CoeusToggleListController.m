#import "CoeusToggleListController.h"

@implementation CoeusToggleListController

- (id)specifiers {

	if (_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"ToggleList" target:self] retain];
	}

	return _specifiers;
}

- (void)viewWillAppear:(BOOL)animated {

	[super viewWillAppear:animated];

	[self reload];
}

- (void)viewDidLoad {

	[super viewDidLoad];

	[self loadSpecifierFromToggleList];
	[self reload];
}

- (void)loadSpecifierFromToggleList {

	NSArray *toggleList = [prefs objectForKey:@"toggleList"];
	NSMutableArray *specifierList = [[NSMutableArray alloc] init];

	for (NSDictionary *toggle in toggleList) {
		[specifierList addObject:[self createToggleSpecifier:[toggle objectForKey:@"name"]]];
	}
	[self insertContiguousSpecifiers:specifierList atEndOfGroup:1];
}

- (PSSpecifier *)createToggleSpecifier:(NSString *)name {

	PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:name target:self set:NULL get:NULL detail:NSClassFromString(@"CoeusToggleController") cell:PSLinkCell edit:Nil];

	[specifier setButtonAction:@selector(setToggleController:)];
	[specifier setProperty:NSStringFromSelector(@selector(removeToggle:)) forKey:@"deletionAction"];

	return specifier;
}

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

- (void)removeToggle:(PSSpecifier *)specifier {

	NSMutableArray *toggleList = [[prefs objectForKey:@"toggleList"] mutableCopy];

	[toggleList removeObjectAtIndex:[self indexPathForSpecifier:specifier].row];

	[prefs setObject:toggleList forKey:@"toggleList"];
}

- (void)saveToggle:(PSSpecifier *)specifier {

	NSMutableArray *toggleList = [[prefs objectForKey:@"toggleList"] mutableCopy];
	if (!(toggleList)) {
		toggleList = [[NSMutableArray alloc] init];
	}

	[toggleList addObject:[self initToggleWithSpecifier:specifier]];

	[prefs setObject:toggleList forKey:@"toggleList"];

	[self insertSpecifier:specifier atEndOfGroup:1];
}

- (NSMutableDictionary *)initToggleWithSpecifier:(PSSpecifier *)specifier {

	NSMutableDictionary *toggle = [[NSMutableDictionary alloc] init];

	[toggle setObject:[specifier name] forKey:@"name"];
	[toggle setObject:@"Switch" forKey:@"glyphName"];
	[toggle setObject:[NSNumber numberWithBool:NO] forKey:@"isSFSymbols"];
	[toggle setObject:[NSNumber numberWithFloat:20] forKey:@"sfSymbolsSize"];
	[toggle setObject:[NSNumber numberWithInteger:4] forKey:@"sfSymbolsWeight"];
	[toggle setObject:[NSNumber numberWithInteger:2] forKey:@"sfSymbolsScale"];
	[toggle setObject:[NSNumber numberWithBool:NO] forKey:@"isHighlightColor"];
	[toggle setObject:[UIColor PF_hexFromColor:[UIColor systemBlueColor]] forKey:@"highlightColor"];
	[toggle setObject:[NSNumber numberWithBool:NO] forKey:@"isConfirmation"];
	[toggle setObject:[self getEventIdentifier] forKey:@"eventIdentifier"];
	
	return toggle;
}

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

- (void)setToggleController:(PSSpecifier *)specifier {

	CoeusToggleController *toggleController = [[CoeusToggleController alloc] initWithSpecifier:specifier toggleIndex:[self indexPathForSpecifier:specifier].row];

	[self.navigationController pushViewController:toggleController animated:YES];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)atIndex toIndexPath:(NSIndexPath *)toIndex {

	NSMutableArray *toggleList = [[prefs objectForKey:@"toggleList"] mutableCopy];
	NSDictionary *toggle = [toggleList objectAtIndex:atIndex.row];

	[toggleList removeObject:toggle];
	[toggleList insertObject:toggle atIndex:toIndex.row];

	[self _moveSpecifierAtIndex:[self indexForIndexPath:atIndex] toIndex:[self indexForIndexPath:toIndex] animated:NO];

	[prefs setObject:toggleList forKey:@"toggleList"];

	[tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)atIndex {

   return YES;
}

- (BOOL)shouldReloadSpecifiersOnResume {

	return NO;
}

- (void)editDoneTapped {

	NSArray *specifierList = [self specifiersInGroup:1];

	[super editDoneTapped];

	for (PSSpecifier *specifier in specifierList) {
		[specifier setButtonAction:([self editable] ? Nil : @selector(setToggleController:))];
	}
}

@end