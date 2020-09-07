#import "CoeusToggleController.h"

@implementation CoeusToggleController

- (instancetype)initWithSpecifier:(PSSpecifier *)specifier toggleIndex:(NSInteger)toggleIndex {

	prefs = [[HBPreferences alloc] initWithIdentifier:@"com.azzou.coeusprefs"];

	if (!(self = [super init])) {
		return self;
	}

	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(updateToggle)];
	self.specifier = specifier;
	self.toggleIndex = toggleIndex;
	self.toggleDict = [[prefs objectForKey:@"toggleList"][self.toggleIndex] mutableCopy];

	return self;
}

- (id)specifiers {

	if (_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Toggle" target:self] retain];
	}

	[self loadSpecifiersFromToggle];

	[self setTitle:[self.specifier name]];
	[self.navigationItem setTitle:[self.specifier name]];

	return _specifiers;
}

- (void)loadSpecifiersFromToggle {

	[self insertSpecifier:[self createToggleNameSpecifier] atIndex:1];
	[self insertSpecifier:[self createGlyphListSpecifier] atIndex:3];
	if (@available(iOS 13.0, *)) {
		[self insertSpecifier:[self createSFSymbolsSpecifier] atIndex:4];
		if ([[self.toggleDict objectForKey:@"isSFSymbols"] boolValue]) {
			[[self specifierAtIndex:3] setProperty:@NO forKey:@"enabled"];
			[self insertSpecifier:[self createSFSymbolsSizeSpecifier] atIndex:5];
			[self insertSpecifier:[self createSFSymbolsWeightSpecifier] atIndex:6];
			[self insertSpecifier:[self createSFSymbolsScaleSpecifier] atIndex:7];
			[self insertSpecifier:[self createSFSymbolsNameSpecifier] atIndex:8];
			[self insertContiguousSpecifiers:[[self loadSpecifiersFromPlistName:@"Documentation" target:self] retain] atIndex:9];
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

	[specifier setProperty:@"Glyph are located in '/Library/ControlCenter/Bundles/Coeus.bundle/Glyphs/'" forKey:@"staticTextMessage"];

	specifier.values = glyphList;
	specifier.titleDictionary = [NSDictionary dictionaryWithObjects:glyphList forKeys:specifier.values];
	specifier.shortTitleDictionary = [NSDictionary dictionaryWithObjects:glyphList forKeys:specifier.values];

	return specifier;
}

- (NSArray *)getGlyphList {

	NSArray *bundleDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/Library/ControlCenter/Bundles/Coeus.bundle/Glyphs/" error:NULL];

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

- (PSSpecifier *)createSFSymbolsSizeSpecifier {

	PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"Size" target:self set:@selector(setSFSymbolsSize:) get:@selector(getSFSymbolsSize) detail:Nil cell:PSSliderCell edit:Nil];

	[specifier setProperty:[UIImage imageNamed:@"Size" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil] forKey:@"leftImage"];
	[specifier setProperty:[NSNumber numberWithFloat:20.0] forKey:@"default"];
	[specifier setProperty:[NSNumber numberWithFloat:15.0] forKey:@"min"];
	[specifier setProperty:[NSNumber numberWithFloat:25.0] forKey:@"max"];
	[specifier setProperty:@YES forKey:@"showValue"];

	return specifier;
}

- (PSSpecifier *)createSFSymbolsWeightSpecifier {

	NSArray *sfSymbolsWeightValueList = nil;

	if (@available(iOS 13, *)) {
		sfSymbolsWeightValueList = [[NSArray alloc] initWithObjects:
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
	}

	NSArray *sfSymbolsWeightNameList = [[NSArray alloc] initWithObjects:
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

- (PSSpecifier *)createSFSymbolsScaleSpecifier {

	NSArray *sfSymbolsScaleValueList = nil;

	if (@available(iOS 13, *)) {
		sfSymbolsScaleValueList = [[NSArray alloc] initWithObjects:
		[NSNumber numberWithInteger:UIImageSymbolScaleSmall],
		[NSNumber numberWithInteger:UIImageSymbolScaleMedium],
		[NSNumber numberWithInteger:UIImageSymbolScaleLarge],
		nil];
	}

	NSArray *sfSymbolsScaleNameList = [[NSArray alloc] initWithObjects:
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

	NSMutableArray *toggleList = [[prefs objectForKey:@"toggleList"] mutableCopy];

	[self.view endEditing:YES];

	[toggleList replaceObjectAtIndex:self.toggleIndex withObject:self.toggleDict];
	[prefs setObject:toggleList forKey:@"toggleList"];
	[self.specifier setName:[self.toggleDict objectForKey:@"name"]];

	[self.navigationController popViewControllerAnimated:YES];
}

- (void)setActivatorAction {

	LAEventSettingsController *vc = [[LAEventSettingsController alloc] initWithModes:[NSArray arrayWithObjects:@"springboard", @"lockscreen", @"application", nil] eventName:[self.toggleDict objectForKey:@"eventIdentifier"]];
	[self.navigationController pushViewController:vc animated:YES];
}

- (void)setName:(NSString *)name {

	[self.toggleDict setObject:name forKey:@"name"];
}

- (NSString *)getName {

	return [self.toggleDict objectForKey:@"name"];
}

- (void)setGlyphName:(NSString *)glyphName {

	[self.toggleDict setObject:glyphName forKey:@"glyphName"];
}

- (NSString *)getGlyphName {

	return [self.toggleDict objectForKey:@"glyphName"];
}

- (void)setSFSymbols:(NSNumber *)isSFSymbols {

	if ([isSFSymbols boolValue]) {
		[[self specifierAtIndex:3] setProperty:@NO forKey:@"enabled"];
		[self insertSpecifier:[self createSFSymbolsSizeSpecifier] atIndex:5 animated:YES];
		[self insertSpecifier:[self createSFSymbolsWeightSpecifier] atIndex:6 animated:YES];
		[self insertSpecifier:[self createSFSymbolsScaleSpecifier] atIndex:7 animated:YES];
		[self insertSpecifier:[self createSFSymbolsNameSpecifier] atIndex:8 animated:YES];
		[self insertContiguousSpecifiers:[[self loadSpecifiersFromPlistName:@"SFSymbols" target:self] retain] atIndex:9 animated:YES];

		[self setTitle:[self.specifier name]];
		[self.navigationItem setTitle:[self.specifier name]];

	} else {
		[[self specifierAtIndex:3] setProperty:@YES forKey:@"enabled"];
		[self removeSpecifierAtIndex:5 animated:YES];
		[self removeSpecifierAtIndex:5 animated:YES];
		[self removeSpecifierAtIndex:5 animated:YES];
		[self removeSpecifierAtIndex:5 animated:YES];
		[self removeSpecifierAtIndex:5 animated:YES];
	}

	[self.toggleDict setObject:isSFSymbols forKey:@"isSFSymbols"];
	[self reloadSpecifierAtIndex:3];
}

- (NSNumber *)isSFSymbols {

	return [self.toggleDict objectForKey:@"isSFSymbols"];
}

- (void)setSFSymbolsSize:(NSNumber *)sfSymbolsSize {

	[self.toggleDict setObject:sfSymbolsSize forKey:@"sfSymbolsSize"];
}

- (NSString *)getSFSymbolsSize {

	return [self.toggleDict objectForKey:@"sfSymbolsSize"];
}

- (void)setSFSymbolsWeight:(NSNumber *)sfSymbolsWeight {

	[self.toggleDict setObject:sfSymbolsWeight forKey:@"sfSymbolsWeight"];
}

- (NSNumber *)getSFSymbolsWeight {

	return [self.toggleDict objectForKey:@"sfSymbolsWeight"];
}

- (void)setSFSymbolsScale:(NSNumber *)sfSymbolsScale {

	[self.toggleDict setObject:sfSymbolsScale forKey:@"sfSymbolsScale"];
}

- (NSNumber *)getSFSymbolsScale {

	return [self.toggleDict objectForKey:@"sfSymbolsScale"];
}

- (BOOL)shouldReloadSpecifiersOnResume {

	return NO;
}

@end