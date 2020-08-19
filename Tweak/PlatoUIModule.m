#import "PlatoUIModule.h"

@implementation PlatoUIModule

- (instancetype)init {

	if ((self = [super init])) {

		CoeusReloadPrefs();

		_contentViewController = [[PlatoUIModuleContentViewController alloc] init];
	}

	return self;
}

- (CCUILayoutSize)moduleSizeForOrientation:(int)orientation {
  return (CCUILayoutSize){ moduleWidth, moduleHeight};
}


@end
