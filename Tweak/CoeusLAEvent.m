#import "CoeusLAEvent.h"

@implementation CoeusLAEvent

- (instancetype)initWithEventIdentifier:(NSString *)eventIdentifier {
	if ((self = [super init])) {
		self.eventIdentifier = eventIdentifier;
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
	return [NSString stringWithFormat:@"Toggle %@", [[self.eventIdentifier componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""]];
}

- (NSString *)localizedDescriptionForEventName:(NSString *)eventName {
	return @"Tap on toggle";
}

@end