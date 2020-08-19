#import "PlatoUIModuleContentViewController.h"

static const BOOL isPaging = YES;
static const BOOL isIndicator = NO;
static const int indicatorStyle = 2;
static const int scrollToPage = 0;

static const int toggleTotal = 10;

// NSInteger columnCollapsed = 5;
// NSInteger rowCollapsed = 1;
// NSInteger toggleCollapsed = (columnCollapsed * rowCollapsed);
// static const BOOL isLastPageCollapsed = (toggleTotal % toggleCollapsed);
// static const int pageTotalCollapsed = (toggleTotal / toggleCollapsed) + ((isLastPageCollapsed) ? 1 : 0);
// #define NEW_PAGE_COLLAPSED (!(i % toggleCollapsed))
// #define NEW_ROW_COLLAPSED !(i % columnCollapsed)

static const int columnExpanded = 2;
static const int rowExpanded = 3;
static const int toggleExpanded = (columnExpanded * rowExpanded);
static const BOOL isLastPageExpanded = (toggleTotal % toggleExpanded);
static const int pageTotalExpanded = (toggleTotal / toggleExpanded) + ((isLastPageExpanded) ? 1 : 0);
// #define NEW_PAGE_EXPANDED (!(i % toggleExpanded))
// #define NEW_ROW_EXPANDED !(i % columnExpanded)

@implementation PlatoUIModuleContentViewController

- (instancetype)initWithNibName:(NSString*)name bundle:(NSBundle*)bundle {

	if ((self = [super initWithNibName:name bundle:bundle])) {

		self.view.autoresizesSubviews = YES;

		[self initValues];
		[self initScrollView];
		[self intiToggles];
	}

	return self;
}

- (void)initValues {
	self.columnCollapsed = columnCollapsed;
	self.rowCollapsed = rowCollapsed;
	self.toggleCollapsed = self.columnCollapsed * self.rowCollapsed;
	self.pageCollapsed = (toggleTotal / self.toggleCollapsed) + ((toggleTotal % self.toggleCollapsed) ? 1 : 0);
}

- (void)initScrollView {

	self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];

	[self.scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];

	self.scrollView.clipsToBounds = YES;
	self.scrollView.layer.cornerRadius = 19;
	self.scrollView.pagingEnabled = isPaging;
	self.scrollView.indicatorStyle = indicatorStyle;

	self.scrollView.showsHorizontalScrollIndicator = NO;
	self.scrollView.showsVerticalScrollIndicator = YES;

	[self.view addSubview:self.scrollView];
}

- (void)intiToggles {

	PlatoUILabeledRoundButtonViewController *toggle;

	for (int i = 0; i < toggleTotal; i++) {
		toggle = [[PlatoUILabeledRoundButtonViewController alloc] initWithEventIdentifier:[NSString stringWithFormat:@"com.azzou.plato.toggle%d", (i + 1)]];

		[toggle.view.layer setFrame:(CGRect){ {0, 0}, [toggle.view sizeThatFits:self.view.bounds.size] }];

		toggle.title = [NSString stringWithFormat:@"Num %d", i];
		toggle.subtitle = @"Subtitle";
		toggle.useAlternateBackground = NO;
		toggle.labelsVisible = YES;

		[self addChildViewController:toggle];
		[self.scrollView addSubview:toggle.view];
		[toggle didMoveToParentViewController:self];
	}

	self.toggleSize = toggle.view.layer.frame.size;
}

- (void)viewDidLoad {

	[super viewDidLoad];

	_preferredExpandedContentWidth = UIScreen.mainScreen.bounds.size.width * 0.856;
	_preferredExpandedContentHeight = self.preferredExpandedContentWidth * 1.34;
}

- (void)viewWillAppear:(BOOL)animated {

	[super viewWillAppear:animated];

	[self layoutCollapsed];
}

