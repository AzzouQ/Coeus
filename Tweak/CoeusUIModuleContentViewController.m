#import "CoeusPreferences.h"
#import "CoeusUIModuleContentViewController.h"

#define IS_NEW_PAGE(index, togglePage) (!(index % togglePage))
#define IS_NEW_ROW(index, toggleColumn) (!(index % toggleColumn))

#define GET_SPACE_WIDTH(widthTotal, toggleColumn, toggleWidth) ((widthTotal - (toggleColumn * toggleWidth)) / (toggleColumn + 1))
#define GET_SPACE_HEIGHT(heightTotal, toggleRow, toggleHeight) ((heightTotal - (toggleRow * toggleHeight)) / (toggleRow + 1))

#define GET_PAGE_TOTAL(toggleTotal, togglePage) (toggleTotal / togglePage) + ((toggleTotal % togglePage) ? 1 : 0)
#define GET_COLUMN_TOTAL(toggleTotal, togglePage, toggleColumn) ((toggleTotal / togglePage) * toggleColumn) + ((toggleTotal % togglePage) > toggleColumn ? toggleColumn : toggleTotal % togglePage)
#define GET_ROW_TOTAL(toggleTotal, togglePage, toggleRow) ((toggleTotal / togglePage) * toggleRow) + (((toggleTotal % togglePage) / toggleRow) + 1)

#define SCROLL_TO_PAGE_HORIZONTAL(scrollViewBounds, scrollToPage) (CGRect){{ scrollViewBounds.size.width * scrollToPage, scrollViewBounds.origin.y }, scrollViewBounds.size }
#define SCROLL_TO_PAGE_VERTICAL(scrollViewBounds, scrollToPage) (CGRect){{ scrollViewBounds.origin.x, scrollViewBounds.size.width * scrollToPage }, scrollViewBounds.size }

static const int toggleTotal = 20;

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
	[prefs registerBool:&isLabelsCollapsed default:NO forKey:@"isLabelsCollapsed"];

	[prefs registerInteger:&columnExpanded default:2 forKey:@"columnExpanded"];
	[prefs registerInteger:&rowExpanded default:3 forKey:@"rowExpanded"];
	[prefs registerBool:&isIndicatorExpanded default:YES forKey:@"isIndicatorExpanded"];
	[prefs registerBool:&isPagingExpanded default:YES forKey:@"isPagingExpanded"];
	[prefs registerBool:&isLabelsExpanded default:YES forKey:@"isLabelsExpanded"];
	[prefs registerBool:&isScrollVertical default:NO forKey:@"isScrollVertical"];
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
		toggle.subtitle = @"Subtitleeeeeeeeeeeeee";
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

	self.isPaging = isPagingCollapsed;
	self.isLabels = isLabelsCollapsed;
	self.column = columnCollapsed;
	self.row = rowCollapsed;
	self.togglePage = self.column * self.row;
	self.spaceWidth = GET_SPACE_WIDTH(self.scrollView.bounds.size.width, self.column, self.toggleSize.width);
	self.spaceHeight = GET_SPACE_HEIGHT(self.scrollView.bounds.size.height, self.row, self.toggleSize.height);

	[self layoutScrollView];
	[self layoutScrollViewCollapsed];

	[self layoutHorizontal];
}

- (void)layoutExpanded {

	self.isPaging = isPagingExpanded;
	self.isLabels = isLabelsExpanded;
	self.column = columnExpanded;
	self.row = rowExpanded;
	self.togglePage = self.column * self.row;
	self.spaceWidth = GET_SPACE_WIDTH(self.scrollView.bounds.size.width, self.column, self.toggleSize.width);
	self.spaceHeight = GET_SPACE_HEIGHT(self.scrollView.bounds.size.height, self.row, self.toggleSize.height);

	[self layoutScrollView];
	[self layoutScrollViewExtanded];

	(isScrollVertical) ? [self layoutVertical] : [self layoutHorizontal];
}

- (void)layoutHorizontal {

	CCUILabeledRoundButton *toggle = nil;
	CGPoint togglePosition = { self.spaceWidth, self.spaceHeight };

	int pageIndex = 0;

	for (int i = 0; i < toggleTotal; i++) {
		toggle = (CCUILabeledRoundButton *)self.scrollView.subviews[i];

		if ((i) && IS_NEW_PAGE(i, self.togglePage)) {
			pageIndex++;
			togglePosition.x = ((self.isPaging) ? (pageIndex * self.scrollView.bounds.size.width) : togglePosition.x + self.toggleSize.width) + self.spaceWidth;
			togglePosition.y = self.spaceHeight;
		} else if ((i) && IS_NEW_ROW(i, self.column)) {
			togglePosition.x = ((self.isPaging) ? (pageIndex * self.scrollView.bounds.size.width) + self.spaceWidth : togglePosition.x - ((self.column - 1) * (self.toggleSize.width + self.spaceWidth)));
			togglePosition.y += self.toggleSize.height + self.spaceHeight;
		} else if (i) {
			togglePosition.x += self.toggleSize.width + self.spaceWidth;
		}

		toggle.labelsVisible = self.isLabels;
		[toggle.layer setAnchorPoint:(CGPoint){ 0.5, 0.5 }];
		[toggle.layer setFrame:(CGRect){ togglePosition, self.toggleSize}];
	}
}

