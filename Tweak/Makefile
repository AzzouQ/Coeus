ARCHS = arm64 arm64e
TARGET := iphone:clang:11.2

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

SOURCE	=	PlatoUIModule.m								\
			PlatoUIModuleContentViewController.m		\
			PlatoUILabeledRoundButtonViewController.m	\
			PlatoLAEvent.m								\

BUNDLE_NAME = Plato
$(BUNDLE_NAME)_BUNDLE_EXTENSION = bundle
$(BUNDLE_NAME)_FILES = $(SOURCE)
$(BUNDLE_NAME)_LIBRARIES += activator flipswitch
$(BUNDLE_NAME)_EXTRA_FRAMEWORKS += Cephei
$(BUNDLE_NAME)_PRIVATE_FRAMEWORKS = ControlCenterUIKit
$(BUNDLE_NAME)_INSTALL_PATH = /Library/ControlCenter/Bundles/

include $(THEOS_MAKE_PATH)/bundle.mk