- (void)layoutCollapsed {

	CGSize scrollViewSize = self.scrollView.bounds.size;

	CCUILabeledRoundButton *toggle;
	CGFloat toggleWidth = self.toggleSize.width;
	CGFloat toggleHeight = self.toggleSize.height;
	CGPoint togglePosition = { 0, 0 };

	CGFloat spaceWidth = ((scrollViewSize.width - (self.columnCollapsed * toggleWidth)) / (self.columnCollapsed + 1));
	CGFloat spaceHeight = ((scrollViewSize.height - (self.rowCollapsed * toggleHeight)) / (self.rowCollapsed + 1));

	int pageIndex = -1;

	[self layoutCollapsedScrollView:scrollViewSize];

	for (int i = 0; i < toggleTotal; i++) {
		toggle = (CCUILabeledRoundButton *)self.scrollView.subviews[i];

		if (IS_NEW_PAGE(i, self.toggleCollapsed)) {
			pageIndex++;
			togglePosition.x = spaceWidth + (pageIndex * scrollViewSize.width);
			togglePosition.y = spaceHeight;
		} else if (IS_NEW_ROW(i, self.columnCollapsed)) {
			togglePosition.x = spaceWidth + (pageIndex * scrollViewSize.width);
			togglePosition.y += spaceHeight + toggleHeight;
		}

		toggle.labelsVisible = NO;
		[toggle.layer setAnchorPoint:(CGPoint){ 0.5, 0.5 }];
		[toggle.layer setFrame:(CGRect){ togglePosition, { toggleWidth, toggleHeight }}];

		togglePosition.x += spaceWidth + toggleWidth;
	}
}

- (void)layoutExpanded {

	CGSize scrollViewSize = self.scrollView.bounds.size;

	CCUILabeledRoundButton *toggle;
	CGFloat toggleHeight = (self.scrollView.subviews[0].subviews[0].frame.size.height * 2) + self.toggleSize.height + 8;
	CGFloat toggleWidth = toggleHeight * 1.5;
	CGPoint togglePosition = { 0, 0 };

	CGFloat spaceWidth = ((scrollViewSize.width - (columnExpanded * toggleWidth)) / (columnExpanded + 1));
	CGFloat spaceHeight = ((scrollViewSize.height - (rowExpanded * toggleHeight)) / (rowExpanded + 1));

	int pageIndex = -1;

	[self layoutExtandedScrollView:scrollViewSize];

	for (int i = 0; i < toggleTotal; i++) {
		toggle = (CCUILabeledRoundButton *)self.scrollView.subviews[i];

		if (IS_NEW_PAGE(i, toggleExpanded)) {
			pageIndex++;
			togglePosition.x = spaceWidth;
			togglePosition.y = spaceHeight + (pageIndex * scrollViewSize.height);
		} else if (IS_NEW_ROW(i, columnExpanded)) {
			togglePosition.x = spaceWidth;
			togglePosition.y += spaceHeight + toggleHeight;
		}

		toggle.labelsVisible = YES;
		[toggle.layer setAnchorPoint:(CGPoint){ 0.5, 0.5 }];
		[toggle.layer setFrame:(CGRect){ togglePosition, { toggleWidth, toggleHeight }}];

		togglePosition.x += spaceWidth + toggleWidth;
	}
}

- (void)layoutCollapsedScrollView:(CGSize)scrollViewSize {

	self.scrollView.contentSize = (CGSize){ scrollViewSize.width * self.pageCollapsed, scrollViewSize.height };
	self.scrollView.showsHorizontalScrollIndicator = (isIndicator) ? YES : NO;
	self.scrollView.showsVerticalScrollIndicator = NO;
	self.scrollView.scrollIndicatorInsets = (UIEdgeInsets){ 0, 20, 0, 20 };
	[self.scrollView scrollRectToVisible:(CGRect){{ scrollViewSize.width * scrollToPage, self.scrollView.bounds.origin.y }, scrollViewSize } animated:NO];
}

- (void)layoutExtandedScrollView:(CGSize)scrollViewSize {

	self.scrollView.contentSize = (CGSize){ scrollViewSize.width, scrollViewSize.height * pageTotalExpanded };
	self.scrollView.showsHorizontalScrollIndicator = NO;
	self.scrollView.showsVerticalScrollIndicator = (isIndicator) ? YES : NO;
	self.scrollView.scrollIndicatorInsets = (UIEdgeInsets){ 40, 0, 40, 0 };
}

- (void)willTransitionToExpandedContentMode:(BOOL)isExpanded {
	self.isExpanded = isExpanded;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {

	[coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context){
		(self.isExpanded) ? [self layoutExpanded] : [self layoutCollapsed];
	} completion:nil];
}


- (BOOL)_canShowWhileLocked {

	return YES;
}

@end

// if (!(toggleTotal - (i + 1))) {
// 	pageSpaceWidth = ((scrollViewSize.width - toggleSizeWidth) / 2);
// }