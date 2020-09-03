#import "CoeusToggleController.h"

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

	[self insertSpecifier:[self createToggleNameSpecifier] atIndex:1];
	[self insertSpecifier:[self createGlyphListSpecifier] atIndex:3];
	if (@available(iOS 13.0, *)) {
		[self insertSpecifier:[self createSFSymbolsSpecifier] atIndex:4];
		if ([[self.toggleSpecifier propertyForKey:@"isSFSymbols"] boolValue]) {
			[[self specifierAtIndex:3] setProperty:@NO forKey:@"enabled"];
			[self insertSpecifier:[self createSFSymbolsSizeSpecifier] atIndex:5];
			[self insertSpecifier:[self createSFSymbolsWeightSpecifier] atIndex:6];
			[self insertSpecifier:[self createSFSymbolsScaleSpecifier] atIndex:7];
			[self insertSpecifier:[self createSFSymbolsNameSpecifier] atIndex:8];
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

- (PSSpecifier *)createToggleNameSpecifier {

	PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"" target:self set:@selector(setName:) get:@selector(getName) detail:Nil cell:PSEditTextCell edit:Nil];

	return specifier;
}

- (void)setName:(NSString *)name {

	[self.toggleSpecifier setName:name];
}

- (NSString *)getName {

	return [self.toggleSpecifier name];
}

- (PSSpecifier *)createGlyphListSpecifier {

	NSArray *glyphList = [self getGlyphList];
	PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"Choose from preset" target:self set:@selector(setGlyph:) get:@selector(getGlyph) detail:NSClassFromString(@"PSListItemsController") cell:PSLinkListCell edit:Nil];

	[specifier setProperty:@"Glyph are located in '/Library/ControlCenter/Bundles/Coeus.bundle'" forKey:@"staticTextMessage"];

	specifier.values = glyphList;
	specifier.titleDictionary = [NSDictionary dictionaryWithObjects:glyphList forKeys:specifier.values];
	specifier.shortTitleDictionary = [NSDictionary dictionaryWithObjects:glyphList forKeys:specifier.values];

	return specifier;
}

- (void)setGlyph:(NSString *)glyph {

	[self.toggleSpecifier setProperty:glyph forKey:@"glyphName"];
}

- (NSString *)getGlyph {

	return [self.toggleSpecifier propertyForKey:@"glyphName"];
}

- (NSArray *)getGlyphList {

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

- (PSSpecifier *)createSFSymbolsSpecifier {

	PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"Use SF Symbols" target:self set:@selector(setSFSymbols:) get:@selector(isSFSymbols) detail:Nil cell:PSSwitchCell edit:Nil];

	return specifier;
}

- (void)setSFSymbols:(NSNumber *)sfSymbols {

	if ([sfSymbols boolValue]) {
		[[self specifierAtIndex:3] setProperty:@NO forKey:@"enabled"];
		[self insertSpecifier:[self createSFSymbolsSizeSpecifier] atIndex:5 animated:YES];
		[self insertSpecifier:[self createSFSymbolsWeightSpecifier] atIndex:6 animated:YES];
		[self insertSpecifier:[self createSFSymbolsScaleSpecifier] atIndex:7 animated:YES];
		[self insertSpecifier:[self createSFSymbolsNameSpecifier] atIndex:8 animated:YES];
	} else {
		[[self specifierAtIndex:3] setProperty:@YES forKey:@"enabled"];
		[self removeSpecifierAtIndex:5 animated:YES];
		[self removeSpecifierAtIndex:5 animated:YES];
		[self removeSpecifierAtIndex:5 animated:YES];
		[self removeSpecifierAtIndex:5 animated:YES];
	}

	[self reloadSpecifierAtIndex:3 animated:YES];
	[self.toggleSpecifier setProperty:sfSymbols forKey:@"isSFSymbols"];
}

- (NSNumber *)isSFSymbols {

	return [self.toggleSpecifier propertyForKey:@"isSFSymbols"];
}

- (PSSpecifier *)createSFSymbolsWeightSpecifier {

	NSArray *sfSymbolsWeightValueList = [[NSMutableArray alloc] initWithObjects:
	[NSNumber numberWithInteger:UIImageSymbolWeightUltraLight],
	[NSNumber numberWithInteger:UIImageSymbolWeightThin],
	[NSNumber numberWithInteger:UIImageSymbolWeightLight],
	[NSNumber numberWithInteger:UIImageSymbolWeightRegular],
	[NSNumber numberWithInteger:UIImageSymbolWeightMedium],
	[NSNumber numberWithInteger:UIImageSymbolWeightSemibold],
	[NSNumber numberWithInteger:UIImageSymbolWeightBold],
	[NSNumber numberWithInteger:UIImageSymbolWeightHeavy],
	[NSNumber numberWithInteger:UIImageSymbolWeightBlack],
	nil];

	NSArray *sfSymbolsWeightNameList = [[NSMutableArray alloc] initWithObjects:
	@"Ultra Light",
	@"Thin",
	@"Light",
	@"Regular",
	@"Medium",
	@"Semibold",
	@"Bold",
	@"Heavy",
	@"Black",
	nil];

	PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"Weight" target:self set:@selector(setWeight:) get:@selector(getWeight) detail:NSClassFromString(@"PSListItemsController") cell:PSLinkListCell edit:Nil];

	specifier.values = sfSymbolsWeightValueList;
	specifier.titleDictionary = [NSDictionary dictionaryWithObjects:sfSymbolsWeightNameList forKeys:specifier.values];
	specifier.shortTitleDictionary = [NSDictionary dictionaryWithObjects:sfSymbolsWeightNameList forKeys:specifier.values];

	return specifier;
}

