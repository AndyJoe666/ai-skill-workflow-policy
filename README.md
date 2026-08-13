# AI Skill Workflow Policy

> v0.2 adds an optional static security review and a link-based installation mode. It does not replace the existing MVP-first Router or turn normal coding tasks into Deep-mode work.

## v0.2: security review and linked synchronization

Before enabling a new or updated Skill, run `skill-security-auditor` first for source/code capability signals, then run `skill-intake-auditor` for workflow-cost localization. The two checks are complementary: one cannot prove safety, and the other cannot prove that a Skill is proportionate.

For a device that keeps this repository cloned locally, use link mode to make the four policy Skills point at that clone:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install-policy.ps1 -InstallMode Link
```

Link mode never replaces an existing normal Skill directory. On an already configured device, either retain copy mode or move only the confirmed policy directories aside before linking. Pulling a reviewed repository revision then updates the linked Skills; the global `AGENTS.md` remains a deliberate manual merge so device-specific instructions are not overwritten. See `UPGRADE-0.2.md` and `SECURITY-AUDIT.md` for the exact operating procedure.

这是一个面向 Codex 本地环境的工作流策略包，用于调整软件开发类任务中 Planning、Testing、Verification、代码审查、重试和多 Agent 的默认触发条件。

项目采用 MVP-first 作为普通软件开发任务的默认路径：

```text
最小实现 → build / smoke test → 核心路径检查 → 停止 → 人工验收 → 按反馈迭代
```

对于安全、支付、不可逆数据迁移、公开接口或生产发布等高风险工作，仍可通过 Deep 模式采用更完整的计划、测试和审查流程。

## 项目包含什么

项目将规则拆分为几个相对独立的部分：

| 内容 | 作用 |
|---|---|
| `OPERATING-MANUAL.md` | 简短的全局工作原则，包括 MVP-first、停止条件、Search-Before-Create 和重试边界 |
| `mvp-workflow-router` | 根据任务后果和复杂度，在 Direct、MVP、Deep 三种模式之间分流 |
| `mvp-coding-policy` | 定义各模式的实现边界、测试预算和人工验收点 |
| `skill-intake-auditor` | 扫描新安装或更新后的 Skills，标记可能导致流程膨胀的规则 |
| `skill-security-auditor` | 在启用新或更新的 Skill 前，静态标记工具权限、脚本和来源相关的安全信号 |
| `patches/superpowers` | 针对本次审计中部分用户自有 Superpowers Skills 的本地化版本 |
| `overlays/SKILL-PATCH-REGISTRY.md` | 为不宜直接修改的系统或插件 Skills 记录兼容规则 |
| `SKILL-AUDIT.md` | 2026-08-13 对当前设备启用 Skills 的审计结果快照 |
| `MULTI-DEVICE-DEPLOYMENT.md` | 在多台设备间保存和同步本项目的建议方式 |

审计器是基于文本模式的静态检查工具。它可以帮助定位风险信号，但不会理解所有领域语境，因此报告仍需要人工复核。例如，统计分析 Skill 中出现的“test”不一定指软件测试流程。

## 目录结构

```text
ai-skill-workflow-policy/
├─ OPERATING-MANUAL.md
├─ SKILL-AUDIT.md
├─ MULTI-DEVICE-DEPLOYMENT.md
├─ install-policy.ps1
├─ skills/
│  ├─ mvp-workflow-router/
│  ├─ mvp-coding-policy/
│  ├─ skill-intake-auditor/
│  └─ skill-security-auditor/
├─ patches/
│  └─ superpowers/
└─ overlays/
   └─ SKILL-PATCH-REGISTRY.md
