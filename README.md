# AI Skill 工作流策略包

这是一个面向 Codex 本地环境的工作流策略包。它用于约束软件开发任务中 Planning、Testing、Verification、代码审查、重试和 Multi-Agent 的默认触发条件，避免在第一次可用交付前投入不成比例的时间与 Token。

普通软件开发默认采用 MVP-first：

```text
最小实现 → build / smoke → 核心路径 → 停止 → 人工验收 → 按反馈迭代
```

对于安全、支付、不可逆数据迁移、公开接口或生产发布等高后果任务，仍可通过 Deep 模式采用更完整、且与风险对应的计划、测试和审查。

## v0.2 更新

v0.2 新增了静态安全审计和链接安装方式，但不改变 Router 的 MVP-first 默认路线，也不会把普通开发任务自动升级为 Deep。

- `skill-security-auditor`：在启用新 Skill、更新 Skill 或链接外部仓库中的 Skill 前，标记工具权限、可执行脚本、网络访问、动态执行、凭据路径和持久化等安全信号。
- `-InstallMode Link`：将策略 Skill 以目录链接方式安装到本地 Codex 目录。设备上的仓库切换到已审核的 Git 提交或标签后，链接的 Skill 会随之更新。
- 默认仍使用 `Copy` 安装方式，以兼容已有的本地目录。

安全审计和工作流审计互补：前者帮助判断是否应启用一个 Skill，后者帮助判断启用后是否会造成过度 Planning、Testing 或自主扩张。

## 包含内容

| 内容 | 用途 |
|---|---|
| `OPERATING-MANUAL.md` | 全局工作原则，包括 MVP-first、停止条件、Search-Before-Create、Reuse-First 和重试边界。 |
| `skills/mvp-workflow-router` | 根据任务后果与复杂度，在 Direct、MVP、Deep 三种模式间分流。 |
| `skills/mvp-coding-policy` | 定义各模式的实现边界、测试预算和人工验收点。 |
| `skills/skill-security-auditor` | 静态检查新或更新 Skill 的安全信号；不执行被审计 Skill 的脚本。 |
| `skills/skill-intake-auditor` | 检查新或更新 Skill 中可能导致流程膨胀的规则，并给出本地化改造分类。 |
| `patches/superpowers` | 针对已审计的用户自有 Superpowers Skills 的本地补丁。 |
| `overlays/SKILL-PATCH-REGISTRY.md` | 为系统或插件缓存中的 Skill 记录兼容规则，不直接修改其缓存文件。 |
| `SKILL-AUDIT.md` | 当前设备已启用 Skills 的审计快照。 |
| `SECURITY-AUDIT.md` | 安全审计器的范围、信号说明与使用方法。 |
| `MULTI-DEVICE-DEPLOYMENT.md` | 多设备的安装、更新、冲突处理和版本固定方法。 |
| `UPGRADE-0.2.md` | 从旧版本迁移到 v0.2 的说明。 |

## 目录结构

```text
ai-skill-workflow-policy/
├─ OPERATING-MANUAL.md
├─ README.md
├─ POLICY-VERSION.json
├─ SECURITY-AUDIT.md
├─ SKILL-AUDIT.md
├─ MULTI-DEVICE-DEPLOYMENT.md
├─ UPGRADE-0.2.md
├─ install-policy.ps1
├─ skills/
│  ├─ mvp-workflow-router/
│  ├─ mvp-coding-policy/
│  ├─ skill-security-auditor/
│  └─ skill-intake-auditor/
├─ patches/
│  └─ superpowers/
├─ overlays/
│  └─ SKILL-PATCH-REGISTRY.md
└─ tests/
```

## 工作模式

| 模式 | 适用情况 | 默认验证范围 |
|---|---|---|
| Direct | 小型、局部、定义清楚且无实质风险的修改。 | 条件允许时做一项相关检查。 |
| MVP | 普通功能或有意义的行为修改；这是默认模式。 | build / smoke、核心 happy path，以及 1–3 项明确的风险检查。 |
| Deep | 用户明确要求严格流程，或涉及生产发布、安全、支付、不可逆迁移、公开契约。 | 在实施前确定与实际风险对应的计划、测试和审查范围。 |

Router 只决定流程深度，不替代领域 Skill。例如处理 RNA-seq、统计分析或演示文稿时，领域 Skill 仍负责具体方法；本项目只约束其附带的软件开发流程是否需要升级到 Deep。

## 安装

### 推荐：链接安装

