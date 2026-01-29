# UE5 数字孪生协议设计 (Twin Protocol)
> 状态: 草稿 (Draft)

## 🎯 目标 (Objective)
定义核心通过 WebSocket 向 UE5 实时推送数据的 JSON 载荷结构，实现 10Hz 低延迟同步。

## 📝 待设计议题 (Topics)
- [ ] **遥测数据包 (Telemetry Packet)**: 定义无人机姿态 (Pitch/Yaw/Roll) 和 GPS 坐标的数据结构。
- [ ] **指令数据包 (Command Packet)**: 定义 UE5 向无人机发送控制指令 (如: 起飞、返航) 的格式。
- [ ] **坐标系映射 (Coordinate Mapping)**: 确定 WGS84 经纬度如何映射到 UE5 的世界坐标系 (0,0,0)。
