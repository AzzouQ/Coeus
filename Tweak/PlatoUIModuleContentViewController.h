#import <Cephei/HBPreferences.h>
#import <ControlCenterUIKit/CCUIContentModuleContentViewController.h>
#import "SharedHeader.h"

#import "PlatoUILabeledRoundButtonViewController.h"

#define IS_NEW_PAGE(index, togglePerPage) (!(index % togglePerPage))
#define IS_NEW_ROW(index, columnNumber) (!(index % columnNumber))

@interface PlatoUIModuleContentViewController : UIViewController <CCUIContentModuleContentViewController>

@property (nonatomic, readonly) CGFloat preferredExpandedContentHeight;
@property (nonatomic, readonly) CGFloat preferredExpandedContentWidth;
@property (nonatomic, readonly) BOOL providesOwnPlatter;

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, assign) CGSize toggleSize;
@property (nonatomic, assign) BOOL isExpanded;

@property (nonatomic, assign) NSInteger columnCollapsed;
@property (nonatomic, assign) NSInteger rowCollapsed;
@property (nonatomic, assign) NSInteger toggleCollapsed;
@property (nonatomic, assign) NSInteger pageCollapsed;

@end