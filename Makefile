#---------------------------------------------------------------------------------
.SUFFIXES:
#---------------------------------------------------------------------------------

ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITARM in your environment. export DEVKITARM=<path to>devkitARM")
endif

TOPDIR ?= $(CURDIR)
include $(DEVKITARM)/3ds_rules

#---------------------------------------------------------------------------------
# TARGET        - name of the output (.3dsx/.elf/.smdh)
# BUILD         - directory where object and intermediate files are placed
# SOURCES       - directories containing source files
# DATA          - directories containing binary files to embed in the binary
# INCLUDES      - directories to add to the include search path
# ROMFS         - directory whose contents are packed into the RomFS image
#
# NOTE: Set up the RomFS directory before building:
#   mkdir -p romfs
#   ln -s ../data romfs/data        # Linux/macOS
#   mklink /D romfs\data ..\data    # Windows (run as admin or with Developer Mode)
#
# The game looks for data files at "data/<name>" relative to CWD. On 3DS the
# romfs is mounted at romfs:/ and that directory becomes the CWD, so romfs/data
# must contain the game data.
#
# APP_TITLE        stored in the SMDH file (optional)
# APP_DESCRIPTION  stored in the SMDH file (optional)
# APP_AUTHOR       stored in the SMDH file (optional)
# ICON             48x48 PNG icon (optional; falls back to libctru default)
#---------------------------------------------------------------------------------
TARGET          :=  prince
BUILD           :=  build
SOURCES         :=  src
DATA            :=
INCLUDES        :=  src
ROMFS           :=  romfs

APP_TITLE       :=  Prince of Persia
APP_DESCRIPTION :=  SDLPoP - Prince of Persia
APP_AUTHOR      :=  larm504 (3DS port); David, Norbert (SDLPoP)

#---------------------------------------------------------------------------------
# options for code generation
#---------------------------------------------------------------------------------
ARCH    :=  -march=armv6k -mtune=mpcore -mfloat-abi=hard -mtp=soft

CFLAGS  :=  -g -Wall -O2 -mword-relocations \
            -fomit-frame-pointer -ffunction-sections \
            $(ARCH)

CFLAGS  +=  $(INCLUDE) -D__3DS__ -D_GNU_SOURCE=1 -std=c99

CXXFLAGS    :=  $(CFLAGS) -fno-rtti -fno-exceptions

ASFLAGS :=  -g $(ARCH)
LDFLAGS  =  -specs=3dsx.specs -g $(ARCH) -Wl,-Map,$(notdir $*.map)

#---------------------------------------------------------------------------------
# libraries to link against
# Order matters: SDL_mixer/SDL_image before SDL, codecs after SDL, ctru last
#---------------------------------------------------------------------------------
LIBS    :=  -lSDL_mixer -lSDL_image -lSDL \
            -lmikmod -lvorbisidec -logg \
            -lpng -ljpeg -lz \
            -lcitro3d -lctru -lm

#---------------------------------------------------------------------------------
# library search directories: portlibs/3ds, portlibs/armv6k, and libctru
# PORTLIBS and CTRULIB are defined by $(DEVKITARM)/3ds_rules
#---------------------------------------------------------------------------------
LIBDIRS :=  $(PORTLIBS) $(CTRULIB)

#---------------------------------------------------------------------------------
# no real need to set up the rest if cleaning
#---------------------------------------------------------------------------------
ifneq ($(BUILD),$(notdir $(CURDIR)))
#---------------------------------------------------------------------------------

export OUTPUT   :=  $(CURDIR)/$(TARGET)
export TOPDIR   :=  $(CURDIR)

export VPATH    :=  $(foreach dir,$(SOURCES),$(CURDIR)/$(dir)) \
                    $(foreach dir,$(DATA),$(CURDIR)/$(dir))

export DEPSDIR  :=  $(CURDIR)/$(BUILD)

CFILES      :=  $(foreach dir,$(SOURCES),$(notdir $(wildcard $(CURDIR)/$(dir)/*.c)))
BINFILES    :=  $(foreach dir,$(DATA),$(notdir $(wildcard $(CURDIR)/$(dir)/*.*)))

export LD   :=  $(CC)

export OFILES_BIN   :=  $(addsuffix .o,$(BINFILES))
export OFILES_SRC   :=  $(CFILES:.c=.o)
export OFILES       :=  $(OFILES_BIN) $(OFILES_SRC)
export HFILES_BIN   :=  $(addsuffix .h,$(subst .,_,$(BINFILES)))

export INCLUDE  :=  $(foreach dir,$(INCLUDES),-I$(CURDIR)/$(dir)) \
                    $(foreach dir,$(LIBDIRS),-I$(dir)/include) \
                    -I$(CURDIR)/$(BUILD)

export LIBPATHS :=  $(foreach dir,$(LIBDIRS),-L$(dir)/lib)

ifeq ($(strip $(ICON)),)
    icons   :=  $(wildcard *.png)
    ifneq (,$(findstring $(TARGET).png,$(icons)))
        export APP_ICON :=  $(TOPDIR)/$(TARGET).png
    else ifneq (,$(findstring icon.png,$(icons)))
        export APP_ICON :=  $(TOPDIR)/icon.png
    endif
else
    export APP_ICON :=  $(TOPDIR)/$(ICON)
endif

ifeq ($(strip $(NO_SMDH)),)
    export _3DSXFLAGS   +=  --smdh=$(CURDIR)/$(TARGET).smdh
endif

ifneq ($(strip $(ROMFS)),)
    export _3DSXFLAGS   +=  --romfs=$(CURDIR)/$(ROMFS)
endif

.PHONY: $(BUILD) clean all romfs-setup

#---------------------------------------------------------------------------------
all: $(BUILD)
	@$(MAKE) --no-print-directory -C $(BUILD) -f $(CURDIR)/Makefile

$(BUILD):
	@mkdir -p $@

#---------------------------------------------------------------------------------
# Create the romfs/data symlink so the game can find its data files at romfs:/data
#---------------------------------------------------------------------------------
romfs-setup:
	@mkdir -p romfs
	@[ -e romfs/data ] || ln -s ../data romfs/data
	@echo "romfs/data symlink created."

#---------------------------------------------------------------------------------
clean:
	@rm -rf $(BUILD) $(TARGET).3dsx $(TARGET).smdh $(TARGET).elf

#---------------------------------------------------------------------------------
else
#---------------------------------------------------------------------------------

DEPENDS :=  $(OFILES:.o=.d)

#---------------------------------------------------------------------------------
# main targets
#---------------------------------------------------------------------------------
$(OUTPUT).3dsx  :   $(OUTPUT).elf $(OUTPUT).smdh

$(OUTPUT).elf   :   $(OFILES)

$(OFILES_SRC)   :   $(HFILES_BIN)

#---------------------------------------------------------------------------------
# rule for embedding binary data (unused unless DATA dirs are set)
#---------------------------------------------------------------------------------
%.bin.o %_bin.h :   %.bin
	@echo $(notdir $<)
	@$(bin2o)

-include $(DEPENDS)

#---------------------------------------------------------------------------------
endif
#---------------------------------------------------------------------------------
