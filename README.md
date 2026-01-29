# 🌾 Sugarcane Enterprise (Agri-OS)

> **The Next-Gen Operating System for Precision Agriculture.**
> *感知 (Perception) · 决策 (Cognition) · 行动 (Action)*

![Status](https://img.shields.io/badge/Status-Architecture_Design-blue) ![Protocol](https://img.shields.io/badge/Protocol-Omega-red) ![Tech](https://img.shields.io/badge/Stack-Spring_%7C_Python_%7C_UE5-green)

---

## 📖 核心文档 (Documentation)
请优先阅读 `docs/` 目录下的三本白皮书：

1.  **[01_Requirements.md](docs/01_Requirements.md)** - **要做什么？** (Roadmap, 需求列表)
2.  **[02_Architecture.md](docs/02_Architecture.md)** - **怎么做？** (Protocol Omega, 系统架构图)
3.  **[03_Guide.md](docs/03_Guide.md)** - **怎么跑？** (Docker 部署, 开发手册)
4.  **[SCENARIO_PLAYBOOK.md](docs/design/SCENARIO_PLAYBOOK.md)** - **业务剧本** (核心逻辑推演验证)

---

## 🏗️ 系统架构 (Architecture)

```mermaid
graph TB
    %% ================= 配色定义 =================
    classDef edge fill:#fff3e0,stroke:#ef6c00,stroke-width:2px
    classDef core fill:#e3f2fd,stroke:#1565c0,stroke-width:3px
    classDef ai fill:#e8f5e9,stroke:#2e7d32,stroke-width:2px
    classDef meta fill:#fffde7,stroke:#fbc02d,stroke-width:2px

    %% 1. 边缘感知层 (Edge): Eyes & Hands
    subgraph Layer_Edge ["🚜 边缘感知层 (Edge Layer)"]
        direction TB
        subgraph Drone_System ["无人机系统"]
            DJI_Manual["🎮 飞手手动版 (Pilot Mode)"]:::edge
            DJI_Auto["🤖 Protocol Omega 版 (Auto Mode)"]:::edge
        end
        Pi["🍓 RPi Zero 2<br>(NDVI 光谱 / 独立GPS)"]:::edge
        subgraph App ["📱 FieldMate 终端"]
            Tus["🔄 Tus 断点续传"]:::edge
            MapSDK["🗺️ 离线地图"]:::edge
        end
    end

    %% 2. 业务编排层 (Core): The Brain (Left Hemisphere)
    subgraph Layer_Core ["🧠 业务编排中台 (Java Core)"]
        Gateway["🛡️ Nginx 网关"]:::core
        subgraph Orchestrator ["🧩 LiteFlow 编排引擎"]
            FlowParser["流程解析"]:::core
            Switch{"🔀 Protocol Omega"}
            Human["🙋‍♂️ 人工审核"]:::core
        end
        MissionMgr["📋 任务资源管理"]:::core
        Mqtt["🚀 MQTT 指令中心"]:::core
    end

    %% 3. 智能算力层 (AI): The Brain (Right Hemisphere)
    subgraph Layer_AI ["⚡ 智能算力工厂 (Python Workers)"]
        subgraph Perception ["👁️ 感知"]
            YOLO["🤖 YOLOv8-OBB<br>(旋转框检测)"]:::ai
            NDVI_Calc["🌈 多光谱合成"]:::ai
        end
        subgraph Decision ["🧠 决策 (Omega Core)"]
            Planner["🗺️ 路径规划"]:::ai
            Shadow["👻 影子模式 (Shadow Mode)<br>(后台验证算法)"]:::ai
        end
        SatAna["🛰️ 卫星遥感分析<br>(Sentinel-2)"]:::ai
    end

    %% 4. 元宇宙层 (Metaverse): The Interface
    subgraph Layer_Meta ["🎮 数字孪生 (UE5 Metaverse)"]
        Cesium["🌍 Cesium 3D"]:::meta
        VR["🥽 VR 沉浸交互"]:::meta
        Dashboard["📊 指挥大屏"]:::meta
    end

    %% 存储底座 (Satellite Source -> DB)
    DB[("🗄️ PostGIS + MinIO + VectorDB")]
    Sat_Source["🛰️ Sentinel-2 API"]:::edge
    
    %% ================= 核心链路 =================
    Sat_Source -->|"定期拉取"| DB --> SatAna
    Drone_System & Pi -->|"采集"| App -->|"Tus (弱网)"| Gateway --> MissionMgr
    MissionMgr -->|"启动 LiteFlow"| Orchestrator --> Perception --> Switch
    Switch -- "Omega" --> Planner
    Switch -- "Shadow" --> Shadow
    Human & Planner --> Mqtt -.->|"MAVLink"| DJI_Auto
    Perception & Planner --> DB --> Cesium
```

Agri-OS 不仅仅是一个管理后台，它是一个 **Cyber-Physical System (CPS)**：

### 1. 🧠 业务编排 (Core)
*   **Tech**: Java 21, Spring Boot 3, LiteFlow
*   **Role**: 系统的左脑。负责任务调度、权限控制 (RBAC)、设备管理 (Fleet)。
*   **Key**: `LiteFlow` 规则引擎支持业务逻辑热更新。

### 2. ⚡ 智能算力 (Brain)
*   **Tech**: Python 3.10, PyTorch, YOLOv8-OBB
*   **Role**: 系统的右脑。负责视觉识别 (倒伏/病害)、卫星多光谱分析 (Sentinel-2)。
*   **Key**: **Protocol Omega** —— 当 AI 置信度极高时，自动接管无人机控制权。

### 3. 🚜 边缘感知 (Edge)
*   **Tech**: Android (FieldMate), DJI Mobile SDK, Raspberry Pi
*   **Role**: 系统的手眼。执行飞行任务，采集 4K 视频与多光谱数据。
*   **Key**: 支持 **Tus 断点续传**，适应山区弱网环境。

### 4. 🎮 数字孪生 (Metaverse)
*   **Tech**: Unreal Engine 5 (UE5), Cesium, VR
*   **Role**: 系统的全息映射。在办公室里通过 VR 实时查看 5 公里外的无人机姿态。

---

## 🚀 快速启动 (Quick Start)

### 1. 启动基础设施
```bash
cd sugarcane-infra
# 1. 配置环境变量
cp .env.example .env
# 2. 启动中间件 (Postgres, Redis, MinIO, EMQX)
docker-compose up -d
```

### 2. 导入数据库
```bash
# 待 SQL 设计完成后执行
docker exec -i sugarcane-postgres psql -U sugarcane -d sugarcane_db < ../docs/design/01_schema_v2.sql
```

---

## 🤝 贡献说明 (Contributing)
目前处于 **Phase 2 (架构设计)** 阶段。
请查看 [Project Board](https://github.com/users/fanpuyuan/projects/2) 领取任务。

*Copyright © 2024 Sugarcane Team. All Rights Reserved.*