- (PSSpecifier *)createSFSymbolsSizeSpecifier {

	PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"Size" target:self set:@selector(setSize:) get:@selector(getSize) detail:Nil cell:PSSliderCell edit:Nil];

	[specifier setProperty:[UIImage imageNamed:@"Size" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil] forKey:@"leftImage"];
	[specifier setProperty:[NSNumber numberWithFloat:20.0] forKey:@"default"];
	[specifier setProperty:[NSNumber numberWithFloat:15.0] forKey:@"min"];
	[specifier setProperty:[NSNumber numberWithFloat:25.0] forKey:@"max"];
	[specifier setProperty:@YES forKey:@"showValue"];

	return specifier;
}

- (void)setSize:(NSNumber *)size {

	[self.toggleSpecifier setProperty:size forKey:@"sfSymbolsSize"];
}

- (NSString *)getSize {

	return [self.toggleSpecifier propertyForKey:@"sfSymbolsSize"];
}

- (void)setWeight:(NSNumber *)size {

	[self.toggleSpecifier setProperty:size forKey:@"sfSymbolsWeight"];
}

- (NSNumber *)getWeight {

	return [self.toggleSpecifier propertyForKey:@"sfSymbolsWeight"];
}

- (PSSpecifier *)createSFSymbolsScaleSpecifier {

	NSArray *sfSymbolsScaleValueList = [[NSMutableArray alloc] initWithObjects:
	[NSNumber numberWithInteger:UIImageSymbolScaleSmall],
	[NSNumber numberWithInteger:UIImageSymbolScaleMedium],
	[NSNumber numberWithInteger:UIImageSymbolScaleLarge],
	nil];

	NSArray *sfSymbolsScaleNameList = [[NSMutableArray alloc] initWithObjects:
	@"Small",
	@"Medium",
	@"Large",
	nil];

	PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"Scale" target:self set:@selector(setScale:) get:@selector(getScale) detail:NSClassFromString(@"PSListItemsController") cell:PSLinkListCell edit:Nil];

	specifier.values = sfSymbolsScaleValueList;
	specifier.titleDictionary = [NSDictionary dictionaryWithObjects:sfSymbolsScaleNameList forKeys:specifier.values];
	specifier.shortTitleDictionary = [NSDictionary dictionaryWithObjects:sfSymbolsScaleNameList forKeys:specifier.values];

	return specifier;
}

- (void)setScale:(NSNumber *)size {

	[self.toggleSpecifier setProperty:size forKey:@"sfSymbolsScale"];
}

- (NSNumber *)getScale {

	return [self.toggleSpecifier propertyForKey:@"sfSymbolsScale"];
}

- (PSSpecifier *)createSFSymbolsNameSpecifier {

	PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"Name" target:self set:@selector(setGlyph:) get:@selector(getGlyph) detail:Nil cell:PSEditTextCell edit:Nil];

	return specifier;
}

- (NSMutableArray *)getToggleFromSpecifier {

	NSString *name = [self.toggleSpecifier name];
	NSNumber *index = [self.toggleSpecifier propertyForKey:@"index"];
	NSString *glyphName = [self.toggleSpecifier propertyForKey:@"glyphName"];
	NSNumber *isSFSymbols = [self.toggleSpecifier propertyForKey:@"isSFSymbols"];
	NSNumber *sfSymbolsSize = [self.toggleSpecifier propertyForKey:@"sfSymbolsSize"];
	NSNumber *sfSymbolsWeight = [self.toggleSpecifier propertyForKey:@"sfSymbolsWeight"];
	NSNumber *sfSymbolsScale = [self.toggleSpecifier propertyForKey:@"sfSymbolsScale"];

	return [[NSMutableArray alloc] initWithObjects:name, index, glyphName, isSFSymbols, sfSymbolsSize, sfSymbolsWeight, sfSymbolsScale,nil];
}

- (void)updateToggle {

	prefs = [[HBPreferences alloc] initWithIdentifier:@"com.azzou.coeusprefs"];
	NSMutableArray *toggleList = [[prefs objectForKey:@"toggleList"] mutableCopy];

	[toggleList replaceObjectAtIndex:[[self.toggleSpecifier propertyForKey:@"index"] integerValue] withObject:[self getToggleFromSpecifier]];

	[prefs setObject:toggleList forKey:@"toggleList"];
	[self reload];
}

- (void)saveToggle {

	[self.view endEditing:YES];
	[self updateToggle];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)setActivatorAction {

	LAEventSettingsController *vc = [[LAEventSettingsController alloc] initWithModes:[NSArray arrayWithObjects:@"springboard", @"lockscreen", @"application", nil] eventName:[NSString stringWithFormat:@"com.azzou.coeus.toggle%@", [self.toggleSpecifier propertyForKey:@"Index"]]];
	[self.navigationController pushViewController:vc animated:YES];
}

@end