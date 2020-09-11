#import <libactivator/libactivator.h>

#import "CoeusPreferences.h"

@interface CoeusLAEvent : NSObject <LAEventDataSource>

@property (nonatomic, assign) NSDictionary *toggleDict;

- (id)initWithToggle:(NSDictionary *)toggleDict;

@end