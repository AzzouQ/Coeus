#import "CoeusToggleController.h"

@implementation CoeusToggleController

- (instancetype)initWithSpecifier:(PSSpecifier *)specifier toggle:(NSMutableDictionary *)toggle {

	if (!(self = [super init])) {
		return self;
	}

	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(updateToggle)];
	self.specifier = specifier;
	self.toggle = toggle;

	[self setSpecifier:specifier];

	return self;
}

- (void)setSpecifier:(PSSpecifier *)specifier {

	[self loadSpecifier:specifier];
	[super setSpecifier:specifier];
}

- (void)loadSpecifier:(PSSpecifier *)specifier {

	NSString *sub = [specifier propertyForKey:@"CoeusSub"];
	NSString *title = [specifier name];

	_specifiers = [[self loadSpecifiersFromPlistName:sub target:self] retain];

	[self loadSpecifiersFromToggle];

	[self setTitle:title];
	[self.navigationItem setTitle:title];
}

- (void)loadSpecifiersFromToggle {

	[self insertSpecifier:[self createToggleNameSpecifier] atIndex:1];
	[self insertSpecifier:[self createGlyphListSpecifier] atIndex:3];
	if (@available(iOS 13.0, *)) {
		[self insertSpecifier:[self createSFSymbolsSpecifier] atIndex:4];
		if ([[self.toggle objectForKey:@"isSFSymbols"] boolValue]) {
			[[self specifierAtIndex:3] setProperty:@NO forKey:@"enabled"];
			[self insertSpecifier:[self createSFSymbolsSizeSpecifier] atIndex:5];
			[self insertSpecifier:[self createSFSymbolsWeightSpecifier] atIndex:6];
			[self insertSpecifier:[self createSFSymbolsScaleSpecifier] atIndex:7];
			[self insertSpecifier:[self createSFSymbolsNameSpecifier] atIndex:8];
		}
	}
}

- (PSSpecifier *)createToggleNameSpecifier {

	PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"" target:self set:@selector(setName:) get:@selector(getName) detail:Nil cell:PSEditTextCell edit:Nil];

	return specifier;
}


- (PSSpecifier *)createGlyphListSpecifier {

	NSArray *glyphList = [self getGlyphList];
	PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"Choose from preset" target:self set:@selector(setGlyphName:) get:@selector(getGlyphName) detail:NSClassFromString(@"PSListItemsController") cell:PSLinkListCell edit:Nil];

	[specifier setProperty:@"Glyph are located in '/Library/ControlCenter/Bundles/Coeus.bundle'" forKey:@"staticTextMessage"];

	specifier.values = glyphList;
	specifier.titleDictionary = [NSDictionary dictionaryWithObjects:glyphList forKeys:specifier.values];
	specifier.shortTitleDictionary = [NSDictionary dictionaryWithObjects:glyphList forKeys:specifier.values];

	return specifier;
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

	PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"Weight" target:self set:@selector(setSFSymbolsWeight:) get:@selector(getSFSymbolsWeight) detail:NSClassFromString(@"PSListItemsController") cell:PSLinkListCell edit:Nil];

	specifier.values = sfSymbolsWeightValueList;
	specifier.titleDictionary = [NSDictionary dictionaryWithObjects:sfSymbolsWeightNameList forKeys:specifier.values];
	specifier.shortTitleDictionary = [NSDictionary dictionaryWithObjects:sfSymbolsWeightNameList forKeys:specifier.values];

	return specifier;
}

