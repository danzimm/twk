TWEAK=twk
CC:=clang
ARCH:=armv7
PORT=2222
OBJECTS_$(TWEAK) = $(TWEAK).o
XCODE_BASE=$(shell xcode-select --print-path)
LDFLAGS=
LDFLAGS_$(TWEAK)=-dynamiclib -lsubstrate -framework Foundation -framework CoreGraphics -framework UIKit
CFLAGS=-Wall -Werror -arch $(ARCH) --sysroot=$(XCODE_BASE)/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS6.0.sdk/

all: $(TWEAK).dylib
	
.PHONY: all

$(TWEAK).dylib: $(OBJECTS_$(TWEAK))
	$(CC) $^ -o $@ $(CFLAGS) $(LDFLAGS) $(LDFLAGS_$(TWEAK))

%.o : %.m
	$(CC) -c $< -o $@ $(CFLAGS)

.PHONY: install

install: $(TWEAK).dylib
	scp -P $(PORT) $< root@localhost:/Library/MobileSubstrate/DynamicLibraries/
	scp -P $(PORT) $(TWEAK).plist root@localhost:/Library/MobileSubstrate/DynamicLibraries/
	ssh root@localhost -p $(PORT) killall -9 SpringBoard

.PHONY: clean

clean:
	rm -rf $(OBJECTS_$(TWEAK)) $(TWEAK).dylib

