# Sugarcane Enterprise 项目开发计划书

## 1. 项目愿景 (Vision)
构建 "Agri-OS" 农业操作系统，通过无人机 AI、物联网 (IoT) 和数字孪生技术，实现甘蔗种植的现代化、智能化管理。

## 2. 架构概览 (Architecture)
*基于 `main/X.md` 规划*

- **边缘层 (Edge)**: DJI 无人机,树莓派 Zero 2 (多光谱), Android 终端 (FieldMate)。
- **核心层 (Core)**: Java Spring Boot 后端 (负责业务编排与调度)。
- **AI 层 (Brain)**: Python 计算节点 (YOLO 病害识别, NDVI 分析, 路径规划)。
- **数据层 (Data)**: PostGIS (地理信息), MinIO (对象存储), VectorDB (知识库), Redis (消息流)。
- **孪生层 (Twin)**: UE5 + Cesium (元宇宙级可视化)。

---

## 3. 开发时间表 (Timeline)

### 第一周：地基与核心 (当前阶段)
*   **目标**: 跑通全链路数据流（App -> Java -> Python -> DB）。
*   **进度**:
    *   [x] Day 1: 基础设施搭建 (Docker, Git, Repo)。
    *   [ ] Day 2-3: Java 后端初始化，连接数据库与 MQTT。
    *   [ ] Day 4-5: Python 环境配置，跑通 YOLOv8 Demo。

### 第二周：移动端与 AI 深化
*   **目标**: 实现无人机控制逻辑与病害识别闭环。
*   **任务**:
    *   Android 端集成 DJI SDK v5，实现基础遥测数据回传。
    *   Python 端实现 NDVI 图像处理算法。
    *   Java 端实现 LiteFlow 规则编排。

### 第三周：数字孪生与可视化
*   **目标**: 在 UE5 中看到甘蔗地。
*   **任务**:
    *   UE5 集成 Cesium，加载卫星底图。
    *   通过 WebSocket 接收并展示无人机实时位置。

### 第四周：系统集成与实测
*   **目标**: 联调与现场测试。
*   **任务**:
    *   真机飞行测试。
    *   全系统压力测试。

---

## 4. 详细任务清单 (Master Checklist)

### ✅ 第一阶段：基础设施 (Completed)
- [x] **Git 仓库**: 建立主/副仓库并同步 GitHub。
- [x] **目录结构**: 完成 Monorepo 骨架搭建。
- [x] **Docker 服务**:
    - [x] PostgreSQL + PostGIS (地理数据库)
    - [x] Redis (消息缓存)
    - [x] MinIO (对象存储)
    - [x] Mosquitto (MQTT Broker)
    - [x] Ollama (本地 LLM)

### 🏗️ 第二阶段：业务中台 (`sugarcane-core`)
- **技术栈**: Java 17, Spring Boot 3.2
- [ ] **项目初始化**: 验证 Maven 依赖与构建。
- [ ] **数据层开发**:
    - [ ] 配置 JPA 连接 PostGIS。
    - [ ] 设计其实体类 (Entity)如 `Plot`(地块), `Mission`(任务)。
- [ ] **通信层开发**:
    - [ ] 集成 MQTT Client，实现指令下发。
    - [ ] 集成 WebSocket (Netty)，实现前端实时推送。
- [ ] **业务编排**:
    - [ ] 引入 LiteFlow，编写 "病害识别流程" 规则文件。

### 🧠 第三阶段：智能大脑 (`sugarcane-brain`)
- **技术栈**: Python 3.10
- [ ] **环境搭建**: 创建 venv，安装 `ultralytics`, `opencv`, `rasterio`。
- [ ] **视觉服务**:
    - [ ] 封装 YOLOv8 推理接口 (接收图片 -> 返回坐标)。
    - [ ] 开发 NDVI 图像合成脚本。
- [ ] **路径规划**:
    - [ ] 基于 NetworkX 实现覆盖路径规划算法 (CPP)。
- [ ] **任务监听**:
    - [ ] 监听 Redis Stream，自动消费 Java 发来的计算任务。

### 📱 第四阶段：移动终端 (`sugarcane-mobile`)
- **技术栈**: Android, DJI SDK v5
- [ ] **工程搭建**: 配置 Gradle 与 DJI 依赖。
- [ ] **地图集成**: 接入 Mapbox SDK。
- [ ] **为了 "Protocol Omega"**:
    - [ ] 开发拦截器，注入自定义 HTTP Header。
    - [ ] 实现 Tus 断点续传客户端。

### 🌍 第五阶段：数字孪生 (`sugarcane-twin`)
- **技术栈**: UE5.3, Cesium
- [ ] **场景搭建**: 创建 UE5 工程，启用 Cesium 插件。
- [ ] **数据对接**: 编写 C++ 或蓝图通过 WebSocket 接收坐标。
- [ ] **VR 交互**: 适配 OpenXR 手柄控制。

---

## 5. 版本策略 (Versioning)
- **Monorepo**: 所有子项目统一在一个 Git 仓库中管理。
- **分支模型**:
    - `main`: 稳定发布分支。
    - `dev`: 日常开发分支。
    - `feat/xyz`: 特定功能分支 (如 `feat/yolo-upgrade`)。
