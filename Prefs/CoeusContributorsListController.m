#import "CoeusContributorsListController.h"

@implementation CoeusContributorsListController

- (instancetype)init {

	self = [super init];

	if (self) {
		CoeusAppearanceSettings* appearanceSettings = [[CoeusAppearanceSettings alloc] init];
		self.hb_appearanceSettings = appearanceSettings;
	}

	return self;
}

- (id)specifiers {

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
}

- (void)setSpecifier:(PSSpecifier *)specifier {

	[self loadFromSpecifier:specifier];
	[super setSpecifier:specifier];
}

- (void)loadFromSpecifier:(PSSpecifier *)specifier {

	NSString *sub = [specifier propertyForKey:@"CoeusSub"];
	NSString *title = [specifier name];

	_specifiers = [[self loadSpecifiersFromPlistName:sub target:self] retain];

	[self setTitle:title];
	[self.navigationItem setTitle:title];
}

- (BOOL)shouldReloadSpecifiersOnResume {

	return false;
}

@end