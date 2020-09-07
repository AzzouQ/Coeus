#import <libactivator/libactivator.h>

@interface CoeusLAEvent : NSObject <LAEventDataSource>

@property (nonatomic, assign) NSDictionary *toggleDict;

- (id)initWithToggle:(NSDictionary *)toggleDict;

@end