- (void)layoutVertical {

	CCUILabeledRoundButton *toggle = nil;
	CGPoint togglePosition = { self.spaceWidth, self.spaceHeight };

	int pageIndex = 0;

	for (int i = 0; i < toggleTotal; i++) {
		toggle = (CCUILabeledRoundButton *)self.scrollView.subviews[i];

		if ((i) && IS_NEW_PAGE(i, self.togglePage)) {
			pageIndex++;
			togglePosition.x = self.spaceWidth;
			togglePosition.y = ((self.isPaging) ? (pageIndex * self.scrollView.bounds.size.height) : togglePosition.y + self.toggleSize.height) + self.spaceHeight;
		} else if ((i) && IS_NEW_ROW(i, self.column)) {
			togglePosition.x = self.spaceWidth;
			togglePosition.y += self.toggleSize.height + self.spaceHeight;
		} else if (i) {
			togglePosition.x += self.toggleSize.width + self.spaceWidth;
		}

		toggle.labelsVisible = self.isLabels;
		[toggle.layer setAnchorPoint:(CGPoint){ 0.5, 0.5 }];
		[toggle.layer setFrame:(CGRect){ togglePosition, self.toggleSize}];
	}
}

- (void)layoutScrollView {

	self.scrollView.contentSize = [self getScrollViewContentSize];
	self.scrollView.indicatorStyle = (isIndicatorDark) ? 1 : 2;
	self.scrollView.pagingEnabled = (self.isExpanded) ? isPagingExpanded : isPagingCollapsed;
	self.scrollView.scrollIndicatorInsets = (isScrollVertical && self.isExpanded) ? (UIEdgeInsets){ 40, 0, 40, 0 } : (UIEdgeInsets){ 0, 30, 0, 30 };
	if (self.isExpanded) {
		self.scrollView.showsHorizontalScrollIndicator = (isScrollVertical) ? NO : (isIndicatorExpanded);
		self.scrollView.showsVerticalScrollIndicator = (isScrollVertical) ? (isIndicatorExpanded) : NO;
	} else {
		self.scrollView.showsHorizontalScrollIndicator = (isIndicatorCollapsed);
		self.scrollView.showsVerticalScrollIndicator = NO;
	}
}

- (void)layoutScrollViewCollapsed {

	[self.scrollView scrollRectToVisible:SCROLL_TO_PAGE_HORIZONTAL(self.scrollView.bounds, scrollToPageCollapsed) animated:NO];
}

- (void)layoutScrollViewExtanded {

	[self.scrollView scrollRectToVisible:SCROLL_TO_PAGE_VERTICAL(self.scrollView.bounds, scrollToPageExtanded) animated:NO];
}

- (CGSize)getScrollViewContentSize {

	NSInteger multiplier;
	CGSize contentSize = self.scrollView.bounds.size;

	if (self.isExpanded) {
		if (isPagingExpanded) {
			multiplier = GET_PAGE_TOTAL(toggleTotal, self.togglePage);
			if (isScrollVertical) {
				contentSize.height *= multiplier;
			} else {
				contentSize.width *= multiplier;
			}
		} else {
			if (isScrollVertical) {
				multiplier = GET_ROW_TOTAL(toggleTotal, self.togglePage, self.row);
				contentSize.height = self.spaceHeight + ((self.toggleSize.height + self.spaceHeight) * multiplier);
			} else {
				multiplier = GET_COLUMN_TOTAL(toggleTotal, self.togglePage, self.column);
				contentSize.width = self.spaceWidth + ((self.toggleSize.width + self.spaceWidth) * multiplier);
			}
		}
	} else {
		if (isPagingCollapsed) {
			multiplier = GET_PAGE_TOTAL(toggleTotal, self.togglePage);
			contentSize.width *= multiplier;
		} else {
			multiplier = GET_COLUMN_TOTAL(toggleTotal, self.togglePage, self.column);
			contentSize.width = self.spaceWidth + ((self.toggleSize.width + self.spaceWidth) * multiplier);
		}
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

// CGSize toggleSize = self.toggleSize;
// if (isLabelsExpanded) {
// 	toggleSize.height = (self.scrollView.subviews[0].subviews[0].frame.size.height * 2) + self.toggleSize.height + 8;
// 	toggleSize.width = toggleSize.height * 1.5;
// }