#import "CoeusToggleController.h"
#import "CoeusToggleGlyph.h"

@implementation CoeusToggleController

- (instancetype)initWithSpecifier:(PSSpecifier *)specifier {

	if (!(self = [super init])) {
		return self;
	}

	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveToggle)];
	self.navigationItem.rightBarButtonItem = addButton;

	self.toggleSpecifier = specifier;

	[self setSpecifier:specifier];
	return self;
}

- (id)specifiers {

	return _specifiers;
}

- (void)loadFromSpecifier:(PSSpecifier *)specifier {

	NSString *sub = [specifier propertyForKey:@"CoeusSub"];
	NSString *title = [specifier name];

	_specifiers = [[self loadSpecifiersFromPlistName:sub target:self] retain];

	[self insertSpecifier:[self createNameSpecifier] atIndex:1];
	[self insertSpecifier:[self createGlyphSpecifier] atIndex:3];
	if (@available(iOS 13.0, *)) {
		[self insertSpecifier:[self createSwitchSpecifier] atIndex:4];
		if ([[self.toggleSpecifier propertyForKey:@"SFSymbols"] boolValue]) {
			[self insertSpecifier:[self createSFSymbolsSpecifier] atIndex:5];
		}
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

- (PSSpecifier *)createNameSpecifier {

	PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@""
	target:self
	set:@selector(setName:)
	get:@selector(getName)
	detail:Nil
	cell:PSEditTextCell
	edit:Nil];

	return specifier;
}

- (void)setName:(NSString *)name {

	[self.toggleSpecifier setName:name];
}

- (NSString *)getName {

	return [self.toggleSpecifier name];
}

- (PSSpecifier *)createGlyphSpecifier {

	PSSpecifier* specifier = [PSSpecifier preferenceSpecifierNamed:@"Choose from preset"
	target:self
	set:@selector(setGlyph:)
	get:@selector(getGlyph)
	detail:NSClassFromString(@"PSListItemsController")
	cell:PSLinkListCell
	edit:Nil];

	NSArray *toggleGlyphList = [self getToggleGlyphList];

	specifier.values = toggleGlyphList;
	specifier.titleDictionary = [NSDictionary dictionaryWithObjects:toggleGlyphList forKeys:specifier.values];
	specifier.shortTitleDictionary = [NSDictionary dictionaryWithObjects:toggleGlyphList forKeys:specifier.values];

	[specifier setProperty:@"Glyph are located in '/Library/ControlCenter/Bundles/Coeus.bundle'" forKey:@"staticTextMessage"];

	return specifier;
}

- (PSSpecifier *)createSwitchSpecifier {

	PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"Use SF Symbols"
	target:self
	set:@selector(setSwitch:)
	get:@selector(getSwitch)
	detail:Nil
	cell:PSSwitchCell
	edit:Nil];

	return specifier;
}

- (void)setSwitch:(NSNumber *)sfSymbols {

	if ([sfSymbols boolValue]) {
		[self insertSpecifier:[self createSFSymbolsSpecifier] atIndex:5 animated:YES];
	} else {
		[self removeSpecifierAtIndex:5 animated:YES];
	}

	[self.toggleSpecifier setProperty:sfSymbols forKey:@"SFSymbols"];
}

- (NSNumber *)getSwitch {

	return [self.toggleSpecifier propertyForKey:@"SFSymbols"];
}

- (PSSpecifier *)createSFSymbolsSpecifier {

	PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@""
	target:self
	set:@selector(setGlyph:)
	get:@selector(getGlyph)
	detail:Nil
	cell:PSEditTextCell
	edit:Nil];

	return specifier;
}

- (void)setGlyph:(NSString *)glyph {

	[self.toggleSpecifier setProperty:glyph forKey:@"Glyph"];
}

- (NSString *)getGlyph {

	return [self.toggleSpecifier propertyForKey:@"Glyph"];
}

- (NSArray *)getToggleGlyphList {

	NSArray *bundleDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/Library/ControlCenter/Bundles/Coeus.bundle/" error:NULL];

	NSMutableArray *toggleGlyphList = [[NSMutableArray alloc] init];
	[bundleDirectory enumerateObjectsUsingBlock:^(id file, NSUInteger index, BOOL *stop) {
		NSString *filename = (NSString *)file;
		if (([filename containsString:@"@2x.png"]) && !([filename containsString:@"SettingsIcon"])) {
			[toggleGlyphList addObject:[filename stringByReplacingOccurrencesOfString:@"@2x.png" withString:@""]];
		}
	}];

	return toggleGlyphList;
}

- (NSMutableArray *)getToggle {

	NSString *name = [self.toggleSpecifier name];
	NSNumber *index = [self.toggleSpecifier propertyForKey:@"Index"];
	NSString *glyph = [self.toggleSpecifier propertyForKey:@"Glyph"];
	NSNumber *sfSymbols = [self.toggleSpecifier propertyForKey:@"SFSymbols"];

	return [[NSMutableArray alloc] initWithObjects:name, index, glyph, sfSymbols, nil];
}

- (void)updateToggle {

	prefs = [[HBPreferences alloc] initWithIdentifier:@"com.azzou.coeusprefs"];
	NSMutableArray *toggleList = [[prefs objectForKey:@"toggleList"] mutableCopy];

	[toggleList replaceObjectAtIndex:[[self.toggleSpecifier propertyForKey:@"Index"] integerValue] withObject:[self getToggle]];

	[prefs setObject:toggleList forKey:@"toggleList"];
	[self reload];
}

- (void)saveToggle {

	[self updateToggle];
	[[self navigationController] popViewControllerAnimated:YES];
}

- (void)setActivatorAction {

	LAEventSettingsController *vc = [[LAEventSettingsController alloc] initWithModes:[NSArray arrayWithObjects:@"springboard", @"lockscreen", @"application", nil] eventName:[NSString stringWithFormat:@"com.azzou.coeus.toggle%@", [self.toggleSpecifier propertyForKey:@"Index"]]];
	[[self navigationController] pushViewController:vc animated:YES];
}


@end