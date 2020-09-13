#import "CoeusLAEvent.h"

@implementation CoeusLAEvent

- (instancetype)initWithToggle:(NSDictionary *)toggleDict {

	if (!(self = [super init])) {
		return self;
	}
	
	self.toggleDict = toggleDict;
	[LASharedActivator registerEventDataSource:self forEventName:[self.toggleDict objectForKey:@"eventIdentifier"]];

	return self;
}

- (void)dealloc {

	prefs = [[HBPreferences alloc] initWithIdentifier:@"com.azzou.coeusprefs"];

	[LASharedActivator unregisterEventDataSourceWithEventName:[self.toggleDict objectForKey:@"eventIdentifier"]];
}

- (NSString *)localizedGroupForEventName:(NSString *)eventName {
	return @"Coeus";
}

- (NSString *)localizedTitleForEventName:(NSString *)eventName {
	return [self.toggleDict objectForKey:@"name"];
}

- (NSString *)localizedDescriptionForEventName:(NSString *)eventName {
	return @"Tap on toggle";
}

@end