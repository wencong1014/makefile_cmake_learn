# all:
# 	gcc -E src/test.c -o obj/test.i
# 	gcc -S obj/test.i -o obj/test.s
# 	gcc -c obj/test.s -o obj/test.o
# 	gcc obj/test.o -o obj/test

# clean:
# 	rm -f obj/test.*
# 	rm -f obj/test.*

################################# 简单版 Makefile ######################################
# 编译器设置
# CXX = g++
# CXXFLAGS = -Wall _Wextra -std=c++11 -I./inc

# # 目标文件
# TARGET = math_app
# TEST_TARGET = math_test

# # 源文件
# MAIN_SRCS = src/main.cpp src/math_utils.cpp
# TEST_SRCS = tests/test_math.cpp src/math_utils.cpp

# # 对象文件
# MAIN_OBJS = $(MAIN_SRCS:.cpp=.o)
# TEST_OBJS = $(TEST_SRCS:.cpp=.o)

# # 默认目标
# all: $(TARGET) $(TEST_TARGET)

# # 主程序
# $(TARGET): $(MAIN_OBJS)
# 		$(CXX) $(CXXFLAGS) -o $@ $^

# # 测试程序
# $(TEST_TARGET): $(TEST_OBJS)
# 		$(CXX) $(CXXFLAGS) -o $@ $^

# # 生成对象文件
# %.o: %.cpp
# 		$(CXX) $(CXXFLAGS) -c $< -o $@

# # 清理
# clean: 
# 		rm -f $(MAIN_OBJS) $(TEST_OBJS) $(TARGET) $(TEST_TARGET)

# # 运行测试
# test: $(TEST_TARGET)
# 		./$(TEST_TARGET)

# # 运行主程序
# run: $(TARGET)
# 		./$(TARGET)

# # 显示帮助
# help:
# 		@echo "可用命令:"
# 		@echo "  make all     - 编译所有目标"
# 		@echo "  make clean   - 清理生成的文件"
# 		@echo "  make test    - 编译并运行测试"
# 		@echo "  make run     - 编译并运行主程序"
# 		@echo "  make help    - 显示此帮助信息"

# # 伪目标
# .PHONY: all clean test run help


######################################### 高级版 Makefile ####################################
# 定义编译器
CXX = g++	

# 定义编译选项：显示所有警告、额外警告、使用C++11标准、包含头文件路径、生成依赖文件
CXXFLAGS = -Wall -Wextra -std=c++11 -I./inc -MMD -MP

# 链接选项，当前为空
LDFLAGS = 

# 定义源文件目录和测试目录
SRC_DIR = src
TEST_DIR = tests
OBJ_DIR = obj
DIST_DIR = dist

# 最终目标
TARGET = $(DIST_DIR)/math_app	# 主程序最终生成的可执行文件路径
TEST_TARGET = $(DIST_DIR)/math_test	# 测试程序的可执行文件路径

# 使用通配符查找所有源文件
MAIN_SRCS = $(wildcard $(SRC_DIR)/*.cpp)
# 测试源文件：所有tests目录下的cpp文件，以及除主程序外的源文件（过滤掉main.cpp）
TEST_SRCS = $(wildcard $(TEST_DIR)/*.cpp) $(filter-out $(SRC_DIR)/main.cpp, $(MAIN_SRCS))

# 将源文件列表中的.cpp文件替换为obj目录下的.o文件（对象文件）
MAIN_OBJS = $(MAIN_SRCS:$(SRC_DIR)/%.cpp=$(OBJ_DIR)/%.o)
# 同理，测试对象文件
TEST_OBJS = $(filter-out $(OBJ_DIR)/main.o, $(MAIN_OBJS))
# TEST_OBJS = $(filter-out $(OBJ_DIR)/main.o, $(MAIN_OBJS)) $(patsubst $(TEST_DIR)/%.cpp, $(OBJ_DIR)/tests/%.o, $(wildcard $(TEST_DIR)/*.cpp))
# 依赖文件，每个.o文件对应一个.d文件，里面记录了该源文件的头文件依赖
# DEPS = $(MAIN_OBJS:.o=.d) $(TEST_OBJS:.o=.d)
DEPS = $(MAIN_OBJS:.o=.d) #$(patsubst $(TEST_DIR)/%.cpp, $(OBJ_DIR)/%.d, $(wildcard $(TEST_DIR)/*.cpp))

# 包含所有的依赖文件，如果存在的话。减号表示如果文件不存在也不报错
-include $(DEPS)

# 默认目标：构建主程序和测试程序
all: $(TARGET) $(TEST_TARGET)

# 链接主程序：依赖所有主程序的对象文件，生成可执行文件
$(TARGET): $(MAIN_OBJS)
	@mkdir -p $(dir $@)    # 确保目标目录存在
	$(CXX) $(CXXFLAGS) $^ -o $@ $(LDFLAGS)

# 链接测试程序：依赖所有测试对象文件，生成测试可执行文件，如果$(OBJ_DIR)/test_math.o不存在，则会尝试去生成它（如果有规则的话）
# $(TEST_TARGET): $(filter-out $(OBJ_DIR)/main.o, $(MAIN_OBJS)) $(OBJ_DIR)/tests/test_math.o
$(TEST_TARGET): $(filter-out $(OBJ_DIR)/main.o, $(MAIN_OBJS)) $(OBJ_DIR)/test_math.o
	@mkdir -p $(dir $@)    # 确保目标目录存在
	$(CXX) $(CXXFLAGS) $^ -o $@ $(LDFLAGS)

# 编译规则：将.cpp文件编译成.o文件，同时生成依赖文件
# $< 表示第一个依赖（即源文件），$@ 表示目标文件（即对象文件）
# 编译命令中的 -MMD -MP 会自动生成.d依赖文件，其中包含该.cpp文件依赖的头文件
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	@mkdir -p $(dir $@)    # 确保目标目录存在
	$(CXX) $(CXXFLAGS) -c $< -o $@

# $(OBJ_DIR)/tests/%.o: $(TEST_DIR)/%.cpp 
$(OBJ_DIR)/%.o: $(TEST_DIR)/%.cpp 
	@mkdir -p $(dir $@)    # 确保目标目录存在
	$(CXX) $(CXXFLAGS) -c $< -o $@

# 清理命令：删除构建目录和生成的可执行文件
clean:
	rm -rf $(DIST_DIR)/* $(OBJ_DIR)/*

# 测试命令：先构建测试程序，然后运行
test: $(TEST_TARGET)
	@echo "Running tests..."
	@./$(TEST_TARGET)

# 运行主程序：先构建主程序，然后运行
run: $(TARGET)
	@echo "Running program..."
	@./$(TARGET)

# 调试模式：增加调试信息，关闭优化
debug: CXXFLAGS += -g -O0
debug: clean all

# 发布模式：优化等级3，定义NDEBUG宏（可能会关闭assert等）
release: CXXFLAGS += -O3 -DNDEBUG
release: clean all

# 声明伪目标：这些目标并不代表一个文件，只是执行一系列命令
.PHONY: all clean test run debug release
