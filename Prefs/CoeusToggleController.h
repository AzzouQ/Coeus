#import <libactivator/libactivator.h>

#import "CoeusRootListController.h"

@interface CoeusToggleController : HBListController

@property (nonatomic, assign) NSInteger				toggleIndex;
@property (nonatomic, strong) NSMutableDictionary	*toggleDict;
@property (nonatomic, strong) NSMutableArray		*sfSymbolsSpecifiers;

- (instancetype)initWithSpecifier:(PSSpecifier *)specifier toggleIndex:(NSInteger)toggleIndex;

- (void)loadSpecifiersFromToggle;

- (PSSpecifier *)createNameSpecifier;
- (PSSpecifier *)createGlyphListSpecifier;
- (PSSpecifier *)createSFSymbolsSpecifier;
- (PSSpecifier *)createSFSymbolsWeightSpecifier;
- (PSSpecifier *)createSFSymbolsSizeSpecifier;
- (PSSpecifier *)createSFSymbolsScaleSpecifier;
- (PSSpecifier *)createSFSymbolsNameSpecifier;

- (NSArray *)getGlyphList;

- (void)updateToggle;
- (void)setActivatorAction;

- (void)setName:(NSString *)name;
- (NSString *)getName;
- (void)setGlyphName:(NSString *)glyphName;
- (NSString *)getGlyphName;
- (void)setSFSymbols:(NSNumber *)isSFSymbols;
- (NSNumber *)isSFSymbols;
- (void)setSFSymbolsSize:(NSNumber *)sfSymbolsSize;
- (NSString *)getSFSymbolsSize;
- (void)setSFSymbolsWeight:(NSNumber *)sfSymbolsWeight;
- (NSNumber *)getSFSymbolsWeight;
- (void)setSFSymbolsScale:(NSNumber *)sfSymbolsScale;
- (NSNumber *)getSFSymbolsScale;

@end