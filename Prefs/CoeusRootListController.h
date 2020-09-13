#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBRootListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <Cephei/HBPreferences.h>
#import <Cephei/HBRespringController.h>

#import "../Tweak/CoeusPreferences.h"

@interface CoeusAppearanceSettings : HBAppearanceSettings
@end

@interface CoeusRootListController : HBRootListController {
	UITableView *_table;
}

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconView;

- (void)reset;
- (void)respring;

@end