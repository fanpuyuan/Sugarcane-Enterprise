# 边缘设备接入协议 (Edge Protocol)
> 状态: 草稿 (Draft)

## 🎯 目标 (Objective)
定义通用的 MQTT 主题 (Topic) 结构，以支持异构设备的接入（不仅是大疆无人机，还包括气象站、水泵等）。

## 📝 待设计议题 (Topics)
- [ ] **Topic 层级设计**: 规范如 `agri/device/{device_id}/telemetry` 的命名标准。
- [ ] **设备影子 (Device Shadow)**: 定义 JSON 格式，用于同步设备在线/离线状态及配置信息。
- [ ] **离线缓存 (Offline Strategy)**: 弱网环境下，如何利用 Tus 协议进行数据补传。
