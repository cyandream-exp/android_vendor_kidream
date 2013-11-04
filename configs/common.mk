# compile KiDream packages
PRODUCT_PACKAGES += \
    ControlCenter \
    xdelta3 \
    Superuser \
    su

# APN list
PRODUCT_COPY_FILES += \
    vendor/kidream/prebuilt/apns-conf.xml:system/etc/apns-conf.xml

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.google.clientidbase=android-google \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

ifneq ($(TARGET_BUILD_VARIANT),eng)
# Enable ADB authentication
ADDITIONAL_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

PRODUCT_VERSION_MAJOR = 1
PRODUCT_VERSION_MINOR = 0
PRODUCT_VERSION_MAINTENANCE = 0

ifndef KD_BUILDTYPE
ifdef RELEASE_TYPE
        RELEASE_TYPE := $(shell echo $(RELEASE_TYPE) | sed -e 's|^KD_||g')
        KD_BUILDTYPE := $(RELEASE_TYPE)
endif

endif

ifeq ($(filter RELEASE NIGHTLY TEST,$(KD_BUILDTYPE)),)
    KD_BUILDTYPE :=
endif

ifdef KD_BUILDTYPE
 ifdef KD_EXTRAVERSION
            KD_BUILDTYPE := TEST
else
            KD_EXTRAVERSION :=
endif
else
    KD_BUILDTYPE := NIGHTLY
    KD_EXTRAVERSION :=
endif

ifeq ($(KD_BUILDTYPE), RELEASE)
    KD_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)
else
ifeq ($(PRODUCT_VERSION_MINOR),0)
        KD_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(shell date +%Y%m%d-%H%M)-$(KD_BUILDTYPE)$(KD_EXTRAVERSION)
else
        KD_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(shell date +%Y%m%d-%H%M)-$(KD_BUILDTYPE)$(KD_EXTRAVERSION)
endif
endif

PRODUCT_PROPERTY_OVERRIDES += \
  ro.kd.version=$(KD_VERSION) \
  ro.modversion=$(KD_VERSION)
