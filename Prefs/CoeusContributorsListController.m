#import "CoeusContributorsListController.h"

@implementation CoeusContributorsListController

- (instancetype)init {

	if (!(self = [super init])) {
		return self;
	}

	return self;
}

- (id)specifiers {

	if (_specifiers == nil) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Contributors" target:self];
	}

	return _specifiers;
}

- (BOOL)shouldReloadSpecifiersOnResume {
	return NO;
}

@end