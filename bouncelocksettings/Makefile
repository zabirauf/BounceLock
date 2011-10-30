include theos/makefiles/common.mk

BUNDLE_NAME = BounceLockSettings
BounceLockSettings_FILES = BounceLockSettings.mm
BounceLockSettings_INSTALL_PATH = /Library/PreferenceBundles
BounceLockSettings_FRAMEWORKS = UIKit
BounceLockSettings_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/BounceLockSettings.plist$(ECHO_END)
