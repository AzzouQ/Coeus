#import <libactivator/libactivator.h>

@interface CoeusLAEvent : NSObject <LAEventDataSource>

@property (nonatomic, assign) NSString *eventIdentifier;
@property (nonatomic, assign) NSString *titleForEventName;

- (id)initWithToggle:(NSArray *)toggle;

@end