#import "CoeusModuleListController.h"

@implementation CoeusModuleListController

- (instancetype)init {

	if (!(self = [super init])) {
		return self;
	}

	return self;
}

- (id)specifiers {

	if (_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Module" target:self] retain];
	}

	return _specifiers;
}

- (BOOL)shouldReloadSpecifiersOnResume {

	return NO;
}

@end