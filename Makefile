#######################################
### CORE
#######################################
RM 				:= rm -f
RMDIR 			:= rm -rf
MKDIR 			:= mkdir -p
TOUCH 			:= touch

BIN 			:= main
MAKEFLAGS 		:= 
LDFLAGS 		:= 

BINDIR 			:= bin
OBJDIR 			:= build
SRCDIR 			:= src
EXTDIR			:= external
INCDIR 			:= include
LIBDIR 			:= libs
DATADIR 		:= data
TESTDIR 		:= tests

BINEXT 			:= 
SRCEXT 			:= .cpp .c

# Options: debug release
BUILD 			:= debug
# Options: unix web windows
TARGET 			:= unix
FATAL 			:= false

LIBRARIES 		:= 

#######################################
### LIBRARY CONFIGS
#######################################


#######################################
### HOST OS
#######################################
# Linux is default
CC 				:= clang
CXX 			:= clang++
# CFLAGS are used in c and cpp builds
CFLAGS 			:= -MMD -MP
CXXFLAGS 		:= -std=c++20
# -MMD 				provides dependency information (header files) for make in .d files 
# -pg 				ADD FOR gprof analysis TO BOTH COMPILE AND LINK COMMAND!!
# -MJ 				CLANG ONLY: compile-database
# -MP 				Multi-threaded compilation
# -Wfatal-errors 	Stop at first error

USRDIR 		:= /usr


#######################################
### BUILD CONFIGS
#######################################
ifeq ($(BUILD),debug)
CFLAGS 		+= -g -ggdb -O0 -Wall -Wextra -Wshadow -Werror -Wpedantic -pedantic-errors -DDEBUG
endif

ifeq ($(BUILD),release)
CFLAGS 		+= -O2 -DNDEBUG
endif

ifeq ($(FATAL),true)
CFLAGS 		+= -Wfatal-errors
endif


#######################################
### TARGET PLATFORM
#######################################


#######################################
### AUTOMATIC VARIABLES
#######################################
SRCS 			:= $(foreach e,\
					$(shell find $(SRCDIR) -type f),\
					$(filter $(addprefix %,$(SRCEXT)),\
						$e))
OBJS 			:= $(SRCS:%=$(OBJDIR)/$(BUILD)/$(TARGET)/%.o)
DEPS 			:= $(OBJS:.o=.d)

USRDIRS 		:= $(USRDIR) $(patsubst %,%/local,$(USRDIR))
LIBDIRS 		+= $(patsubst %,%/lib,$(USRDIRS))
ifneq ($(LIBDIR),)
LIBDIRS 		+= $(shell find $(LIBDIR) -type d)
endif
INCDIRS 		:= $(shell find $(SRCDIR) -type d)
ifneq ($(INCDIR),)
INCDIRS 		+= $(shell find $(INCDIR) -type d)
endif
INCDIRSSYS		+= $(LIBDIRS)

INCFLAGS 		:= $(addprefix -I,$(INCDIRS))
INCFLAGS 		+= $(addprefix -isystem,$(INCDIRSSYS))
LDFLAGS 		:= $(addprefix -L,$(LIBDIRS))
LDLIBS 			+= $(addprefix -l,$(LIBRARIES))


#######################################
### Targets
#######################################
.PHONY: all cppcheck build compiledb clean debug setup release run

all: debug release

cppcheck:
	@$(MKDIR) $(OBJDIR)/cppcheck
	@cppcheck \
		--quiet \
		--enable=all \
		--suppress=missingIncludeSystem \
		--suppress=missingInclude \
		--suppress=selfAssignment \
		--suppress=cstyleCast \
		--suppress=unmatchedSuppression \
		--inconclusive \
		--check-level=exhaustive \
		--error-exitcode=1 \
		--cppcheck-build-dir=$(OBJDIR)/cppcheck \
		--template=gcc \
		-I include/ \
		-I src/ \
		src/

build: $(BINDIR)/$(BUILD)/$(TARGET)/$(BIN)$(BINEXT)

compiledb:
	$(info )
	$(info === Build compile_commands.json ===)
	@compiledb -n make debug

clean:
	$(info )
	$(info === CLEAN ===)
	$(RMDIR) $(OBJDIR)/* $(BINDIR)/*

debug: compiledb
	@$(MAKE) BUILD=debug build
	@$(MAKE) cppcheck

setup:
	$(MKDIR) data include lib src
	$(TOUCH) src/main.cpp

release: 
	@$(MAKE) BUILD=release build

run:
	$(BINDIR)/$(BUILD)/$(TARGET)/$(BIN)$(BINEXT)


#######################################
### Rules
#######################################
# === COMPILER COMMAND ===
# cpp files
$(OBJDIR)/$(BUILD)/$(TARGET)/%.cpp.o : %.cpp
	$(info )
	$(info === Compile: TARGET=$(TARGET), BUILD=$(BUILD) ===)
	@$(MKDIR) $(dir $@)
	$(CXX) -o $@ -c $< $(CFLAGS) $(CXXFLAGS) $(INCFLAGS)

# c files
$(OBJDIR)/$(BUILD)/$(TARGET)/%.c.o : %.c
	$(info )
	$(info === Compile: TARGET=$(TARGET), BUILD=$(BUILD) ===)
	@$(MKDIR) $(dir $@)
	$(CC) -o $@ -c $< $(CFLAGS) $(INCFLAGS)


# === LINKER COMMAND ===
# unix bin
$(BINDIR)/$(BUILD)/$(TARGET)/$(BIN)$(BINEXT): $(OBJS)
	$(info )
	$(info === Link: TARGET=$(TARGET), BUILD=$(BUILD) ===)
	@$(MKDIR) $(dir $@)
	$(CXX) -o $@ $^ $(CFLAGS) $(CXXFLAGS) $(LDFLAGS) $(LDLIBS) 


### "-" surpresses error for initial missing .d files
-include $(DEPS)
