# 03. 开发手册 (Developer Guide)

> **目标用户**: 开发人员、运维人员
> **包含内容**: 环境搭建、部署指南、开发规范

---

## 🚀 1. 快速启动 (Quick Start)

### 1.1 依赖环境
*   Docker & Docker Compose
*   Java JDK 17
*   Python 3.10
*   Android Studio (Ladybug+)

### 1.2 启动基础设施
```bash
cd sugarcane-infra
docker compose up -d
# 验证：访问 http://localhost:9001 (MinIO Console)
```

---

## 📦 2. 部署与迁移 (Deployment)
*核心原则：Infrastructure as Code (IaC)*

只要目标机器安装了 Docker，即可一键复刻环境：
1.  `git clone git@github.com:fanpuyuan/Sugarcane-Enterprise.git`
2.  `docker compose up -d`

*(详情参考原 DEPLOYMENT_GUIDE)*

---

## 📏 3. 开发规范 (SOP)

### 3.1 流程标准 "Design First"
1.  **Figma**: 必须先有 UI 草图。
2.  **API**: 根据 UI 定义接口文档 (YAML)。
3.  **Code**: 最后写代码实现。

### 3.2 分支管理
*   `main`: 随时可发布的稳定版。
*   `feature/*`: 比如 `feature/login-page` (开发完合并回 main)。

### 3.3 提交规范
*   `feat: ...`: 新功能
*   `fix: ...`: 修 Bug
*   `docs: ...`: 改文档 (比如现在)
