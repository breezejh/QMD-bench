# QMD-Bench——Agent-Driven Cross-Architecture Migration Benchmark 
# QMD-Bench——智能体驱动的跨架构代码迁移 Benchmark


![SOTA大模型智能体在QMD-Bench OpenCV算子测试中的正确情况统计](./doc/评估结果.png)

## 📖 目录 (Table of Contents)

- [OpenCV库级自动迁移评测集](#opencv库级自动迁移评测集)
- [NCNN库级自动迁移评测集](#ncnn库级自动迁移评测集)
- [OpenMP库级自动并行优化工具](#openmp库级自动并行优化工具)
- [FFmpeg库级自动迁移评测集](#ffmpeg库级自动迁移评测集)


---
## OpenCV库级自动迁移评测集

### 项目介绍 (Introduction)

为推动 RISC-V 生态在计算机视觉领域的发展，并探索大模型智能体在跨架构代码迁移中的潜力，我们基于广泛使用的 OpenCV 视觉库，构建了首个 智能体驱动的 OpenCV 跨架构迁移 Benchmark。

本 Benchmark 聚焦于将Opencv的 ARM NEON 向量化代码自动迁移至 RISC-V Vector (RVV) 架构，旨在评估智能体在保持功能正确性的同时，评估其性能优化的能力，为自动化迁移工具提供标准化评估平台。

---

### 为什么需要这个Benchmark？

#### 现状与痛点
尽管 OpenCV 已在 x86 和 ARM 平台上实现了高度优化的向量化后端，但在 RISC-V 平台上，尤其是对 RVV 扩展的支持仍处于早期阶段。手动迁移不仅耗时耗力，还难以保证性能不劣于标量实现。

#### 自动化迁移的价值
自动化代码迁移能显著降低跨平台移植的成本，尤其在 RISC-V 生态快速发展的背景下，具备重要的工程与科研价值。

#### 大模型智能体的机遇
大模型在代码理解与生成任务上展现出强大潜力。本 Benchmark 旨在推动智能体在跨架构、高性能代码迁移任务上的能力边界，加速 RISC-V 视觉应用的落地。

---



本项目面临的挑战不仅仅是指令集的翻译，更在于跨越**硬件架构范式**与**软件工程复杂度**的双重鸿沟。

#### 1. 硬件架构差异

**固定向量长度 vs 可扩展向量架构**

ARM NEON：基于128-bit固定长度向量寄存器，代码中大量硬编码的循环步长（如 `i += 4`）。

RISC-V RVV：采用硬件无关的向量长度(VLEN)，必须将定长循环重构为基于 `vsetvli` 的 Strip-mining 循环。

**迁移挑战**：智能体需要理解从"定长向量化"到"变长向量化"的算法级重构。

**指令集语义鸿沟**

ARM NEON：丰富的向量指令集，如 `vmlaq`（乘加累加）、`vqmovn`（饱和窄化）。

RISC-V RVV：缺乏直接等效指令，需组合多条基础指令实现复杂指令。

**迁移挑战**：智能体需具备指令语义理解能力，进行跨架构的指令重组

**寄存器机制差异**

ARM NEON：向量寄存器与通用寄存器分离，向量指令需显式指定向量寄存器。

RISC-V RVV：向量寄存器与通用寄存器统一，向量指令需显式指定向量长度。

**迁移挑战**：智能体需理解寄存器机制差异，进行寄存器分配与指令重排。

#### 2. 软件工程复杂度

**OpenCV 模块化依赖的广度挑战**

```text
   算子实现    →          模块接口              →          硬件抽象层(HAL)
      ↓                      ↓                                   ↓
  dot_product    hal/riscv-rvv/include/core.hpp  modules/core/src/hal_replacement.hpp
```

- 单个算子迁移可能涉及多个不同模块的接口理解
    
- **迁移挑战**：智能体需要在大规模代码库中准确追踪跨模块依赖关系

**OpenCV 硬件抽象层(HAL)的复杂性**
    
- 同一功能在 HAL 层可能有多个后端实现：NEON、OpenCL、CUDA、纯C++等
        
- 智能体需要识别并专注于特定硬件后端的迁移，避免混淆不同实现
        
- **迁移挑战**：准确理解硬件抽象边界，避免跨抽象层的错误迁移

**宏定义与模板的深度使用**

- OpenCV 代码中广泛使用宏定义与模板，增加了代码理解和迁移的难度

- **迁移挑战**：智能体需要理解并正确处理宏定义与模板，避免代码混淆与错误

**大型开源库结构复杂**
- OpenCV 是一个大型开源库，包含多个模块和子项目，每个模块都有其特定的依赖和实现方式。除此之外，OpenCV多年来由多人协作开发，代码库的写作风格和规范存在很大差异，这使Agent在理解和迁移代码时面临巨大挑战。

#### 3.上下文依赖与幻觉风险

**隐式依赖链的识别**

- 算子实现依赖分散在多个头文件中的类型定义（如 `cv::Size`、`cv::Point`）
        
- 平台特定宏（`CV_NEON`、`CV_SIMD128`）的条件编译逻辑
        
- **迁移挑战**：智能体容易因缺失上下文而"臆造"不存在的API或错误类型
        
**工程配置与构建系统的理解**
- OpenCV 的构建系统复杂，涉及多个编译选项（如 `WITH_OPENCL`、`WITH_CUDA`）

- **迁移挑战**：智能体需要理解并正确配置构建系统，避免编译错误

---

### 与目前代码 Benchmark 的对比 (vs. Related Benchmarks)

本 Benchmark 填补了现有代码评测数据集在 **跨架构迁移 (Cross-Architecture)** 与 **性能优化 (Performance-Optimization)** 交叉领域的空白。

##### 📊 综合对比表 (Comparison Table)

| benchmark |  粒度 | 平均输出行数 | 语言 | 正确性 | 性能 | 跨架构生成 |描述 |
|------------|------|------------|------|--------|--|----|----------------|
| ClassEval | Class-level| <50行 |  Python | ✅ | ❌ | ❌ |类级别的代码生成与评估benchmark | 
| SWE-bench | Repo-level| <50行 | Python | ✅ | ❌ | ❌ |解决真实世界GitHub问题的仓库级benchmark | 
| JavaBench | Repo-level | <100行 | Java | ✅ | ❌ | ❌ |专业级Java开发能力评估benchmark |
| KernelBench | Repo-level | <50行 | CUDA | ✅ | ✅ | ❌ |高性能GPU内核生成能力评估benchmark |
| ParEval |func-level| <50行 | CUDA、C++ | ✅ | ✅ | ❌ | 并行计算程序生成与正确性评估benchmark |
| Swe-Perf |repo-level | ~百行 | Python | ✅ | ✅ | ❌ | 软件仓库中的性能优化与瓶颈修复benchmark |
| cisc-risc |func-level |<200行 | Assembly | ✅ | ❌ | ✅ | cisc-risc汇编代码转译benchmark | 
| **QMD-Bench** | repo-level | ~千行 | C++/Intrinsic | ✅ | ✅ | ✅ |高性能库跨架构迁移与性能优化benchmark | 



##### 核心差异分析 (Key Differentiators)



- **ClassEval、JavaBench、SWE-bench** 等主要关注算法逻辑正确性，缺乏对性能的考量
    
- **Swe-Perf** 虽然涉及性能优化，但局限于算法层面优化，缺乏架构维度优化的考量
  
- **KernelBench** 专注于 GPU 并行计算，但缺乏跨架构迁移维度，且缺乏工程实践性考量

- **cisc-risc** 涉及架构迁移，主要关注汇编代码转译，但只是简单的函数级转译

- **ParEval** 专注于并行计算，但仅关注简单的函数级并行代码的正确性评估
    
- **QMD-Bench** 在库级迁移的同时，全面保证功能正确性、性能优化和跨架构迁移，更贴近工业级迁移需求。
    

---

### 📊 测试集设计与难度分级 (Dataset & Hierarchy)

本 Benchmark 旨在评估 AI Agents 在 OpenCV 跨架构迁移任务中的能力，特别是从 ARM NEON 架构到 RISC-V RVV 架构的代码迁移。通过构建 **算子级 (Operator)**、**应用级 (Application)** 和 **库级 (Library)** 三大维度的评估体系，全面测试 Agents 在代码理解、架构转换和工程实现方面的综合能力。

#### 1. 测试层级设计 (Test Levels)

##### 🟢 Level 1: 算子级 (Operator Level)
评估 Agents 迁移 OpenCV 单个算子的能力，要求能够理解整个 OpenCV 库的结构并生成特定算子的 RISC-V 实现。

**评测目标：**

- 测试 Agent 根据 OpenCV 全库知识，准确定位所有算子实现代码位置
- 完整理解 ARM NEON SIMD 指令逻辑
- 生成对应的 RVV SIMD 实现
- 可成功编译并调用，具有一定性能提升

**测试方案：**
* **功能正确性测试 (Unit Testing)**:
    * 对迁移后的算子进行严格的单元测试。
    * **标准**: 必须通过OpenCV官方的测试用例 (Test Cases)，输出结果需与标量实现按位一致或误差在容许范围内。
* **性能基准测试 (Performance Benchmarking)**:
    * 通过OpenCV官方perf测试用例对比评估迁移后的 RVV 算子性能。
    * **基线 (Baseline)**: RISC-V 标量实现 (Scalar Implementation)。
    * **参考 (Reference)**: 人类专家手工优化的 RVV 算子性能 (Human-Optimized)。

**数据选择：**

基于 OpenCV 官方源码中针对 ARM NEON 的手工实现，手工剔除所有未被真正使用的文件，最终获得 21 个实际使用的核心算子。具体的算子数据见[算子数据](./data/operators.jsonl)。





##### 🟡 Level 2: 应用级 (Application Level)
评估 Agents 在完整应用场景中的迁移能力，需要自主识别所需算子并完成整体迁移。

**评测目标：**

- 根据给定的 OpenCV 示例应用，自动识别涉及的算子
- 自动迁移正确所有相关算子
- 使得该示例应用在 RISC-V 架构上得到性能提升

**测试方案：**

* **算子覆盖测试**: 首先对目标模型涉及的所有算子类型进行单独的单元测试，确保所有迁移算子的功能正确性。

* **端到端性能测试 (E2E Performance)**:
    * 测试整个应用完成固定次数推理所需的总耗时（Latency）。
    * 对比标量实现和人类手工实现的加速比 (Speedup)。

**数据选择：**

选取自 OpenCV 官方 samples 示例集合的14个应用，具体选取标准和应用见[应用数据](./data/applications.jsonl)。


##### 🔴 Level 3: 库级测试 (Library Level)

评估 Agents 迁移整个 OpenCV 库中所有 ARM NEON 算子的能力，这是最高难度的综合性测试。

**评测目标：**

- 完整迁移 OpenCV 库中算子的比例
- 迁移后的库在 RISC-V 架构上能够正常编译和运行
- 迁移后的库在 RISC-V 架构上性能得到提升

**测试方案：**

* **算子覆盖率测试 (Operator Coverage Testing)**:
    * 对 OpenCV 库中所有算子进行覆盖率测试，确定算子被成功迁移的比例。
* **端到端性能测试 (E2E Performance)**:
    * 测试性能加速比 (Speedup)，对比标量实现和人类手工实现的加速比。
---

#### 2. 难度分级标准 (Difficulty Standards)

为了科学评估智能体的能力边界，我们在不同层级设计了细粒度的难度分级。

#### 🧩 算子级难度 (Operator Difficulty)
基于**软件逻辑**与**硬件特性**的双重维度进行分级。
* **依据**: 算子的代码行数、控制流复杂度 (Software) 以及指令吞吐、向量化难度 (Hardware)。
* **数据**: 详细分级请参阅 。


---

### 🧪 测试题目 (Test Cases)

基于上述设计，我们提供了丰富的测试用例集，涵盖从基础算子到复杂模型场景的全面评估。

#### 1. 算子级题目 (Operator Cases)
数据集包含 **21 个 OpenCV核心算子**，旨在覆盖推理关键路径并验证 RVV 向量化加速效果，详见 [算子级题目](./data/operators.jsonl)。主要覆盖：

- 常见图像处理操作（如 blur、sobel、resize 等）
- SIMD 强相关的算术与逻辑处理（add、absdiff、bitwise 等）
- 具有代表性的滤波、卷积、空间变换与颜色变换算子
- 包含归约类算子（如 sum、min_max），测试 RVV 归约能力
- 包含多窗口和非线性滤波操作（如 median_filter、morph）
  
这些算子代表 OpenCV 中最常用也是向量化实现最具典型性的操作，
它们覆盖了跨架构迁移过程中主要挑战（SIMD 内存布局、数据类型、
边界处理、动态向量长度适配等），因此作为 Level 1 的迁移评估标准。


#### 2. 应用级题目 (Model Cases)
Level 2 包含 14 个来自 OpenCV 官方 samples 的典型图像处理应用。每个案例涉及多个算子，要求 Agent 能够识别算子依赖 → 迁移 NEON 实现 → 组合调用 → 完整构建 → 运行效果验证。具体题目见[应用级题目](./data/applications.jsonl)


---

### 📊 基准测试结果 (SoTA Results)

为了深入分析智能体在不同类型算子上的表现，我们提供了核心算子的逐项评测结果。

**OpenHands详细算子通过情况**

| Operator | OpenHands(GPT-5) | OpenHands(gemini-3-pro-preview) | OpenHands(qwen3-coder-480b-a35b-instruct) | OpenHands(gpt-4o)|
|:---|:---:|:---:|:---:|:---:|
| `bitwise` | ✅ | ❌ | ✅ | ❌ |
| `min_max` | ✅ | ✅ | ❌ | ❌ |
| `median_filter` | ❌ | ❌ | ❌ | ❌ |
| `sum` | ✅ | ❌ | ❌ | ❌ |
| `dot_product` | ❌ | ❌ | ❌ | ❌ |
| `blur` | ❌ | ❌ | ❌ | ❌ |
| `separable_filter` | ✅ | ❌ | ❌ | ❌ |
| `morph` | ❌ | ❌ | ❌ | ❌ |
| `sobel` | ❌ | ❌ | ❌ | ❌ |
| `absdiff` | ❌ | ✅ | ❌ | ❌ |
| `add` | ✅ | ✅ | ❌ | ❌ |
| `add_weighted` | ❌ |  ❌| ❌ | ❌ |
| `cmp` | ❌ | ❌ | ❌ | ❌ |
| `mul` | ❌ | ❌ | ❌ |  ❌|
| `sub` | ❌ |❌  | ❌ | ❌ |
| `div` | ❌ | ❌ | ❌ | ❌ |
| `colorconvert` | ❌ | ❌ | ❌ | ❌ |
| `convolution` | ✅ | ❌ | ❌ | ❌ |
| `resize` | ❌ | ❌ | ❌ | ❌ |
| `pyramid` | ❌ | ❌ | ❌ | ❌ |
| `gaussian_blur` | ❌ | ❌ | ❌ | ❌ |


**JoyCode详细算子通过情况**

| Operator | JoyCode(claude-sonnet-4-5-20250929) | JoyCode(gemini-3-pro-preview) | JoyCode(Kimi-K2-0905) |
|:---|:---:|:---:|:---:|
| `bitwise` | ✅ | ✅ | ✅ |
| `min_max` | ✅ | ❌ | ✅ |
| `median_filter` | ❌ | ❌ | ✅ |
| `sum` | ❌ | ❌ | ❌ |
| `dot_product` | ❌ | ❌ | ❌ |
| `blur` | ❌ | ❌ | ❌ |
| `separable_filter` | ✅ | ❌ | ❌ |
| `morph` | ❌ | ❌ | ❌ |
| `sobel` | ✅ | ❌ | ❌ |
| `absdiff` | ❌ |❌  | ❌ |
| `add` | ❌ | ❌ | ❌ |
| `add_weighted` | ❌ |  ❌| ❌ |
| `cmp` | ❌ | ❌ | ❌ |
| `mul` | ❌ | ❌ | ❌ |
| `sub` |❌  | ❌ | ❌ |
| `div` | ❌ | ❌ | ❌ |
| `colorconvert` | ❌ | ❌ | ❌ |
| `convolution` | ✅ | ❌ | ❌ |
| `resize` | ❌ | ❌ | ❌ |
| `pyramid` | ❌ | ❌ | ❌ |
| `gaussian_blur` | ❌ | ❌ | ❌ |


TRAE详细算子通过情况

| Operator | TRAE(Doubao-seed-code) | TRAE(deepseek-v3.1) | TRAE(GLM-4.6) |
|:---|:---:|:---:|:---:|
| `bitwise` | ✅ | ❌ | ❌ |
| `min_max` | ❌ | ❌ | ❌ |
| `median_filter` | ✅ | ❌ | ❌ |
| `sum` | ❌ | ❌ | ❌ |
| `dot_product` | ❌ | ❌ | ❌ |
| `blur` | ❌ | ✅ | ❌ |
| `separable_filter` | ❌ | ❌ | ❌ |
| `morph` | ❌ | ✅ | ❌ |
| `sobel` | ✅ | ❌ | ❌ |
| `absdiff` | ✅ |❌  | ❌ |
| `add` | ✅ | ❌ | ❌ |
| `add_weighted` | ❌ |  ❌| ❌ |
| `cmp` | ✅ | ❌ | ❌ |
| `mul` | ❌ | ❌ | ❌ |
| `sub` |✅  | ❌ | ❌ |
| `div` | ❌ | ❌ | ❌ |
| `colorconvert` | ❌ | ❌ | ❌ |
| `convolution` | ❌ | ✅ | ❌ |
| `resize` | ✅ | ❌ | ❌ |
| `pyramid` | ❌ | ❌ | ❌ |
| `gaussian_blur` | ❌ | ❌ | ❌ |


---

### 🛠️ 使用方法 (Getting Started)

```bash
# 1. Clone the repository
git clone https://github.com/breezejh/QMD-bench.git

# 2. Install dependencies

pip install -r requirements.txt


# 3. Run the benchmark
python run_benchmark.py --target riscv --model gpt-4
  --test_level operator
```
---


## NCNN库级自动迁移评测集

为了促进 RISC-V 基础软件生态繁荣，同时推动学术界和产业界利用智能体（AI Agents）进行跨架构代码迁移的探索，我们基于端侧性能极致优化的 NCNN 推理框架，构建了业界首个智能体驱动的 NCNN 库跨架构迁移 Benchmark。

具体github地址为：[https://github.com/k1366191024/agent-ncnn-benchmark/tree/main](https://github.com/k1366191024/agent-ncnn-benchmark/tree/main)


## OpenMP库级自动并行优化工具

RepoOMP 是一个用于自动化 OpenMP 代码分析和优化的综合框架。它采用三个专门的智能体按顺序工作，以分析依赖关系、测量性能并自动向 C/C++ 代码添加 OpenMP 原语。

具体工具我们正在接入中，敬请期待。

## FFmpeg库级自动迁移评测集

FFmpeg等其他开源高性能库的自动迁移评测集我们正在接入中，敬请期待。
