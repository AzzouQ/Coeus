#import <ControlCenterUIKit/CCUIContentModuleContentViewController.h>

#import "CoeusUILabeledRoundButtonViewController.h"

@interface CoeusUIModuleContentViewController : UIViewController <CCUIContentModuleContentViewController>

@property (nonatomic, readonly) CGFloat preferredExpandedContentHeight;
@property (nonatomic, readonly) CGFloat preferredExpandedContentWidth;
@property (nonatomic, readonly) BOOL providesOwnPlatter;

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, assign) CGSize toggleSize;
@property (nonatomic, assign) BOOL isExpanded;

@property (nonatomic, assign) NSInteger togglePage;

@property (nonatomic, assign) CGFloat spaceWidth;
@property (nonatomic, assign) CGFloat spaceHeight;

@property (nonatomic, assign) NSInteger toggleExpanded;
@property (nonatomic, assign) NSInteger pageExpanded;

@end