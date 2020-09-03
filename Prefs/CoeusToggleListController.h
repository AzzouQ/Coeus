#import "CoeusRootListController.h"
#import "CoeusToggleController.h"

@interface PSEditableListController : PSListController
@end

@interface CoeusToggleListController : PSEditableListController

- (PSSpecifier *)createSpecifierFromToggle:(NSString *)name index:(NSNumber *)index glyphName:(NSString *)glyphName isSFSymbols:(NSNumber *)isSFSymbols sfSymbolsSize:(NSNumber *)sfSymbolsSize sfSymbolsWeight:(NSNumber *)sfSymbolsWeight sfSymbolsScale:(NSNumber *)sfSymbolsScale;
- (void)addToggle;
- (void)saveToggle:(PSSpecifier *)spec;

@end