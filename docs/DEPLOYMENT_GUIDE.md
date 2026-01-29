# Docker 部署与迁移指南 (Deployment Guide)

您问到如何“迁移”这套系统，这正是 Docker 最强大的地方。

## 核心原理：搬“图纸”不搬“房子”

传统的搬家是把家具一件件搬走。
Docker 的搬家是：**拿着图纸到新地方，原地变出一模一样的房子。**

这个“图纸”就是我们写好的 `docker-compose.yml`。

---

## 🚀 如何部署到新服务器？

假设您买了一台阿里云/腾讯云服务器，或者有另一台电脑想运行这个项目。

### 第一步：在新电脑上装好 Docker
就像您在本地安装 Docker Desktop 一样。服务器上通常只需要装 `Docker Engine`。

### 第二步：把代码“拉”过去 (Git Clone)
这就是您问的“链接”。我们不需要用 U 盘拷贝，直接用 GitHub 的链接。

在服务器终端执行：
```bash
# 1. 把仓库克隆下来
git clone git@github.com:fanpuyuan/Sugarcane-Enterprise.git

# 2. 进入目录
cd Sugarcane-Enterprise/sugarcane-infra
```

### 第三步：一键启动
执行和我们刚才一模一样的命令：
```bash
docker compose up -d
```

**发生了什么？**
1.  Docker 会读取 `docker-compose.yml`。
2.  它发现需要 Postgres, Redis, MinIO...
3.  它会自动从互联网下载这些软件的镜像（Image）。
4.  它按照配置自动启动，端口、密码、网络结构与您现在的电脑**完全一致**。

---

## ❓ 常见问题

### 1. 我的数据（数据库里的内容）也会过去吗？
**默认不会。**
`docker-compose up` 搬运的是“空房子”。
*   **代码/配置**：通过 Git 同步过去了。
*   **数据**（比如已经存进去的甘蔗地块）：保存在本地的 `volume` 里。

**如果需要迁移数据：**
需要手动“搬运家具”。
1.  **备份** (在老电脑): `docker exec -t sugarcane-postgres pg_dumpall -c -U sugarcane > dump.sql`
2.  **传输**: 把 `dump.sql` 发到新电脑。
3.  **恢复** (在新电脑): `cat dump.sql | docker exec -i sugarcane-postgres psql -U sugarcane`

### 2. 什么是“链接”？
在 Docker 世界里，如果有“连接”，通常指：
*   **Git 链接**: 用于下载 `docker-compose.yml` (图纸)。
*   **镜像仓库链接**: Docker 自动连接 Docker Hub 下载软件 (材料)。

### 总结
您只需要保护好 GitHub 上的代码。以后无论去哪台电脑，只要有网、有 Docker，执行 `git clone` 和 `docker compose up`，您的整个“Agri-OS”基础设施就会立刻复活。
