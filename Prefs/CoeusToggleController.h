#import <libactivator/libactivator.h>

#import "CoeusRootListController.h"

@interface CoeusToggleController : HBListController

typedef NS_ENUM(NSInteger, UIImageSymbolWeight) {
    UIImageSymbolWeightUnspecified = 0,
    UIImageSymbolWeightUltraLight = 1,
    UIImageSymbolWeightThin,
    UIImageSymbolWeightLight,
    UIImageSymbolWeightRegular,
    UIImageSymbolWeightMedium,
    UIImageSymbolWeightSemibold,
    UIImageSymbolWeightBold,
    UIImageSymbolWeightHeavy,
    UIImageSymbolWeightBlack
};

typedef NS_ENUM(NSInteger, UIImageSymbolScale) {
    UIImageSymbolScaleDefault = -1,      // use the system default size
    UIImageSymbolScaleUnspecified = 0,   // allow the system to pick a size based on the context
    UIImageSymbolScaleSmall = 1,
    UIImageSymbolScaleMedium,
    UIImageSymbolScaleLarge,
};

@property (nonatomic, assign) NSInteger             toggleIndex;
@property (nonatomic, assign) NSMutableDictionary   *toggleDict;

- (instancetype)initWithSpecifier:(PSSpecifier *)specifier toggleIndex:(NSInteger)toggleIndex;

- (void)loadSpecifiersFromToggle;

- (PSSpecifier *)createToggleNameSpecifier;
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