```

## 工作模式

| 模式 | 适用情况 | 默认验证范围 |
|---|---|---|
| Direct | 小型、局部、定义清楚且风险较低的修改 | 一个相关检查；条件不具备时明确说明 |
| MVP | 普通功能或行为修改，也是默认模式 | build/smoke、核心 happy path、1–3 个明确风险检查 |
| Deep | 用户明确要求，或涉及高后果风险与生产发布 | 在实施前定义与风险对应的计划、测试和审查范围 |

Router 只决定流程深度，不代替领域 Skill。比如处理演示文稿、RNA-seq 或统计分析时，相关领域 Skill 仍负责具体方法，本项目只约束其附带的软件开发流程是否需要升级到 Deep。

## 环境要求

- Codex 使用用户级 Skill 目录，例如 Windows 上的 `C:\Users\<用户名>\.codex\skills`。
- 安装与审计脚本使用 PowerShell。
- 当前脚本主要按 Windows 路径和 PowerShell 环境编写；其他系统可以手动复制文件，但脚本未经跨平台处理。

## 安装

### 手动安装

将以下三个目录复制到 `<CODEX_HOME>/skills/`：

```text
skills/mvp-workflow-router
skills/mvp-coding-policy
skills/skill-intake-auditor
skills/skill-security-auditor
```

然后人工审阅 `OPERATING-MANUAL.md`，将适用内容合并到 `<CODEX_HOME>/AGENTS.md`。如果已有全局指令，应合并而不是直接覆盖。

### 使用安装脚本

在项目根目录运行：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\install-policy.ps1
```

默认只安装三个策略 Skills。可用参数如下：

```powershell
# 指定另一个 Codex 目录
powershell -NoProfile -ExecutionPolicy Bypass -File .\install-policy.ps1 `
  -CodexHome 'D:\path\to\.codex'

# 同时安装本项目保存的用户级 Superpowers 补丁
powershell -NoProfile -ExecutionPolicy Bypass -File .\install-policy.ps1 `
  -InstallUserOwnedPatches

# 同时写入全局 Operating Manual
powershell -NoProfile -ExecutionPolicy Bypass -File .\install-policy.ps1 `
  -InstallGlobalManual
```

当目标 `AGENTS.md` 已有内容时，脚本默认拒绝覆盖。`-Force` 会直接覆盖该文件，使用前应自行备份或手动合并。

安装用户级补丁会覆盖目标目录中同名 Superpowers Skill 的文件。补丁针对 `SKILL-AUDIT.md` 中记录的本地版本准备；如果原 Skill 已更新，建议先重新审计和比较差异。

安装后需要重新启动 Codex，或至少新建一个任务，使 Skill 列表重新加载。

## 审计新 Skill 或更新

运行静态审计：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass `
  -File .\skills\skill-intake-auditor\scripts\audit-skills.ps1 `
  -SkillRoot 'C:\path\to\skills' `
  -Format Markdown
```

脚本会递归盘点 `SKILL.md`，并检查以下维度：

- 强制 Planning；
- 全量测试或默认 test-first；
- 重复 Verification 和 Review；
- retry、self-review 或 fix loop；
- 不相关的 Refactoring、Abstraction 和 scope expansion；
- 默认 Multi-Agent；
- 是否缺少 Search-Before-Create / Reuse-First；
- 是否缺少 MVP-first 和 Human Acceptance Gate。

报告只提供风险分数、等级和命中项，不会自动安装、删除或修改被审计的 Skill。建议结合原文将发现分类为 Keep、Condition、Downgrade、Move-Deep 或 Remove，再决定是否应用补丁。

## 基础验证

运行审计器的输出契约检查：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass `
  -File .\skills\skill-intake-auditor\tests\test-auditor-contract.ps1 `
  -FixtureRoot 'C:\path\to\skills'
```

该检查只确认脚本能够输出预期结构，并能盘点测试目录中的 Skill；它不验证所有风险判断是否符合具体语境。

## 多设备使用

可以将本目录放入私有 Git 仓库，在各设备上分别安装三个策略 Skills，并人工合并全局 Operating Manual。建议只同步本项目文件、审计报告和补丁记录，不要同步完整 `.codex` 目录、插件缓存、凭据或设备专用配置。

详细步骤见 `MULTI-DEVICE-DEPLOYMENT.md`。

## 已知限制

- 静态审计依赖关键词与文本模式，可能产生误报或漏报。
- 当前审计清单是特定设备和日期下的快照，不代表未来安装的 Skills。
- Router 和 Coding Policy 依赖模型遵循文字规则，不是强制执行的沙箱或权限系统。
- 本项目不会自动识别所有生产风险，也不能代替人工验收、专业安全审查或领域验证。
- 系统和插件缓存中的 Skills 不由本项目直接修改；相关差异通过兼容规则记录。

## 主要文件

- 完整审计结果：`SKILL-AUDIT.md`
- 全局规则：`OPERATING-MANUAL.md`
- 受保护 Skill 的兼容记录：`overlays/SKILL-PATCH-REGISTRY.md`
- 多设备部署：`MULTI-DEVICE-DEPLOYMENT.md`
