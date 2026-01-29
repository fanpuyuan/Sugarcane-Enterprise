# 项目管理指南 (Project Management Guide)

既然您的代码托管在 GitHub 且追求“大厂标准”，最好的管理工具就是 **GitHub Projects**。它完全免费，且与代码无缝集成。

## 1. 为什么用 GitHub Projects？
*   **代码联动**: 您提交代码时写一句 `Fix #12`，任务卡片就会自动从“进行中”挪到“已完成”。
*   **看板视图 (Kanban)**: 就像贴便利贴一样，任务状态一目了然 (To Do -> In Progress -> Done)。
*   **All-in-One**: 不用在 Trello/Jira 和 GitHub 之间切来切去。

---

## 2. 快速启动 (5分钟)

请按照以下步骤为您创建项目看板：

1.  打开您的 GitHub 仓库页面: [Sugarcane-Enterprise](https://github.com/fanpuyuan/Sugarcane-Enterprise)
2.  点击顶部导航栏的 **Projects** 标签。
3.  点击绿色按钮 **"Link a project"** -> **"New project"**。
4.  选择模板: **"Board"** (这是最经典的看板模式)。
5.  命名为: `Agri-OS Roadmap`。

---

## 3. 看板列建议 (Columns)

大厂标准的看板通常分这几列，建议您手动重命名一下：

| 列名 | 含义 | 谁来移动 |
| :--- | :--- | :--- |
| **Backlog (需求池)** | 所有想做的功能，但还没排期。 | 都在这里 |
| **Todo (本周待办)** | 确定这周要做的，优先级高。 | 开发人员 (您) |
| **In Progress (开发中)** | 此时此刻正在写代码的任务。**同一时间不要超过2个**。 | 开发人员 (您) |
| **Review (待验收)** | 代码写完了，待测试或待合并。 | 机器人/测试 |
| **Done (已发布)** | 上线了！ | 自动完成 |

---

## 4. 录入您的第一批任务

我们之前在 `PROJECT_PLAN.md` 里的清单，就可以转化为一个个 **Issue**：

1.  在看板里点击 "+ Add item"。
2.  输入: `[UI] Android App 登录页/地图页原型设计` -> 放入 **Todo**。
3.  输入: `[Java] 数据库表结构设计 (ERD)` -> 放入 **Backlog**。
4.  输入: `[Infra] 基础设施启动` -> 放入 **Done** (我们已经做完了！)。

---

## 5. 进阶玩法：AI 联动

下次您给我派活时，可以说：“请帮我解决 Issue #5”。
我会根据 Issue 的描述去写代码，提交时会自动关联 Issue，让进度条自动推进。
