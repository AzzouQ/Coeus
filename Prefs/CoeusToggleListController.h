#include <CSColorPicker/CSColorPicker.h>

#import "CoeusRootListController.h"
#import "CoeusToggleController.h"

@interface PSListController ()
- (void)_moveSpecifierAtIndex:(unsigned long long)arg1 toIndex:(unsigned long long)arg2 animated:(bool)arg3;
@end

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

- (NSMutableDictionary *)createToggleWithSpecifier:(PSSpecifier *)specifier;
- (NSString *)getEventIdentifier;

- (void)setToggleController:(PSSpecifier *)specifier;

@end