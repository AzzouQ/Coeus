HBPreferences *prefs;

NSInteger columnCollapsed = 5;
NSInteger rowCollapsed = 1;
NSUInteger moduleWidth = 4;
NSUInteger moduleHeight = 1;

void CoeusReloadPrefs() {
  prefs = [[HBPreferences alloc] initWithIdentifier:@"com.azzou.platoprefs"];

	[prefs registerInteger:&columnCollapsed default:5 forKey:@"columnCollapsed"];
	[prefs registerInteger:&rowCollapsed default:1 forKey:@"rowCollapsed"];
  [prefs registerUnsignedInteger:&moduleWidth default:4 forKey:@"moduleWidth"];
	[prefs registerUnsignedInteger:&moduleHeight default:1 forKey:@"moduleHeight"];
}