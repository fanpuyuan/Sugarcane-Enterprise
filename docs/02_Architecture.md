# 02. 技术架构 (System Architecture)

> **核心理念**: 感知 (Edge) -> 认知 (Brain) -> 决策 (Core) -> 行动 (Twin/Edge)

---

## 🏗️ 1. 系统架构图 (Architecture)

```mermaid
graph TD
    %% 样式
    classDef edge fill:#e1f5fe,stroke:#01579b
    classDef core fill:#e8f5e9,stroke:#2e7d32
    classDef ai fill:#f3e5f5,stroke:#7b1fa2

    subgraph Edge [边缘侧: 眼睛与手]
        Drone[🚁 DJI 无人机]:::edge
        FieldMate[📱 Android 终端]:::edge
    end

    subgraph Cloud [云端/服务器: 大脑]
        Gateway[📡 MQTT 网关]:::core
        Java[☕ Java 业务中台]:::core
        DB[(🗄️ PostGIS/MinIO)]:::core
        AI[🧠 Python AI 算力]:::ai
        Redis[📨 消息队列]:::ai
    end

    %% 数据流
    Drone -->|1. 遥测数据| Gateway
    Gateway -->|2. 实时流| Java
    Drone -->|3. 高清图/视频| DB
    Java -->|4. 分析任务| Redis
    Redis -->|5. 消费任务| AI
    AI -->|6. 识别结果| DB
```

---

## 🛠️ 2. 技术栈清单 (Tech Stack)

### 2.1 后端核心 (`sugarcane-core`)
*   **Framework**: Spring Boot 3.2 (Java 17)
*   **Database**: PostgreSQL 16 + PostGIS (地理信息)
*   **Protocol**: MQTT (Mosquitto), HTTP/REST

### 2.2 AI 算力 (`sugarcane-brain`)
*   **Runtime**: Python 3.10
*   **Vision**: Ultralytics YOLOv8, OpenCV
*   **GIS**: Rasterio (NDVI 处理)

### 2.3 移动端 (`sugarcane-mobile`)
*   **OS**: Android (Kotlin)
*   **Hardware SDK**: DJI Mobile SDK v5
*   **Map**: Mapbox SDK

---

## 🔄 3. 核心数据流 (Data Flow)

### 场景：病害识别闭环
1.  **采集**: 无人机拍摄 4K 照片 -> 上传 MinIO 对象存储。
2.  **触发**: Java 收到上传通知 -> 写入 Redis 任务队列。
3.  **分析**: Python 监听队列 -> 下载图片 -> YOLO 推理 -> 生成 JSON 结果。
4.  **归档**: Python 将病害坐标写入 PostGIS 数据库。
5.  **展示**: Android 请求 API -> 在地图上绘制红色病害区域。
