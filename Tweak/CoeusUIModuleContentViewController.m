#import "CoeusPreferences.h"
#import "CoeusUIModuleContentViewController.h"

#define IS_NEW_PAGE(index, togglePage) (!(index % togglePage))
#define IS_NEW_ROW(index, toggleColumn) (!(index % toggleColumn))

#define GET_SPACE_WIDTH(widthTotal, toggleColumn, toggleWidth) ((widthTotal - (toggleColumn * toggleWidth)) / (toggleColumn + 1))
#define GET_SPACE_HEIGHT(heightTotal, toggleRow, toggleHeight) ((heightTotal - (toggleRow * toggleHeight)) / (toggleRow + 1))

#define GET_PAGE_TOTAL(toggleTotal, togglePage) (toggleTotal / togglePage) + ((toggleTotal % togglePage) ? 1 : 0)
#define GET_TOGGLE_ROW_TOTAL(toggleTotal, toggleRowTotal) (toggleTotal / toggleRowTotal) + ((toggleTotal % toggleRowTotal) ? 1 : 0)

#define SCROLL_TO_PAGE_HORIZONTAL(scrollViewBounds, scrollToPage) (CGRect){{ scrollViewBounds.size.width * scrollToPage, scrollViewBounds.origin.y }, scrollViewBounds.size }
#define SCROLL_TO_PAGE_VERTICAL(scrollViewBounds, scrollToPage) (CGRect){{ scrollViewBounds.origin.x, scrollViewBounds.size.width * scrollToPage }, scrollViewBounds.size }

static const int toggleTotal = 25;

static const int scrollToPageCollapsed = 0;
static const int scrollToPageExtanded = 0;

@implementation CoeusUIModuleContentViewController

- (instancetype)initWithNibName:(NSString*)name bundle:(NSBundle*)bundle {

	if ((self = [super initWithNibName:name bundle:bundle])) {

		self.view.autoresizesSubviews = YES;

		[self initPreferences];
		[self initScrollView];
		[self intiToggles];
	}

	return self;
}

- (void)initPreferences {

	[prefs registerBool:&isIndicatorDark default:NO forKey:@"isIndicatorDark"];

	[prefs registerInteger:&columnCollapsed default:5 forKey:@"columnCollapsed"];
	[prefs registerInteger:&rowCollapsed default:1 forKey:@"rowCollapsed"];
	[prefs registerBool:&isIndicatorCollapsed default:NO forKey:@"isIndicatorCollapsed"];
	[prefs registerBool:&isPagingCollapsed default:YES forKey:@"isPagingCollapsed"];

	[prefs registerInteger:&columnExpanded default:2 forKey:@"columnExpanded"];
	[prefs registerInteger:&rowExpanded default:3 forKey:@"rowExpanded"];
	[prefs registerBool:&isIndicatorExpanded default:YES forKey:@"isIndicatorExpanded"];
	[prefs registerBool:&isPagingExpanded default:YES forKey:@"isPagingExpanded"];
	[prefs registerBool:&isLabelsExpanded default:YES forKey:@"isLabelsExpanded"];
}

- (void)initScrollView {

	self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];

	[self.scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	self.scrollView.clipsToBounds = YES;
	self.scrollView.layer.cornerRadius = 19;

	[self.view addSubview:self.scrollView];
}

