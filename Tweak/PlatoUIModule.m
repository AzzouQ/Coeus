#import "PlatoUIModule.h"

@implementation PlatoUIModule

- (instancetype)init {

	if ((self = [super init])) {

		prefs = [[HBPreferences alloc] initWithIdentifier:@"com.azzou.platoprefs"];

		_contentViewController = [[PlatoUIModuleContentViewController alloc] init];
	}

	return self;
}

- (CCUILayoutSize)moduleSizeForOrientation:(int)orientation {

	NSUInteger moduleWidth = 4;
	NSUInteger moduleHeight = 1;

	[prefs registerUnsignedInteger:&moduleWidth default:4 forKey:@"moduleWidth"];
	[prefs registerUnsignedInteger:&moduleHeight default:1 forKey:@"moduleHeight"];

    return (CCUILayoutSize){ moduleWidth, moduleHeight};
}


@end
