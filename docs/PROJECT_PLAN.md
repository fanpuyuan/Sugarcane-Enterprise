# Sugarcane Enterprise Project Plan

## 1. Vision & Goal
Building the "Agri-OS" platform to modernize sugarcane farming with Drone AI, IoT, and Digital Twins.

## 2. Architecture Overview
(Based on `main/X.md`)
- **Edge Layer**: Drone (DJI), Pi Zero 2, Android App (FieldMate).
- **Core Layer**: Java Spring Boot backend (Business Orchestration).
- **AI Layer**: Python Workers (YOLOv8, NDVI, Path Planning).
- **Data Layer**: PostGIS (Geo), MinIO (Storage), VectorDB (Knowledge), Redis (MQ).
- **Twin Layer**: UE5 + Cesium (Metaverse Visualization).

## 3. Module Roadmap

### Phase 1: Infrastructure (Completed)
- [x] Git Repo & Directory Structure
- [x] Docker Services (PostGIS, Redis, MinIO, Mosquitto, Ollama, Chroma)

### Phase 2: Core Platform (`sugarcane-core`)
- **Tech**: Java 17, Spring Boot 3.2
- **Tasks**:
    - [ ] Init Spring Boot Project
    - [ ] Configure DB Connectivity (JPA + Hibernate Spatial)
    - [ ] Implement LiteFlow for process orchestration
    - [ ] Implement MQTT Client for drone commands
    - [ ] Implement Tus Server for large file uploads

### Phase 3: AI Workers (`sugarcane-brain`)
- **Tech**: Python 3.10
- **Tasks**:
    - [ ] Setup Virtual Environment
    - [ ] Implement YOLOv8 Service (Disease Integration)
    - [ ] Implement NDVI Processing (OpenCV)
    - [ ] Create Path Planning (NetworkX/CPP) Service
    - [ ] Connect to Redis Streams for tasks

### Phase 4: Mobile Terminal (`sugarcane-mobile`)
- **Tech**: Android, DJI SDK v5
- **Tasks**:
    - [ ] Setup Android Project
    - [ ] Integrate DJI Mobile SDK
    - [ ] Integrate Mapbox
    - [ ] Implement Offline Mode & Tus Client

### Phase 5: Digital Twin (`sugarcane-twin`)
- **Tech**: UE5.3, Cesium
- **Tasks**:
    - [ ] Setup UE5 Project with Cesium
    - [ ] Implement WebSocket Client
    - [ ] Create VR Interaction Logic

### Phase 6: Edge Hardware (`sugarcane-pi`)
- **Tech**: Raspberry Pi Zero 2, Python
- **Tasks**:
    - [ ] Camera Capture Script (NDVI filter)
    - [ ] GPS NMEA Parsing

## 4. Versioning Strategy
- **Monorepo**: All modules in one git repo for sync.
- **Branching**:
    - `main`: Stable production ready.
    - `develop`: Integration branch.
    - `feature/*`: Specific feature dev.
