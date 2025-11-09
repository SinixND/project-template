#######################################
### CORE
#######################################
BIN 			:= main
MAKEFLAGS 		:= --no-print-directory
LD_FLAGS 		:= -lpthread #-fsanitize=address

BIN_DIR 		:= bin
OBJ_DIR 		:= build
SRC_DIR 		:= src
INC_DIR 		:= include
LIB_DIR 		:= libs
EXT_DIR			:= external
DATA_DIR 		:= data
TEST_DIR 		:= tests

BIN_EXT 		:= 
SRC_EXT 		:= .cpp .c

# Options: debug release
BUILD 			:= debug
# Options: unix web windows
TARGET 			:= unix
FATAL 			:= false
TYPE			:= exe

LIBRARIES 		:= raylib
RAYLIB_SRC_DIR 	+= $(EXT_DIR)/raylib/src

#######################################
### PROJECT SPECIFIC
#######################################
### RAYLIB
INC_DIRS_SYS 			+= $(RAYLIB_SRC_DIR)

ifeq ($(TARGET),windows)
LIB_DIRS 			+= $(RAYLIB_SRC_DIR)
else
ifeq ($(TARGET),web)
ifeq ($(BUILD),debug)
LIB_DIRS 	+= $(RAYLIB_SRC_DIR)/lib/web/debug
else
LIB_DIRS 	+= $(RAYLIB_SRC_DIR)/lib/web/release
endif
else
ifeq ($(BUILD),debug)
LIB_DIRS 	+= $(RAYLIB_SRC_DIR)/lib/desktop/debug
else
LIB_DIRS 	+= $(RAYLIB_SRC_DIR)/lib/desktop/release
endif
endif
endif

ifeq ($(TARGET),web)
# LD_FLAGS 			+= --preload-file $(DATA_DIR)/ -sUSE_GLFW=3
ifeq ($(BUILD),debug)
LD_FLAGS 			+= --shell-file $(RAYLIB_SRC_DIR)/shell.html
else
LD_FLAGS 			+= --shell-file $(RAYLIB_SRC_DIR)/minshell.html
endif
endif



#######################################
### HOST OS
#######################################
# Linux is default
CC 				:= clang
CXX 			:= clang++
C_FLAGS 		:= -MMD -MP
CXX_FLAGS 		:= -std=c++20 $(C_FLAGS)
# -MMD 				provides dependency information (header files) for make in .d files 
# -pg 				ADD FOR gprof analysis TO BOTH COMPILE AND LINK COMMAND!!
# -MJ 				CLANG ONLY: compile-database
# -MP 				Multi-threaded compilation
# -Wfatal-errors 	Stop at first error

USR_DIR 		:= /usr

ifdef TERMUX_VERSION
CXX_FLAGS 		+= -DTERMUX
USR_DIR 		:= $(PREFIX)
ifeq ($(TARGET),unix)
LIBRARIES 		+= log
endif
endif


#######################################
### BUILD CONFIGS
#######################################
ifeq ($(BUILD),debug)
CXX_FLAGS 		+= -g -ggdb -O0 -Wall -Wextra -Wshadow -Werror -Wpedantic -pedantic-errors -DDEBUG
endif

ifeq ($(BUILD),release)
CXX_FLAGS 		+= -O2 -DNDEBUG
endif

ifeq ($(FATAL),true)
CXX_FLAGS 		+= -Wfatal-errors
endif


#######################################
### TARGET PLATFORM
#######################################
### WEB/EMSCRIPTEN
ifeq ($(TARGET),web)
CC 				:= emcc
C_FLAGS			+= -Os -DEMSCRIPTEN -DPLATFORM_WEB
CXX 			:= em++
CXX_FLAGS		+= -Os -DEMSCRIPTEN -DPLATFORM_WEB
BIN_EXT			:= .html
USR_DIR			:= 
endif

