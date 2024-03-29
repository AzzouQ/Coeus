#import <ControlCenterUIKit/CCUIContentModuleContentViewController.h>

#import "CoeusPreferences.h"
#import "CoeusUILabeledRoundButtonViewController.h"

@interface CoeusUIModuleContentViewController : UIViewController <CCUIContentModuleContentViewController>

@property (nonatomic, readonly) CGFloat preferredExpandedContentHeight;
@property (nonatomic, readonly) CGFloat preferredExpandedContentWidth;
@property (nonatomic, readonly) BOOL providesOwnPlatter;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL isExpanded;

@property (nonatomic, assign) NSInteger toggleCount;

@property (nonatomic, assign) CGSize toggleSizeWithoutLabels;
@property (nonatomic, assign) CGSize toggleSizeWithLabels;
@property (nonatomic, assign) BOOL isPaging;
@property (nonatomic, assign) BOOL isLabels;
@property (nonatomic, assign) CGSize toggleSize;
@property (nonatomic, assign) BOOL isScrollVertical;
@property (nonatomic, assign) NSInteger column;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger togglePage;
@property (nonatomic, assign) CGFloat spaceWidth;
@property (nonatomic, assign) CGFloat spaceHeight;
@property (nonatomic, assign) NSInteger scrollTo;

- (void)createPreferences;
- (void)createScrollView;
- (void)createToggles;

- (void)setExpandedContentSize;

- (void)prepareLayout;

- (void)setLayout;
- (void)setScrollView;
- (CGSize)getScrollViewContentSize;

@end