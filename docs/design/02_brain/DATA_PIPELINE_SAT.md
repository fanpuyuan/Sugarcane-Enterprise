# 卫星数据流水线设计 (Satellite Pipeline)
> 状态: 草稿 (Draft)

## 🎯 目标 (Objective)
定义 Sentinel-2 卫星影像如何从 ESA/Copernicus API 自动拉取，并经过处理存入数据库，最终供给 AI 进行分析。

## 📝 待设计议题 (Topics)
- [ ] **数据拉取 (Client)**: 编写 Python 脚本调用 Sentinel Hub API 下载指定地块的影像。
- [ ] **存储方案 (Storage)**: 决定原始影像存 MinIO，还是切片存 PostGIS Raster。
- [ ] **元数据管理 (Metadata)**: 设计 `satellite_images` 表结构，存储云量、拍摄时间等信息。
