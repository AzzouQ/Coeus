#import "CoeusLAEvent.h"

@implementation CoeusLAEvent

- (instancetype)initWithToggle:(NSDictionary *)toggle {

	if ((self = [super init])) {

		self.toggle = toggle;

		[LASharedActivator registerEventDataSource:self forEventName:[self.toggle objectForKey:@"eventIdentifier"]];
	}

	return self;
}

- (void)dealloc {
	[LASharedActivator unregisterEventDataSourceWithEventName:[self.toggle objectForKey:@"eventIdentifier"]];
	[super dealloc];
}

- (NSString *)localizedGroupForEventName:(NSString *)eventName {
	return @"Coeus";
}

- (NSString *)localizedTitleForEventName:(NSString *)eventName {
	return [self.toggle objectForKey:@"name"];
}

- (NSString *)localizedDescriptionForEventName:(NSString *)eventName {
	return @"Tap on toggle";
}

@end