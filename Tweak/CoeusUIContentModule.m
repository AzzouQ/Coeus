#import "CoeusUIContentModule.h"

@implementation CoeusUIContentModule

- (instancetype)init {

	if (!(self = [super init])) {
		return self;
	}
	
	prefs = [[HBPreferences alloc] initWithIdentifier:@"com.azzou.coeusprefs"];

	_contentViewController = [[CoeusUIModuleContentViewController alloc] init];

	return self;
}

- (CCUILayoutSize)moduleSizeForOrientation:(int)orientation {

	[prefs registerUnsignedInteger:&widthCollapsed default:4 forKey:@"widthCollapsed"];
	[prefs registerUnsignedInteger:&heightCollapsed default:1 forKey:@"heightCollapsed"];

	return (CCUILayoutSize){ widthCollapsed, heightCollapsed};
}


@end