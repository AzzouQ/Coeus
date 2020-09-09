#import "CoeusUIContentModule.h"

@implementation CoeusUIContentModule

- (instancetype)init {

	if (!(self = [super init])) {
		return self;
	}
	
	prefs = [[HBPreferences alloc] initWithIdentifier:@"com.azzou.coeusprefs"];
	[self compatibilityCheck];

	_contentViewController = [[CoeusUIModuleContentViewController alloc] init];

	return self;
}

- (CCUILayoutSize)moduleSizeForOrientation:(int)orientation {

	[prefs registerUnsignedInteger:&widthCollapsed default:4 forKey:@"widthCollapsed"];
	[prefs registerUnsignedInteger:&heightCollapsed default:1 forKey:@"heightCollapsed"];

	return (CCUILayoutSize){ widthCollapsed, heightCollapsed};
}

- (void)compatibilityCheck {

	NSMutableArray *toggleList = [[prefs objectForKey:@"toggleList"] mutableCopy];

	for (NSInteger index = 0; index < [toggleList count]; index++) {
		NSMutableDictionary *toggleDict = [toggleList[index] mutableCopy];

		if (!([toggleDict objectForKey:@"isHighlightColor"])) {
			[toggleDict setObject:[NSNumber numberWithBool:NO] forKey:@"isHighlightColor"];
		}

		if (!([toggleDict objectForKey:@"highlightColor"])) {
			[toggleDict setObject:[UIColor PF_hexFromColor:[UIColor systemBlueColor]] forKey:@"highlightColor"];
		}

		if (!([toggleDict objectForKey:@"isConfirmation"])) {
			[toggleDict setObject:[NSNumber numberWithBool:NO] forKey:@"isConfirmation"];
		}

		[toggleList replaceObjectAtIndex:index withObject:toggleDict];
	}

	[prefs setObject:toggleList forKey:@"toggleList"];
}

@end