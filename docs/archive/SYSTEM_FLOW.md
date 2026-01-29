# Sugarcane Enterprise 系统流转图 (System Flow)

为了让您对“Agri-OS”的运行机理一目了然，我们整理了**信息流 (Data Flow)** 和 **工作流 (Workflow)** 两张核心图纸。

---

## 1. 核心逻辑：闭环 (The Loop)
整个系统的核心是一个闭环：
`感知 (看)` -> `认知 (想)` -> `决策 (管)` -> `行动 (做)`

1.  **Drones/IoT** 看到了甘蔗 (感知)。
2.  **AI** 识别出了病害 (认知)。
3.  **Java Core** 生成了植保任务 (决策)。
4.  **Drones** 起飞喷洒药水 (行动)。

---

## 2. 信息流 (Information Flow)
*数据是如何在网线里流动的？*

```mermaid
graph TD
    %% 定义节点样式
    classDef hardware fill:#e1f5fe,stroke:#01579b,stroke-width:2px
    classDef gateway fill:#fff3e0,stroke:#ef6c00,stroke-width:2px
    classDef core fill:#e8f5e9,stroke:#2e7d32,stroke-width:2px
    classDef ai fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px
    classDef storage fill:#eceff1,stroke:#455a64,stroke-width:2px

    subgraph Edge ["边缘端 (Edge)"]
        Drone[无人机/FieldMate]:::hardware
        Pi[树莓派传感器]:::hardware
    end

    subgraph Infra ["基础设施 (Infra)"]
        MQTT[Mosquitto MQTT]:::gateway
        MinIO[MinIO 对象存储]:::storage
        Redis[Redis 消息队列]:::storage
    end

    subgraph Backend ["后端核心 (Core)"]
        JavaService[Java Spring Boot]:::core
    end

    subgraph Brain ["AI 大脑 (Brain)"]
        PythonWorker[Python YOLOv8]:::ai
    end

    %% 流程连线
    Drone -- "1. 实时遥测数据 (GPS/电量)" --> MQTT
    Drone -- "2. 拍摄照片/视频" --> MinIO
    
    MQTT -- "3. 订阅状态" --> JavaService
    MinIO -- "4. 上传完成事件" --> JavaService
    
    JavaService -- "5. 发布分析任务" --> Redis
    
    Redis -- "6. 领取任务" --> PythonWorker
    PythonWorker -- "7. 下载图片" --> MinIO
    PythonWorker -- "8. 写入分析结果 (病害坐标)" --> Redis
    
    Redis -- "9. 结果回传" --> JavaService
    JavaService -- "10. 存入数据库" --> DB[(PostgreSQL)]:::storage
```

**关键路径解读：**
1.  **快数据 (Hot Data)**：无人机的位置、速度、电量，通过 MQTT 毫秒级传给 Java，实时在屏幕上跳动。
2.  **大笨数据 (Blob Data)**：4K 视频、高 清照片，直接丢进 MinIO 仓库，只把“取货码（URL）”传给后台，避免堵塞网络。
3.  **冷计算 (Cold Calc)**：AI 分析比较慢，所以 Java 把任务丢进 Redis 队列（信箱）就去忙别的了；Python 慢慢处理完，再要把结果塞回信箱。

---

## 3. 工作流 (Workflow)
*用户的一天是如何度过的？*

### 场景：执行全自动巡检与病害清除

```mermaid
sequenceDiagram
    participant User as 👨‍🌾 农场主 (App/Web)
    participant Java as ☕ 业务中台 (Core)
    participant Drone as 🚁 无人机 (Edge)
    participant AI as 🧠 AI 大脑 (Brain)

    %% 阶段 1: 任务下发
    User->>Java: 1. 发起“A区巡检”指令
    Java->>Drone: 2. 生成航点任务 (Waypoints) 并下发 (Via MQTT)
    Drone-->>Java: 3. 确认接收，准备起飞

    %% 阶段 2: 采集与分析
    loop 飞行中
        Drone->>Java: 实时回传位置 (1Hz)
        Drone->>MinIO: 拍摄关键帧图片
        
        par 并行处理
            MinIO-->>AI: 图片就绪
            AI->>AI: YOLOv8 识别病害
            AI-->>Java: 发现锈病 (坐标: X,Y)
        end
    end

    %% 阶段 3: 决策与执行
    Java->>User: 🚨 警报：发现 3 处严重锈病
    User->>Java: 批准“植保作业” (打药)
    Java->>Drone: 动态插入“植保航线”
    Drone->>Drone: 飞往病害点 -> 喷洒 -> 继续巡检

    %% 阶段 4: 报告
    Drone->>Java: 任务结束，返航
    Java->>User: 生成《今日巡检报告》
```

这个流程展示了从**用户决策**到**物理执行**，再到**数字反馈**的全过程。我们的系统不仅仅是显示数据，更重要的是**闭环控制**。
