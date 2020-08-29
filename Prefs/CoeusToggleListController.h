#import "CoeusRootListController.h"
#import "CoeusToggleController.h"

@interface PSEditableListController : PSListController
@end

@interface CoeusToggleListController : PSEditableListController

- (void)addToggle;
- (PSSpecifier *)createSpec:(NSString *)name index:(NSNumber *)index;
- (void)saveToggle:(PSSpecifier *)spec;

@end