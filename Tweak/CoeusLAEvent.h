#import <libactivator/libactivator.h>

@interface CoeusLAEvent : NSObject <LAEventDataSource>

@property (nonatomic, assign) NSDictionary *toggle;

- (id)initWithToggle:(NSDictionary *)toggle;

@end