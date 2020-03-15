ARCHS = arm64
THEOS_DEVICE_IP = 192.168.1.5
TARGET = iphone:clang:latest:latest

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = springboard3d
springboard3d_FILES = Tweak.xm AXSceneViewController.m AXControllerView.m AXBoxNode.m
springboard3d_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "sbreload"
