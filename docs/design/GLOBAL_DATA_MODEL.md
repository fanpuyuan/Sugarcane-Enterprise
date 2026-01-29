# 🗺️ 全局数据模型图谱 (Global Data Model)

> **设计原则**: 从宏观到微观。先看清实体间的关系 (ERD)，再扣表结构细节 (DDL)。

## 🌌 宏观实体关系图 (The Macro ERD)

```mermaid
erDiagram
    %% Core Domain
    PLOT ||--o{ MISSION : "has history of"
    PLOT {
        long id PK
        geometry boundary "PostGIS Polygon"
        string owner
    }
    
    %% Fleet Domain (机队)
    DRONE ||--o{ MISSION : "executes"
    DRONE ||--o{ MAINTENANCE_LOG : "has"
    DRONE ||--o{ BATTERY : "mounts"
    DRONE {
        string sn PK
        enum status "IDLE,BUSY,MAINTAIN" 
    }
    
    %% Auth Domain (权限)
    USER ||--o{ MISSION : "creates"
    USER }|--|{ ROLE : "has"
    ROLE }|--|{ PERMISSION : "grants"
    USER {
        string username
        boolean is_admin
    }
    
    %% Mission Domain (核心业务)
    MISSION ||--o{ TELEMETRY : "generates track"
    MISSION ||--o{ DETECTION : "finds issues"
    MISSION {
        long id PK
        enum type "INSPECT, SPRAY"
        geometry breakpoint "Last pos"
    }

    %% Satellite Domain (宏观感知)
    SATELLITE_IMG ||--|{ NDVI_RECORD : "produces"
    SATELLITE_IMG }|--|| PLOT : "covers"
    SATELLITE_IMG {
        string tile_id
        float cloud_cover
    }

    %% Rule Domain (规则与排班)
    SCHEDULE_TASK ||--o{ MISSION : "spawns"
    SCHEDULE_TASK ||--|| FLOW_CHAIN : "uses logic"
    FLOW_CHAIN {
        string chain_id
        xml content "LiteFlow rules"
    }

```

---

## 🔬 微观领域划分 (Micro Domains)

### 1. 核心资产域 (Core Domain)
*   **Plot (地块)**: 一切的基石。
*   **Mission (任务)**: 将人、机、地连接起来的动态过程。

### 2. 资源守护域 (Resource Domain)
*   **Drone (无人机)**: 不只是设备，是需要维护的资产。
*   **Battery (电池)**: 消耗品，生命周期管理。

### 3. 感知智能域 (Intelligence Domain)
*   **Satellite (卫星)**: 宏观视角，发现问题区域。
*   **Detection (识别)**: 微观视角，YOLO 发现具体病害。

### 4. 规则调度域 (Orchestration Domain)
*   **Schedule (排班)**: 什么时候飞？
*   **FlowChain (规则)**: 飞的时候听谁的？(Protocol Omega)
