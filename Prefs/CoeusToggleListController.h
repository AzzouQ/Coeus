#import "CoeusRootListController.h"
#import "CoeusToggleController.h"

@interface PSEditableListController : PSListController
@end

@interface CoeusToggleListController : PSEditableListController

- (PSSpecifier *)createSpecifier:(NSString *)name index:(NSNumber *)index;
- (void)addToggle;
- (void)saveToggle:(PSSpecifier *)spec;

@end