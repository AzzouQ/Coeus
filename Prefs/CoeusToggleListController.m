#import "CoeusToggleListController.h"

/*
	Toggle object {
		NSString	*name;
		UIImage		*glyph;
	}
*/

NSString *prefPath = @"/var/mobile/Library/Preferences/com.azzou.coeusprefs.plist";

@implementation CoeusToggleListController

- (PSSpecifier *)createSpecNamed:(NSString *)name value:(NSString *)value {
	PSSpecifier *tempSpec = [PSSpecifier preferenceSpecifierNamed:name
		target:self
		set:NULL
		get:@selector(getValue:)
		detail:Nil
		cell:PSTitleValueCell
		edit:Nil];
	[tempSpec setProperty:value forKey:@"value"];
	[tempSpec setButtonAction:@selector(editCode:)];
	[tempSpec setProperty:NSStringFromSelector(@selector(deletedCode:)) forKey:PSDeletionActionKey];
	return tempSpec;
}

- (NSString *)getValue: (PSSpecifier *) spec {
    return [spec propertyForKey:@"value"];
}

- (id)specifiers {
	if (_specifiers == nil) {
		NSMutableArray *specs = [NSMutableArray array];
		// initialize with group name
		PSSpecifier* testSpecifier = [PSSpecifier preferenceSpecifierNamed:@"Passcode Activators"
			target:self
			set:NULL
			get:NULL
			detail:Nil
			cell:PSGroupCell
			edit:Nil];
		[specs addObject:testSpecifier];
		NSMutableArray *rawSpecs = [[NSMutableArray alloc] initWithContentsOfFile:prefPath];
		for (NSArray *rawSpec in rawSpecs) {
			PSSpecifier* tempSpec = [self createSpecNamed:[rawSpec objectAtIndex:0] value:[rawSpec objectAtIndex:1]];
			[specs addObject:tempSpec];
		}

		_specifiers = [specs copy];
	}

	return _specifiers;
}

- (void)viewDidAppear:(BOOL)animated {

	[super viewDidAppear:animated];

	[self.navigationController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

- (void)viewWillAppear:(BOOL)animated {

	[super viewWillAppear:animated];

	UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
	UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
	[blurView setFrame:self.view.bounds];
	[blurView setAlpha:1.0];
	[self.view addSubview:blurView];

	[UIView animateWithDuration:.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		[blurView setAlpha:0.0];
	} completion:nil];

		UINavigationItem *nav = self.navigationItem;
	NSMutableArray *barItems = [(NSArray *)nav.rightBarButtonItems mutableCopy];

	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" 
			style:UIBarButtonItemStylePlain 
			target:self
			action:@selector(addCode)];
	addButton.tag = 1;

	[barItems addObject:addButton];

	[nav setRightBarButtonItems:[NSArray arrayWithArray:barItems]];
}

- (void)addCode {
	UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"OOOH Passcode"
		message:@""
		preferredStyle:UIAlertControllerStyleAlert];
	[alertController addTextFieldWithConfigurationHandler:^(UITextField *tf){}];
	UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
  	handler:^(UIAlertAction * action) {}];
	[alertController addAction:cancelAction];
	UIAlertAction* saveAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault
  	handler:^(UIAlertAction * action) {
		  [self alertView:alertController clickedButtonAtIndex:1];
	  }];
	[alertController addAction:saveAction];
	[self presentViewController:alertController animated:YES completion:nil];
}

- (void)alertView:(UIAlertController *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	NSString *pass = [alertView.textFields[0] text];
	NSDictionary *specData;

	// Adds a passcode object
	NSMutableArray *specs = [(NSArray*)_specifiers mutableCopy];
	PSSpecifier* tempSpec = [self createSpecNamed:[NSString stringWithFormat:@"Passcode %d", (int)[specs count]] value:pass];
	[specs addObject:tempSpec];
	_specifiers = [specs copy];
	specData = @{@"new": pass}; 

	[self reloadSpecifiers];
}

// - (void)setSpecifier:(PSSpecifier *)specifier {

// 	[self loadFromSpecifier:specifier];
// 	[super setSpecifier:specifier];
// }

// - (void)loadFromSpecifier:(PSSpecifier *)specifier {

// 	NSString *sub = [specifier propertyForKey:@"CoeusSub"];
// 	NSString *title = [specifier name];

// 	_specifiers = [[self loadSpecifiersFromPlistName:sub target:self] retain];

// 	[self setTitle:title];
// 	[self.navigationItem setTitle:title];
// }

// - (void)addToggle {

// 	UIAlertController *addAlert = [UIAlertController alertControllerWithTitle:@"CACACAC Toggle"
// 	message:@"Choose a name for your toggle"
// 	preferredStyle:UIAlertControllerStyleAlert];
	
// 	[addAlert addTextFieldWithConfigurationHandler:^(UITextField *tf){}];
	
// 	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
// 	UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
// 		[self createToggle:[addAlert.textFields[0] text]];
// 	}];

// 	[addAlert addAction:addAction];
// 	[addAlert addAction:cancelAction];

// 	[self presentViewController:addAlert animated:YES completion:nil];
// }

// - (void)createToggle:(NSString *)name {
// 	NSMutableArray *specs = [(NSArray*)_specifiers mutableCopy];
// 	PSSpecifier *newToggle = [PSSpecifier preferenceSpecifierNamed:@"CACA"
// 		target:self
// 		set:NULL
// 		get:@selector(getGlyph:)
// 		detail:Nil
// 		cell:PSTitleValueCell
// 		edit:Nil];
// 	[newToggle setProperty:@"Lock" forKey:@"glyph"];

// 	[specs addObject:newToggle];
// 	_specifiers = [specs copy];
// 	[self reloadSpecifiers];
// }

// - (NSString *)getGlyph:(PSSpecifier *)specifier {
//     return [specifier propertyForKey:@"glyph"];
// }

@end