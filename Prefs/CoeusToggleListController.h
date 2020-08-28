#include "CoeusRootListController.h"

@interface PSEditableListController : PSListController
@end

@interface CoeusToggleListController : PSEditableListController

- (void)addToggle;
- (PSSpecifier *)createSpec:(NSString *)name;
- (void)saveToggle:(PSSpecifier *)spec;

@end