#import <libactivator/libactivator.h>

@interface CoeusLAEvent : NSObject <LAEventDataSource>

@property (nonatomic, assign) NSString *eventIdentifier;

- (id)initWithEventIdentifier:(NSString *)eventIdentifier;

@end
