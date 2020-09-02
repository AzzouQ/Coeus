#import <libactivator/libactivator.h>

#import "CoeusRootListController.h"

@interface CoeusToggleController : PSListController

@property (nonatomic, assign) PSSpecifier *toggleSpecifier;

- (id)initWithSpecifier:(PSSpecifier *)specifier;

@end