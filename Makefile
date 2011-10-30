include theos/makefiles/common.mk

TWEAK_NAME = BounceLock
BounceLock_FILES = Tweak.xm
BounceLock_FRAMEWORKS=UIKit CoreGraphics
SUBPROJECTS= bouncelocksettings
include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk