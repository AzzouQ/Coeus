#import <libactivator/libactivator.h>

#import "CoeusRootListController.h"

@interface CoeusToggleController : HBListController

@property (nonatomic, assign) NSMutableDictionary *toggle;

- (instancetype)initWithSpecifier:(PSSpecifier *)specifier toggle:(NSMutableDictionary *)toggle;

@end