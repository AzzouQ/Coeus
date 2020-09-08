#import <libcolorpicker.h>

#import "CoeusRootListController.h"
#import "CoeusToggleController.h"

@interface PSEditableListController : PSListController
- (void)editDoneTapped;
- (BOOL)editable;
@end

@interface CoeusToggleListController : PSEditableListController

- (void)loadSpecifierFromToggleList;
- (PSSpecifier *)createToggleSpecifier:(NSString *)name;

- (void)addToggleAlert;
- (void)removeToggle:(PSSpecifier *)specifier;
- (void)saveToggle:(PSSpecifier *)specifier;

- (NSMutableDictionary *)initToggleWithSpecifier:(PSSpecifier *)specifier;
- (NSString *)getEventIdentifier;

- (void)setToggleController:(PSSpecifier *)specifier;

@end