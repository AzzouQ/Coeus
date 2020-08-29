#import <libactivator/libactivator.h>

#import "CoeusRootListController.h"

@interface CoeusToggleController : PSListController

@property (nonatomic, assign) PSSpecifier *toggleSpecifier;
@property (nonatomic, retain) NSMutableArray *toggleInfo;

- (id)initWithSpecifier:(PSSpecifier *)specifier;

@end