#import "PlatoLAEvent.h"

@implementation PlatoLAEvent

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
        return @"Plato";
}

- (NSString *)localizedTitleForEventName:(NSString *)eventName {
        return self.eventIdentifier;
}

- (NSString *)localizedDescriptionForEventName:(NSString *)eventName {
        return self.eventIdentifier;
}

@end