#import <Preferences/Preferences.h>

@interface BounceLockSettingsListController: PSListController {
}
@end

@implementation BounceLockSettingsListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"BounceLockSettings" target:self] retain];
	}
	return _specifiers;
}
@end

// vim:ft=objc
