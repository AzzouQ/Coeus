#import "CoeusPreferences.h"
#import "CoeusUIContentModule.h"

@implementation CoeusUIContentModule

- (instancetype)init {

	if ((self = [super init])) {

		prefs = [[HBPreferences alloc] initWithIdentifier:@"com.azzou.coeusprefs"];

		_contentViewController = [[CoeusUIModuleContentViewController alloc] init];
	}

	return self;
}

- (CCUILayoutSize)moduleSizeForOrientation:(int)orientation {

	[prefs registerUnsignedInteger:&moduleWidth default:4 forKey:@"moduleWidth"];
	[prefs registerUnsignedInteger:&moduleHeight default:1 forKey:@"moduleHeight"];

    return (CCUILayoutSize){ moduleWidth, moduleHeight};
}


@end
