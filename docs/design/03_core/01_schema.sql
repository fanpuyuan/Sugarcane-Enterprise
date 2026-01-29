-- ==========================================
-- Agri-OS 核心数据库设计 (Draft v1.0)
-- 对应模块: sugarcane-core
-- ==========================================
-- 1. 地块表 (Plot): 核心资产
-- 存储每一块甘蔗地的地理边界、品种、种植时间
CREATE TABLE plots (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL COMMENT '地块名称，如 A区-01',
    area_mu DECIMAL(10, 2) COMMENT '面积(亩)',
    crop_type VARCHAR(50) DEFAULT 'Sugarcane' COMMENT '作物类型',
    plant_date DATE COMMENT '种植日期',
    owner VARCHAR(50) COMMENT '负责人',
    -- PostGIS 核心字段: 存储多边形经纬度
    boundary GEOMETRY(Polygon, 4326),
    center_point GEOMETRY(Point, 4326),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- 1.5 系统全局配置表 (System Config)
-- 用于存储 "Super FSD" 等开发者开关
CREATE TABLE system_configs (
    key VARCHAR(50) PRIMARY KEY,
    value VARCHAR(255) NOT NULL,
    description VARCHAR(200),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- 预置数据: 默认关闭 Omega 模式
-- INSERT INTO system_configs (key, value) VALUES ('OMEGA_MODE', 'FALSE');
-- 2. 任务表 (Mission): 核心业务
-- 每次无人机起飞都是一个任务
CREATE TABLE missions (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL COMMENT '任务名称，如 A区病害巡检-20240129',
    plot_id BIGINT REFERENCES plots(id),
    type VARCHAR(20) NOT NULL COMMENT '任务类型: INSPECT(巡检), SPRAY(植保), MAPPING(测绘)',
    status VARCHAR(20) DEFAULT 'PENDING' COMMENT '状态: PENDING, IN_PROGRESS, COMPLETED, FAILED',
    -- 航线参数 (JSON 存储)
    parameters JSONB COMMENT '如: {"height": 30, "speed": 5, "overlap": 80}',
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- 3. 识别结果表 (DetectionResult): 核心产出
-- AI 识别出来的病害记录
CREATE TABLE detection_results (
    id BIGSERIAL PRIMARY KEY,
    mission_id BIGINT REFERENCES missions(id),
    disease_type VARCHAR(50) NOT NULL COMMENT '病害类型: RUST(锈病), YELLOW_LEAF(黄叶病)',
    confidence DECIMAL(5, 4) COMMENT '置信度 0.0-1.0',
    image_url VARCHAR(500) COMMENT 'MinIO 中的图片路径',
    -- 发现的具体位置
    location GEOMETRY(Point, 4326),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- 4. 遥测日志表 (Telemetry): 过程数据
-- 记录飞行轨迹，用于回放和数字孪生
CREATE TABLE telemetry_logs (
    time TIMESTAMP NOT NULL,
    mission_id BIGINT,
    drone_id VARCHAR(50),
    latitude DECIMAL(10, 7),
    longitude DECIMAL(10, 7),
    altitude DECIMAL(6, 2),
    speed DECIMAL(5, 2),
    battery_level INT,
    -- 这里通常使用 TimescaleDB 扩展，暂用标准表
    PRIMARY KEY (time, drone_id)
);