### WINDOWS
ifeq ($(TARGET),windows)
CC 				:= x86_64-w64-mingw32-gcc
CXX 			:= x86_64-w64-mingw32-g++
BIN_EXT			:= .exe
USR_DIR			:= $(USR_DIR)/x86_64-w64-mingw32
LD_FLAGS 		+= -static -static-libgcc -static-libstdc++
endif

#######################################
### Automatic variables
#######################################
SRCS 			:= $(foreach e,\
					$(shell find $(SRC_DIR) -type f),\
					$(filter $(addprefix %,$(SRC_EXT)),\
						$e))
OBJS 			:= $(SRCS:%=$(OBJ_DIR)/$(BUILD)/$(TARGET)/%.o)
DEPS 			:= $(OBJS:.o=.d)

USR_DIRS 		:= $(USR_DIR) $(patsubst %,%/local,$(USR_DIR))
LIB_DIRS 		+= $(patsubst %,%/lib,$(USR_DIRS))
LIB_DIRS 		+= $(shell find $(LIB_DIR) -type d)
# INC_DIRS 		:= $(shell find $(SRC_DIR) $(INC_DIR) -type d)
# INC_DIRS_SYS	+= $(LIB_DIRS)

INC_FLAGS 		:= $(addprefix -I,$(INC_DIRS))
INC_FLAGS 		+= $(addprefix -isystem,$(INC_DIRS_SYS))
LIB_FLAGS 		:= $(addprefix -L,$(LIB_DIRS))
LD_FLAGS 		+= $(addprefix -l,$(LIBRARIES))


#######################################
### Targets
#######################################
.PHONY: all analyze build cdb clean debug host init publish release run web windows

all: debug release

analyze:
	@mkdir -p $(OBJ_DIR)/cppcheck
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
		--cppcheck-build-dir=$(OBJ_DIR)/cppcheck \
		--template=gcc \
		-I include/ \
		-I src/ \
		src/

build: $(BIN_DIR)/$(BUILD)/$(TARGET)/$(BIN)$(BIN_EXT)

cdb:
	$(info )
	$(info === Build compile_commands.json ===)
	@compiledb -n make

clean:
	$(info )
	$(info === CLEAN ===)
	rm -r $(OBJ_DIR)/* $(BIN_DIR)/*

debug: cdb
	@$(MAKE) BUILD=debug build
	@$(MAKE) analyze

host:
	http-server -o . -c-1

init:
	mkdir -p data include lib src
	touch src/main.cpp

publish: 
	@$(MAKE) debug release web windows -j

release: 
	@$(MAKE) BUILD=release build

run:
	$(BIN_DIR)/$(BUILD)/$(TARGET)/$(BIN)$(BIN_EXT)

web:
	@$(MAKE) BUILD=release TARGET=web build

windows:
	@$(MAKE) BUILD=release TARGET=windows build


#######################################
### Rules
#######################################
# === COMPILER COMMAND ===
# cpp files
$(OBJ_DIR)/$(BUILD)/$(TARGET)/%.cpp.o : %.cpp
	$(info )
	$(info === Compile: TARGET=$(TARGET), BUILD=$(BUILD) ===)
	@mkdir -p $(dir $@)
	$(CXX) -o $@ -c $< $(CXX_FLAGS) $(INC_FLAGS)

# c files
$(OBJ_DIR)/$(BUILD)/$(TARGET)/%.c.o : %.c
	$(info )
	$(info === Compile: TARGET=$(TARGET), BUILD=$(BUILD) ===)
	@mkdir -p $(dir $@)
	$(CC) -o $@ -c $< $(C_FLAGS) $(INC_FLAGS)


# === LINKER COMMAND ===
# unix bin
$(BIN_DIR)/$(BUILD)/$(TARGET)/$(BIN)$(BIN_EXT): $(OBJS)
	$(info )
	$(info === Link: TARGET=$(TARGET), BUILD=$(BUILD) ===)
	@mkdir -p $(dir $@)
	$(CXX) -o $@ $^ $(CXX_FLAGS) $(LIB_FLAGS) $(LD_FLAGS) 


### "-" surpresses error for initial missing .d files
-include $(DEPS)