- (PSSpecifier *)createSFSymbolsSizeSpecifier {

	PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"Size" target:self set:@selector(setSFSymbolsSize:) get:@selector(getSFSymbolsSize) detail:Nil cell:PSSliderCell edit:Nil];

	[specifier setProperty:[UIImage imageNamed:@"Size" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil] forKey:@"leftImage"];
	[specifier setProperty:[NSNumber numberWithFloat:20.0] forKey:@"default"];
	[specifier setProperty:[NSNumber numberWithFloat:15.0] forKey:@"min"];
	[specifier setProperty:[NSNumber numberWithFloat:25.0] forKey:@"max"];
	[specifier setProperty:@YES forKey:@"showValue"];

	return specifier;
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

	PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"Scale" target:self set:@selector(setSFSymbolsScale:) get:@selector(getSFSymbolsScale) detail:NSClassFromString(@"PSListItemsController") cell:PSLinkListCell edit:Nil];

	specifier.values = sfSymbolsScaleValueList;
	specifier.titleDictionary = [NSDictionary dictionaryWithObjects:sfSymbolsScaleNameList forKeys:specifier.values];
	specifier.shortTitleDictionary = [NSDictionary dictionaryWithObjects:sfSymbolsScaleNameList forKeys:specifier.values];

	return specifier;
}

- (PSSpecifier *)createSFSymbolsNameSpecifier {

	PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"Name" target:self set:@selector(setGlyphName:) get:@selector(getGlyphName) detail:Nil cell:PSEditTextCell edit:Nil];

	return specifier;
}

- (void)updateToggle {

	prefs = [[HBPreferences alloc] initWithIdentifier:@"com.azzou.coeusprefs"];
	NSMutableArray *toggleList = [[prefs objectForKey:@"toggleList"] mutableCopy];

	[self.view endEditing:YES];

	[toggleList replaceObjectAtIndex:[[self.toggle objectForKey:@"index"] integerValue] withObject:self.toggle];
	[prefs setObject:toggleList forKey:@"toggleList"];
	[self.specifier setName:[self.toggle objectForKey:@"name"]];

	[self.navigationController popViewControllerAnimated:YES];
}

- (void)setActivatorAction {

	LAEventSettingsController *vc = [[LAEventSettingsController alloc] initWithModes:[NSArray arrayWithObjects:@"springboard", @"lockscreen", @"application", nil] eventName:[self.toggle objectForKey:@"eventIdentifier"]];
	[self.navigationController pushViewController:vc animated:YES];
}

- (void)setName:(NSString *)name {

	[self.toggle setObject:name forKey:@"name"];
}

- (NSString *)getName {

	return [self.toggle objectForKey:@"name"];
}

- (void)setGlyphName:(NSString *)glyphName {

	[self.toggle setObject:glyphName forKey:@"glyphName"];
}

- (NSString *)getGlyphName {

	return [self.toggle objectForKey:@"glyphName"];
}

- (void)setSFSymbols:(NSNumber *)isSFSymbols {

	if ([isSFSymbols boolValue]) {
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

	[self.toggle setObject:isSFSymbols forKey:@"isSFSymbols"];
}

- (NSNumber *)isSFSymbols {

	return [self.toggle objectForKey:@"isSFSymbols"];
}

- (void)setSFSymbolsSize:(NSNumber *)sfSymbolsSize {

	[self.toggle setObject:sfSymbolsSize forKey:@"sfSymbolsSize"];
}

- (NSString *)getSFSymbolsSize {

	return [self.toggle objectForKey:@"sfSymbolsSize"];
}

- (void)setSFSymbolsWeight:(NSNumber *)sfSymbolsWeight {

	[self.toggle setObject:sfSymbolsWeight forKey:@"sfSymbolsWeight"];
}

- (NSNumber *)getSFSymbolsWeight {

	return [self.toggle objectForKey:@"sfSymbolsWeight"];
}

- (void)setSFSymbolsScale:(NSNumber *)sfSymbolsScale {

	[self.toggle setObject:sfSymbolsScale forKey:@"sfSymbolsScale"];
}

- (NSNumber *)getSFSymbolsScale {

	return [self.toggle objectForKey:@"sfSymbolsScale"];
}


- (BOOL)shouldReloadSpecifiersOnResume {

	return false;
}

@end