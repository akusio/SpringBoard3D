ARCHS = arm64
THEOS_DEVICE_IP = 192.168.1.8
TARGET = iphone:clang:11.2:11.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = springboard3d
springboard3d_FILES = Tweak.xm AXSceneViewController.m AXControllerView.m AXBoxNode.m
springboard3d_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
