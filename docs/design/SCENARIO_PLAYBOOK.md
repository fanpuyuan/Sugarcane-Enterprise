# 🎭 Agri-OS 全景业务剧本 (The Scenario Playbook)

> **文档定位**: 这是我们的**逻辑验证平台**。在写代码前，所有业务必须在这里跑通。
> **覆盖范围**: 边缘(Edge) -> 连接(Link) -> 大脑(Brain) -> 孪生(Twin) -> 外部(Space)。

---

## 🛰️ 第一幕: 天眼感知 (The Satellite Loop)
*角色: Sentinel-2 卫星, Python Worker, PostGIS, FieldMate App*

### 剧情概要
每周一，卫星扫描农场。系统自动拉取数据，分析 NDVI 植被指数，发现“A区-03”地块似乎变黄了，主动推送预警给农场主。

### 详细推演
```mermaid
sequenceDiagram
    participant ESA as 🛰️ 欧空局 API
    participant Py as 🐍 Python Sat-Worker
    participant DB as �️ PostGIS/MinIO
    participant App as � FieldMate

    Note over ESA: 卫星过顶 (T=0)
    
    loop Every 24 Hours
        Py->>ESA: 查询最新 Tile (Cloud < 20%)
        ESA-->>Py: 返回 GeoTIFF
    end
    
    Note over Py: 1. 数据入库
    Py->>DB: 存原始影像 (MinIO)
    Py->>DB: 存元数据 (satellite_images 表)
    
    Note over Py: 2. 宏观分析
    Py->>Py: 计算 NDVI = (NIR-Red)/(NIR+Red)
    Py->>DB: 写入 ndvi_records 表
    
    Note over Py: 3. 异常挖掘
    Py->>Py: 对比上周数据 -> 发现 NDVI 下降 15%
    Py->>DB: 插入 alerts 表 (Level: WARNING)
    
    Note over App: 4. 终端展示
    App->>DB: 轮询/推送警报
    App->>App: 地图上 A区-03 变红
    App->>User: "是否创建无人机巡检任务?"
```

---

## � 第二幕: 数字孪生 (The Metaverse Loop)
*角色: DJI Drone, MQTT Broker, Spring Core, UE5 Engine, VR Headset*

### 剧情概要
农场主戴上 VR 眼镜，坐在办公室里。此时无人机在 5 公里外作业。他能在 VR 里看到飞机实时位置，不仅是地图上的点，而是**真实的三维模型在飞**，且能看到飞机视角传回的画面。

### 详细推演
```mermaid
sequenceDiagram
    participant DJI as � 实体无人机
    participant MQTT as � MQTT Broker
    participant Java as ☕ Spring Boot
    participant UE5 as 🎮 UE5 数字孪生
    participant VR as 🥽 VR 眼镜

    loop Every 100ms (10Hz)
        DJI->>MQTT: Pub /telemetry (Lat, Lon, Alt, Roll, Pitch, Yaw)
    end
    
    par 数据分流
        MQTT->>Java: 存入时序数据库 (TimescaleDB)
        MQTT->>UE5: Sub /telemetry (WebSocket/TCP)
    end
    
    Note over UE5: 1. 坐标映射
    UE5->>UE5: WGS84 -> UE5 世界坐标
    UE5->>UE5: 驱动 DroneActor 模型位姿更新
    
    Note over UE5: 2. 视场渲染
    UE5->>VR: 渲染双目画面 (OpenXR)
    
    Note over VR: 3. 虚实交互
    VR->>VR: 用户伸手点击飞机模型
    VR->>UE5: 触发 "ShowStatus" 事件
    UE5->>Java: GET /api/drones/1/video_url
    Java-->>UE5: rtsp://...
    UE5->>UE5: 在虚拟空中弹出视频窗口
```

---

## 👻 第三幕: 影子模式 (The Shadow Mode Loop)
*角色: FieldMate (Pilot), Protocol Omega (AI), Mqtt*

### 剧情概要
现在是**人工飞行模式**。飞手在操纵飞机。后台的 AI (Omega) 也在通过摄像头看，它在默默计算“如果是我，我会怎么飞”。如果不一致，它会记录下来用于自我进化。

### 详细推演
```mermaid
sequenceDiagram
    participant Pilot as 👨‍✈️ 飞手 (RC)
    participant Drone as 🚁 无人机
    participant AI as 🧠 Protocol Omega
    participant DB as 🗄️ 影子日志库

    Note over Drone: 实时飞行中
    Drone->>Cloud: 上传 4K 视频流 & 遥测数据
    
    par 并行处理
        Cloud->>Pilot: 视频主要供人看
        Cloud->>AI: 视频喂给 FSD 模型
    end
    
    Note over AI: 1. 模拟决策
    AI->>AI: 识别障碍物 -> 计算规避路线
    AI->>AI: 生成虚拟指令 (Virtual Command)
    
    Note over DB: 2. 差异比对
    DB->>DB: 记录 Human_Command (真实)
    DB->>DB: 记录 AI_Command (虚拟)
    
    alt 差异巨大 (Diff > 30%)
        DB->>DB: 标记为 "Corner Case"
        Note over DB: 这就是宝贵的训练数据!
    end
```

---

## 🚁 第四幕: 机队与场站 (Fleet & Station)
*角色: Drone, Battery Station, Repairman*

*(此处衔接之前的“换机续飞”推演)*

1.  **入库校验**: 飞机归还时，必须扫码入库。系统自动读取 flight_log，发现“电机震动异常”，自动锁定飞机状态为 `MAINTENANCE`，并给维修员发工单。
2.  **电池轮转**: 智能电池柜读取电池循环次数。如果 > 300 次，自动标记“需报废”，禁止被借出。

---

## 📝 剧本总结：缺少的拼图

通过这 4 幕大戏，我们需要补充以下架构实体：

1.  **Satellite Importer**: 需要一个 Python 脚本 `sat_sync.py`，专门对接 Sentinel-2 API。
2.  **UE5 Connector**: 后端需要一个 WebSocket 服务端，专门给 UE5 喂饭。
3.  **Shadow Logger**: 数据库表 `shadow_logs`，专门存 AI 和人的操作差异。
4.  **Battery Health**: 电池不是简单的电量，是全生命周期管理。

**这个全景剧本，是您想要的“工作平台”吗？**
如果是，请批准 `SCENARIO_PLAYBOOK.md`，然后我们按照剧本里的角色分配任务。
