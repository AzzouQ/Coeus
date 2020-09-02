#import <libactivator/libactivator.h>

#import "CoeusRootListController.h"

@interface CoeusToggleController : HBListController

@property (nonatomic, assign) PSSpecifier *toggleSpecifier;

- (id)initWithSpecifier:(PSSpecifier *)specifier;

@end