- (void)intiToggles {

	CoeusUILabeledRoundButtonViewController *toggle;

	for (int i = 0; i < toggleTotal; i++) {
		toggle = [[CoeusUILabeledRoundButtonViewController alloc] initWithEventIdentifier:[NSString stringWithFormat:@"com.azzou.coeus.toggle%d", (i + 1)]];

		[toggle.view.layer setFrame:(CGRect){ {0, 0}, [toggle.view sizeThatFits:self.view.bounds.size] }];

		toggle.title = [NSString stringWithFormat:@"Title %d", (i + 1)];
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

	self.togglePage = columnCollapsed * rowCollapsed;
	self.spaceWidth = GET_SPACE_WIDTH(self.scrollView.bounds.size.width, columnCollapsed, self.toggleSize.width);
	self.spaceHeight = GET_SPACE_HEIGHT(self.scrollView.bounds.size.height, rowCollapsed, self.toggleSize.height);

	CCUILabeledRoundButton *toggle = nil;
	CGPoint togglePosition = { self.spaceWidth, self.spaceHeight };

	int pageIndex = 0;

	[self layoutScrollViewCollapsed];

	for (int i = 0; i < toggleTotal; i++) {
		toggle = (CCUILabeledRoundButton *)self.scrollView.subviews[i];

		if ((i) && IS_NEW_PAGE(i, self.togglePage)) {
			pageIndex++;
			togglePosition.x = (isPagingCollapsed) ? (pageIndex * self.scrollView.bounds.size.width) + self.spaceWidth : togglePosition.x;
			togglePosition.y = self.spaceHeight;
		} else if ((i) && IS_NEW_ROW(i, columnCollapsed)) {
			togglePosition.x = (pageIndex * self.scrollView.bounds.size.width) + self.spaceWidth - (isPagingCollapsed ? 0 : (self.spaceWidth * pageIndex));
			togglePosition.y += self.toggleSize.height + self.spaceHeight;
		}

		toggle.labelsVisible = NO;
		[toggle.layer setAnchorPoint:(CGPoint){ 0.5, 0.5 }];
		[toggle.layer setFrame:(CGRect){ togglePosition, self.toggleSize}];

		togglePosition.x += self.toggleSize.width + self.spaceWidth;
	}
}

- (void)layoutExpanded {

	CGSize toggleSize = self.toggleSize;
	toggleSize.height = (self.scrollView.subviews[0].subviews[0].frame.size.height * 2) + self.toggleSize.height + 8;

	self.toggleExpanded = columnExpanded * rowExpanded;
	self.spaceWidth = GET_SPACE_WIDTH(self.scrollView.bounds.size.width, columnExpanded, toggleSize.width);
	self.spaceHeight = GET_SPACE_HEIGHT(self.scrollView.bounds.size.height, rowExpanded, toggleSize.height);

	CCUILabeledRoundButton *toggle = nil;
	CGPoint togglePosition = { 0, 0 };

	int pageIndex = -1;

	[self layoutScrollViewExtanded];

	for (int i = 0; i < toggleTotal; i++) {
		toggle = (CCUILabeledRoundButton *)self.scrollView.subviews[i];

		if (IS_NEW_PAGE(i, self.toggleExpanded)) {
			pageIndex++;
			togglePosition.x = self.spaceWidth;
			togglePosition.y = (pageIndex * self.scrollView.bounds.size.height) + self.spaceHeight;
		} else if (IS_NEW_ROW(i, columnExpanded)) {
			togglePosition.x = self.spaceWidth;
			togglePosition.y += toggleSize.height + self.spaceHeight;
		}

		toggle.labelsVisible = isLabelsExpanded;
		[toggle.layer setAnchorPoint:(CGPoint){ 0.5, 0.5 }];
		[toggle.layer setFrame:(CGRect){ togglePosition, toggleSize}];

		togglePosition.x += toggleSize.width + self.spaceWidth;
	}
}

- (void)layoutScrollViewCollapsed {

	self.scrollView.contentSize = [self getScrollViewContentSize];
	self.scrollView.indicatorStyle = (isIndicatorDark) ? 1 : 2;
	self.scrollView.pagingEnabled = isPagingCollapsed;
	self.scrollView.showsHorizontalScrollIndicator = (isIndicatorCollapsed) ? YES : NO;
	self.scrollView.showsVerticalScrollIndicator = NO;
	self.scrollView.scrollIndicatorInsets = (UIEdgeInsets){ 0, 20, 0, 20 };
	[self.scrollView scrollRectToVisible:SCROLL_TO_PAGE_HORIZONTAL(self.scrollView.bounds, scrollToPageCollapsed) animated:NO];
}

- (void)layoutScrollViewExtanded {

	self.scrollView.contentSize = [self getScrollViewContentSize];
	self.scrollView.indicatorStyle = (isIndicatorDark) ? 1 : 2;
	self.scrollView.pagingEnabled = isPagingExpanded;
	self.scrollView.showsHorizontalScrollIndicator = NO;
	self.scrollView.showsVerticalScrollIndicator = (isIndicatorExpanded) ? YES : NO;
	self.scrollView.scrollIndicatorInsets = (UIEdgeInsets){ 40, 0, 40, 0 };
	[self.scrollView scrollRectToVisible:SCROLL_TO_PAGE_VERTICAL(self.scrollView.bounds, scrollToPageExtanded) animated:NO];
}

- (CGSize)getScrollViewContentSize {

	NSInteger multiplier;
	CGSize contentSize = self.scrollView.bounds.size;

	if (isPagingCollapsed || isPagingExpanded) {
		multiplier = GET_PAGE_TOTAL(toggleTotal, self.togglePage);
		if (self.isExpanded)
			contentSize.height *= multiplier;
		else
			contentSize.width *= multiplier;
	} else {
		multiplier = GET_TOGGLE_ROW_TOTAL(toggleTotal, rowCollapsed);
		contentSize.width = self.spaceWidth + ((self.toggleSize.width + self.spaceWidth) * multiplier);
	}

	return contentSize;
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