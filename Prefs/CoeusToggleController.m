#import "CoeusToggleController.h"

@implementation CoeusToggleController

- (instancetype)initWithSpecifier:(PSSpecifier *)specifier toggleIndex:(NSInteger)toggleIndex {

	if (!(self = [super init])) {
		return self;
	}

	prefs = [[HBPreferences alloc] initWithIdentifier:@"com.azzou.coeusprefs"];

	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveToggle)];
	self.specifier = specifier;
	self.toggleIndex = toggleIndex;
	self.toggleDict = [[prefs objectForKey:@"toggleList"][self.toggleIndex] mutableCopy];

	[prefs setObject:[self.toggleDict objectForKey:@"highlightColor"] forKey:@"highlightColor"];

	return self;
}

- (id)specifiers {

	if (_specifiers == nil) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Toggle" target:self];
	}

	[self setTitle:[self.specifier name]];
	[self.navigationItem setTitle:[self.specifier name]];

	return _specifiers;
}

- (void)viewDidLoad {

	[super viewDidLoad];

	[self loadSpecifiersFromToggle];
	[self reload];
}

- (void)loadSpecifiersFromToggle {

	if (@available(iOS 13.0, *)) {
		self.sfSymbolsSpecifiers = [[NSMutableArray alloc] initWithObjects:
		[self createSFSymbolsSizeSpecifier],
		[self createSFSymbolsWeightSpecifier],
		[self createSFSymbolsScaleSpecifier],
		[self createSFSymbolsNameSpecifier], nil];
		[self.sfSymbolsSpecifiers addObjectsFromArray:[self loadSpecifiersFromPlistName:@"SFSymbols" target:self]];
	}

	[self insertSpecifier:[self createNameSpecifier] atEndOfGroup:0];
	[self insertSpecifier:[self createGlyphListSpecifier] atEndOfGroup:2];
	if (@available(iOS 13.0, *)) {
		[self insertSpecifier:[self createSFSymbolsSpecifier] atEndOfGroup:2];
		if ([[self.toggleDict objectForKey:@"isSFSymbols"] boolValue]) {
			[[self specifierForID:@"glyphList"] setProperty:@NO forKey:@"enabled"];
			[self insertContiguousSpecifiers:self.sfSymbolsSpecifiers atEndOfGroup:2];
		}
	}
	NSArray *colorCell = [[NSArray alloc] initWithArray:[self loadSpecifiersFromPlistName:@"ColorCell" target:self]];
	[self insertSpecifier:[self createHighlightColorSpecifier] atEndOfGroup:3];
	[self insertSpecifier:([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/Frameworks/Alderis.framework"] ? [colorCell firstObject] : [colorCell lastObject]) atEndOfGroup:3];
	[[self specifierForID:@"highlightColor"] setProperty:@([[self.toggleDict objectForKey:@"isHighlightColor"] boolValue]) forKey:@"enabled"];
	[self insertSpecifier:[self createConfirmationSpecifier] atEndOfGroup:4];

	[self setTitle:[self.specifier name]];
	[self.navigationItem setTitle:[self.specifier name]];
}

- (PSSpecifier *)createNameSpecifier {

	PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"" target:self set:@selector(setName:) get:@selector(getName) detail:Nil cell:PSEditTextCell edit:Nil];
	[specifier setIdentifier:@"name"];

	[specifier setIdentifier:@"name"];

	return specifier;
}

- (PSSpecifier *)createGlyphListSpecifier {

	NSArray *glyphList = [self getGlyphList];
	PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"Choose from preset" target:self set:@selector(setGlyphName:) get:@selector(getGlyphName) detail:NSClassFromString(@"PSListItemsController") cell:PSLinkListCell edit:Nil];
	[specifier setIdentifier:@"glyphList"];
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
	[specifier setIdentifier:@"isSFSymbols"];

	[specifier setIdentifier:@"isSFSymbols"];

	return specifier;
}

- (PSSpecifier *)createSFSymbolsSizeSpecifier {

	PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"Size" target:self set:@selector(setSFSymbolsSize:) get:@selector(getSFSymbolsSize) detail:Nil cell:PSSliderCell edit:Nil];
	[specifier setIdentifier:@"sfSymbolsSize"];

	[specifier setIdentifier:@"sfSymbolsSize"];

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
	[specifier setIdentifier:@"sfSymbolsWeight"];

	[specifier setIdentifier:@"sfSymbolsWeight"];

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
	[specifier setIdentifier:@"sfSymbolsScale"];

	[specifier setIdentifier:@"sfSymbolsScale"];

	specifier.values = sfSymbolsScaleValueList;
	specifier.titleDictionary = [NSDictionary dictionaryWithObjects:sfSymbolsScaleNameList forKeys:specifier.values];
	specifier.shortTitleDictionary = [NSDictionary dictionaryWithObjects:sfSymbolsScaleNameList forKeys:specifier.values];

	return specifier;
}

- (PSSpecifier *)createSFSymbolsNameSpecifier {

	PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"Name" target:self set:@selector(setGlyphName:) get:@selector(getGlyphName) detail:Nil cell:PSEditTextCell edit:Nil];
	[specifier setIdentifier:@"sfSymbolsName"];

	[specifier setIdentifier:@"sfSymbolsName"];

	return specifier;
}

