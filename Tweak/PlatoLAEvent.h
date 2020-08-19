#import <libactivator/libactivator.h>

@interface PlatoLAEvent : NSObject <LAEventDataSource>

@property (nonatomic, assign) NSString *eventIdentifier;

- (id)initWithEventIdentifier:(NSString *)eventIdentifier;

@end
