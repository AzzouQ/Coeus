#import "CoeusRootListController.h"
#import "CoeusToggleController.h"

@interface PSEditableListController : PSListController
@end

@interface CoeusToggleListController : PSEditableListController

- (void)loadSpecifierFromToggleList;
- (PSSpecifier *)addToggleSpecifier:(NSString *)name;

- (void)addToggleAlert;
- (void)removeToggle:(PSSpecifier *)specifier;
- (void)saveToggle:(PSSpecifier *)specifier;

- (NSMutableDictionary *)initToggleWithSpecifier:(PSSpecifier *)specifier;
- (NSString *)getEventIdentifier;

- (void)setToggleController:(PSSpecifier *)specifier;

@end