在每台设备上，将本仓库克隆到一个正常的用户目录，并在仓库根目录运行：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install-policy.ps1 -InstallMode Link
```

安装器会在 `<CODEX_HOME>/skills/` 中为以下四个策略 Skill 创建目录链接：

```text
skills/mvp-workflow-router
skills/mvp-coding-policy
skills/skill-security-auditor
skills/skill-intake-auditor
```

链接模式不会覆盖已经存在的普通目录，也不会替换指向其他位置的链接。若设备上已有相同名称的策略 Skill，请保留 `Copy` 方式，或先自行备份并只移动已确认属于本策略包的目录。

`AGENTS.md` 不会被自动链接或覆盖。请将 `OPERATING-MANUAL.md` 中适用的内容人工合并到 `<CODEX_HOME>/AGENTS.md`，并保留设备专用的路径、工具和约束。

### 复制安装

默认方式会复制策略 Skill：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install-policy.ps1
```

可选参数：

```powershell
# 指定另一套 Codex 目录
powershell -NoProfile -ExecutionPolicy Bypass -File .\install-policy.ps1 `
  -CodexHome 'D:\path\to\.codex'

# 同时安装本项目保存的用户自有 Superpowers 补丁
powershell -NoProfile -ExecutionPolicy Bypass -File .\install-policy.ps1 `
  -InstallUserOwnedPatches

# 在确认目标文件可覆盖后写入全局 Operating Manual
powershell -NoProfile -ExecutionPolicy Bypass -File .\install-policy.ps1 `
  -InstallGlobalManual
```

目标 `AGENTS.md` 已有内容时，安装器默认拒绝覆盖。`-Force` 会覆盖该文件，使用前应自行备份或先人工合并。

安装完成后，请重启 Codex 或新建任务，以便重新加载 Skill 列表。

## 审计新 Skill 或更新

先进行安全审计：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass `
  -File .\skills\skill-security-auditor\scripts\scan-skill-security.ps1 `
  -SkillRoot 'C:\path\to\candidate-skills' `
  -Format Markdown
```

该脚本只读取文件，不会执行候选脚本、安装依赖、访问网络或修改被审计目录。它的报告是静态信号，不是安全保证；即使没有发现信号，也应确认来源、版本和相关依赖。

在确认可启用后，再进行工作流审计：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass `
  -File .\skills\skill-intake-auditor\scripts\audit-skills.ps1 `
  -SkillRoot 'C:\path\to\candidate-skills' `
  -Format Markdown
```

工作流审计会盘点全部 `SKILL.md`，并检查：

- 强制 Planning；
- 全量 Testing 或默认 test-first；
- 重复 Verification、Review 或无边界 retry/self-review；
- 无关 Refactoring、Abstraction 或 scope expansion；
- 默认 Multi-Agent；
- 是否缺少 Search-Before-Create、Reuse-First、MVP-first 和人工验收点。

审计结果应结合原文分为 Keep、Condition、Downgrade、Move-Deep 或 Remove。系统和插件缓存中的 Skill 不直接修改，而是记录兼容规则；用户自有 Skill 才在人工确认后进行小范围补丁。

## 基础验证

安全审计器的契约检查：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass `
  -File .\skills\skill-security-auditor\tests\test-security-scanner-contract.ps1
```

安装器的复制与链接契约检查：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass `
  -File .\tests\test-install-policy-contract.ps1
```

这些检查只验证关键脚本的基本行为，不代替对真实任务的人工验收。

## 多设备同步

每台设备保留自己的仓库克隆。更新时先获取并审阅目标 Git 提交或标签，再执行：

- 链接安装：切换到已审核的提交或标签即可，链接的 Skill 会读取该版本文件。
- 复制安装：切换版本后重新运行 `install-policy.ps1`。

不要同步整个 `.codex` 目录、插件缓存、凭据或设备专用配置。共享仓库只保存策略、审计报告、兼容规则和用户自有补丁。公共仓库尤其不应包含密钥、个人路径或私有项目内容。

详细步骤见 `MULTI-DEVICE-DEPLOYMENT.md`。可以为每个已审核版本创建 Git 标签；需要继续观察的新策略可固定在较早的标签或提交。

## 已知限制

- 安全和工作流审计都是基于静态文本或规则的辅助工具，可能误报或漏报。
- Router、Coding Policy 和兼容规则依赖模型遵循，不是强制权限系统。
- 本项目不能代替人工验收、专业安全审查、生产发布检查或领域验证。
- 审计清单是特定设备与日期的快照，不代表未来安装的 Skills。
- `.system` 与插件缓存中的 Skills 不由本项目直接修改。
