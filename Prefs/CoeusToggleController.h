#import <libactivator/libactivator.h>

#import "CoeusRootListController.h"

@interface CoeusToggleController : HBListController

@property (nonatomic, assign) NSInteger             toggleIndex;
@property (nonatomic, assign) NSMutableDictionary   *toggleDict;

- (instancetype)initWithSpecifier:(PSSpecifier *)specifier toggleIndex:(NSInteger)toggleIndex;

@end