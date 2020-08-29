#import "CoeusLAEvent.h"

@implementation CoeusLAEvent

- (instancetype)initWithToggle:(NSArray *)toggle {
	if ((self = [super init])) {
		self.eventIdentifier = [NSString stringWithFormat:@"com.azzou.coeus.toggle%@", [toggle objectAtIndex:1]];
		self.titleForEventName = [NSString stringWithFormat:@"%@", [toggle objectAtIndex:0]];
		[LASharedActivator registerEventDataSource:self forEventName:self.eventIdentifier];
	}
	return self;
}

- (void)dealloc {
	[LASharedActivator unregisterEventDataSourceWithEventName:self.eventIdentifier];
	[super dealloc];
}

- (NSString *)localizedGroupForEventName:(NSString *)eventName {
	return @"Coeus";
}

- (NSString *)localizedTitleForEventName:(NSString *)eventName {
	return self.titleForEventName;
}

- (NSString *)localizedDescriptionForEventName:(NSString *)eventName {
	return @"Tap on toggle";
}

@end