#import <Cephei/HBPreferences.h>

HBPreferences		*prefs;

static NSUInteger	widthCollapsed;
static NSUInteger	heightCollapsed;

static NSUInteger	widthExpanded;
static NSUInteger	heightExpanded;

static BOOL			isIndicatorDark;

static NSArray		*toggleList;

static NSInteger	rowCollapsed;
static NSInteger	columnCollapsed;
static BOOL			isIndicatorCollapsed;
static BOOL			isPagingCollapsed;
static BOOL			isLabelsCollapsed;

static NSInteger	rowExpanded;
static NSInteger	columnExpanded;
static BOOL			isIndicatorExpanded;
static BOOL			isPagingExpanded;
static BOOL			isLabelsExpanded;
static BOOL			isScrollVertical;