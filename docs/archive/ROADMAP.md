# 🗺️ Sugarcane Enterprise 全局作战地图 (Roadmap)

> **当前状态**: 🏗️ 基础设施搭建完毕，准备进入核心开发。
> **本周目标**: 跑通 Java 后端与 AI 的核心链路。

---

## 📅 1. 近期必做 (Next 3 Days)
*这是您最关心的“眼下要干什么”。*

*   [ ] **[P0] 数据库建模** (后端): 设计“地块(Plot)”和“任务(Mission)”的表结构。
*   [ ] **[P0] 接口定义** (后端): 确定 Android 和服务器怎么说话 (API)。
*   [ ] **[P1] Android 原型** (前端): 哪怕用手画，也要把“地图页”画出来。
*   [ ] **[P1] YOLO 跑通** (AI): 用 Python 脚本成功识别出一张甘蔗病害图片。

---

## 🧩 2. 模块任务拆解 (Module Breakdown)

### ☕ 后端中心 (sugarcane-core)
> **职责**: 大脑左半球，管逻辑、管数据。

*   [ ] **Project Init**: 初始化 Spring Boot 3 + Maven 工程。
*   [ ] **DB Connectivity**: 配置 JPA + Hibernate Spatial 连接 PostGIS。
*   [ ] **MQTT Integration**: 开发 MQTT 消息监听器，接收无人机心跳。
*   [ ] **Business Logic**: 实现 CRUD (地块增删改查)。
*   [ ] **File Service**: 集成 MinIO SDK，实现图片上传接口。

### 🧠 AI 大脑 (sugarcane-brain)
> **职责**: 大脑右半球，管视觉、管计算。

*   [ ] **Environment**: 配置 Python 3.10 + CUDA 环境。
*   [ ] **Model Service**: 封装 YOLOv8 推理服务 (Flask/FastAPI)。
*   [ ] **Task Consumer**: 监听 Redis 队列，消费分析任务。
*   [ ] **Auto-Training**: 写一个脚本，能自动拿新数据微调模型。

### 📱 移动终端 (sugarcane-mobile)
> **职责**: 农户的手，管操作、管监控。

*   [ ] **UI/UX**: 完成高保真原型设计 (Figma)。
*   [ ] **Map Engine**: 集成 Mapbox，显示卫星地图 + 矢量地块。
*   [ ] **Drone Control**: 集成 DJI MSDK v5，连接遥控器。
*   [ ] **Video Stream**: 实时拉取无人机图传画面。

### 🌍 数字孪生 (sugarcane-twin)
> **职责**: 农户的眼，管宏观、管回溯。

*   [ ] **Scene Setup**: UE5 正确加载真实地理坐标 (Cesium)。
*   [ ] **Data Sync**: 通过 WebSocket 实时接收飞机位置并驱动模型移动。

---

## 🌊 3. 全部任务大池子 (The Backlog)
*这是我们要翻越的所有山头，大致按时间排序。*

| 阶段 | 任务描述 | 状态 |
| :--- | :--- | :--- |
| **Phase 1** | **[Infra] 验证 Docker 基础设施 (DB, MQ, S3)** | ✅ Done |
| **Phase 1** | **[DevOps] 全局 SSH 配置与项目管理看板** | ✅ Done |
| | | |
| **Phase 2** | [Backend] 核心数据库表结构设计 (ERD) | ⏳ Todo |
| **Phase 2** | [Backend] Spring Boot 工程骨架初始化 | ⏳ Todo |
| **Phase 2** | [AI] Python 虚拟环境与 YOLOv8 Hello World | ⏳ Todo |
| **Phase 2** | [Frontend] Android 核心页面原型草图 | ⏳ Todo |
| | | |
| **Phase 3** | [Backend] 实现无人机遥测数据 MQTT 接收 | 💤 Pending |
| **Phase 3** | [Frontend] Android 接入 Mapbox 地图 SDK | 💤 Pending |
| **Phase 3** | [AI] 实现图片病害识别 API | 💤 Pending |
| | | |
| **Phase 4** | [Twin] UE5 加载 Cesium 地形 | 💤 Pending |
| **Phase 4** | [System] 全链路联调 (App->Java->Drone) | 💤 Pending |

---

## 💡 怎么用这份地图？
1.  **迷茫时**：看 **"近期必做"**。
2.  **写代码时**：看 **"模块任务拆解"**。
3.  **开会时**：看 **"全部任务大池子"** 给老板汇报进度。
