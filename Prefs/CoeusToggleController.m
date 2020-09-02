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

	PSSpecifier *toggleSpecifier = [PSSpecifier preferenceSpecifierNamed:@""
	target:self
	set:@selector(setName:)
	get:@selector(getName)
	detail:Nil
	cell:PSEditTextCell
	edit:Nil];

	return toggleSpecifier;
}

- (void)setName:(NSString *)name {

	[self.toggleSpecifier setName:name];
}

- (NSString *)getName {

    return [self.toggleSpecifier name];
}

- (PSSpecifier *)createGlyphSpecifier {

	PSSpecifier* specifier = [PSSpecifier preferenceSpecifierNamed:@"Choose a glyph"
	target:self
	set:@selector(setGlyph:)
	get:@selector(getGlyph)
	detail:NSClassFromString(@"PSListItemsController")
	cell:PSLinkListCell
	edit:Nil];

	specifier.values = [NSArray arrayWithObjects:DICT_GLYPH_VALUES nil];
	specifier.titleDictionary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:DICT_GLYPH_VALUES nil] forKeys:specifier.values];
	specifier.shortTitleDictionary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:DICT_GLYPH_VALUES nil] forKeys:specifier.values];

	[specifier setProperty:@"Glyph are located in 'Library/ControlCenter/Bundles/Coeus.bundles'" forKey:@"staticTextMessage"];

	return specifier;
}

- (void)setGlyph:(NSString *)glyph {

	[self.toggleSpecifier setProperty:glyph forKey:@"Glyph"];
}

- (NSString *)getGlyph {

	return [self.toggleSpecifier propertyForKey:@"Glyph"];
}

- (NSMutableArray *)getToggle:(PSSpecifier *)toggleSpecifier {

	NSString *name = [toggleSpecifier name];
	NSNumber *index = [toggleSpecifier propertyForKey:@"Index"];
	NSString *glyph = [toggleSpecifier propertyForKey:@"Glyph"];

	return [[NSMutableArray alloc] initWithObjects:name, index, glyph, nil];
}

- (void)updateToggle {

	prefs = [[HBPreferences alloc] initWithIdentifier:@"com.azzou.coeusprefs"];
	NSMutableArray *toggleList = [[prefs objectForKey:@"toggleList"] mutableCopy];

	[toggleList replaceObjectAtIndex:[[self.toggleSpecifier propertyForKey:@"Index"] integerValue] withObject:[self getToggle:self.toggleSpecifier]];

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