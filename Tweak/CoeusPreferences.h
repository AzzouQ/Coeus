#import <Cephei/HBPreferences.h>

HBPreferences		*prefs;

static NSUInteger	moduleWidth;
static NSUInteger	moduleHeight;
static BOOL			isIndicatorDark;

static NSArray		*toggleList;

static NSInteger	columnCollapsed;
static NSInteger	rowCollapsed;
static BOOL			isIndicatorCollapsed;
static BOOL			isPagingCollapsed;
static BOOL			isLabelsCollapsed;

static NSInteger	columnExpanded;
static NSInteger	rowExpanded;
static BOOL			isIndicatorExpanded;
static BOOL			isPagingExpanded;
static BOOL			isLabelsExpanded;
static BOOL			isScrollVertical;