- (PSSpecifier *)createHighlightColorSpecifier {

	PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"Custom Highlight" target:self set:@selector(setHighlightColor:) get:@selector(isHighlightColor) detail:Nil cell:PSSwitchCell edit:Nil];
	[specifier setIdentifier:@"isHighlightColor"];

	return specifier;
}

- (PSSpecifier *)createConfirmationSpecifier {

	PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:@"Ask for Confirmation" target:self set:@selector(setConfirmation:) get:@selector(isConfirmation) detail:Nil cell:PSSwitchCell edit:Nil];
	[specifier setIdentifier:@"isConfirmation"];

	return specifier;
}

- (void)updateToggle {

	prefs = [[HBPreferences alloc] initWithIdentifier:@"com.azzou.coeusprefs"];
	NSMutableArray *toggleList = [[prefs objectForKey:@"toggleList"] mutableCopy];

	[self.toggleDict setObject:[prefs objectForKey:@"highlightColor"] forKey:@"highlightColor"];

	[toggleList replaceObjectAtIndex:self.toggleIndex withObject:self.toggleDict];
	[prefs setObject:toggleList forKey:@"toggleList"];
}

- (void)saveToggle {

	[self.view endEditing:YES];

	[self updateToggle];
	[prefs removeObjectForKey:@"highlightColor"];

	[self.navigationController popViewControllerAnimated:YES];
}

- (void)setActivatorAction {

	LAEventSettingsController *vc = [[LAEventSettingsController alloc] initWithModes:[NSArray arrayWithObjects:@"springboard", @"lockscreen", @"application", nil] eventName:[self.toggleDict objectForKey:@"eventIdentifier"]];
	[self.navigationController pushViewController:vc animated:YES];
}

- (void)setName:(NSString *)name {

	[self.toggleDict setObject:name forKey:@"name"];
	[self.specifier setName:[self.toggleDict objectForKey:@"name"]];
	[self updateToggle];
}

- (NSString *)getName {
	return [self.toggleDict objectForKey:@"name"];
}

- (void)setGlyphName:(NSString *)glyphName {

	[self.toggleDict setObject:glyphName forKey:@"glyphName"];
	[self updateToggle];
}

- (NSString *)getGlyphName {
	return [self.toggleDict objectForKey:@"glyphName"];
}

- (void)setSFSymbols:(NSNumber *)isSFSymbols {

	if ([isSFSymbols boolValue]) {
		[[self specifierForID:@"glyphList"] setProperty:@NO forKey:@"enabled"];
		[self insertContiguousSpecifiers:self.sfSymbolsSpecifiers atEndOfGroup:2 animated:YES];
	} else {
		[[self specifierForID:@"glyphList"] setProperty:@YES forKey:@"enabled"];
		[self removeContiguousSpecifiers:self.sfSymbolsSpecifiers animated:YES];
	}

	[self.toggleDict setObject:isSFSymbols forKey:@"isSFSymbols"];
	[self reloadSpecifierID:@"glyphList" animated:YES];
	[self updateToggle];
}

- (NSNumber *)isSFSymbols {
	return [self.toggleDict objectForKey:@"isSFSymbols"];
}

- (void)setSFSymbolsSize:(NSNumber *)sfSymbolsSize {

	[self.toggleDict setObject:sfSymbolsSize forKey:@"sfSymbolsSize"];
	[self updateToggle];
}

- (NSString *)getSFSymbolsSize {
	return [self.toggleDict objectForKey:@"sfSymbolsSize"];
}

- (void)setSFSymbolsWeight:(NSNumber *)sfSymbolsWeight {

	[self.toggleDict setObject:sfSymbolsWeight forKey:@"sfSymbolsWeight"];
	[self updateToggle];
}

- (NSNumber *)getSFSymbolsWeight {
	return [self.toggleDict objectForKey:@"sfSymbolsWeight"];
}

- (void)setSFSymbolsScale:(NSNumber *)sfSymbolsScale {

	[self.toggleDict setObject:sfSymbolsScale forKey:@"sfSymbolsScale"];
	[self updateToggle];
}

- (NSNumber *)getSFSymbolsScale {
	return [self.toggleDict objectForKey:@"sfSymbolsScale"];
}

- (void)setHighlightColor:(NSNumber *)isHighlightColor {

	[[self specifierForID:@"highlightColor"] setProperty:@([isHighlightColor boolValue]) forKey:@"enabled"];

	[self.toggleDict setObject:isHighlightColor forKey:@"isHighlightColor"];
	[self reloadSpecifierID:@"highlightColor" animated:YES];
	[self updateToggle];
}

- (NSNumber *)isHighlightColor {
	return [self.toggleDict objectForKey:@"isHighlightColor"];
}

- (void)setConfirmation:(NSNumber *)isConfirmation {

	[self.toggleDict setObject:isConfirmation forKey:@"isConfirmation"];
	[self updateToggle];
}

- (NSNumber *)isConfirmation {
	return [self.toggleDict objectForKey:@"isConfirmation"];
}

- (BOOL)shouldReloadSpecifiersOnResume {
	return NO;
}

@end