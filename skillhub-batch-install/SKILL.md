---
name: 批量安装 Aime SkillHub 技能
description: 批量安装同花顺 Aime SkillHub 技能。支持按分类批量安装官方/第三方技能，自动配置 IWENCAI 环境变量。当用户需要批量安装技能、一次性安装多个分类、或安装所有技能时使用此技能。
---

# 批量安装 Aime SkillHub 技能 使用指南

## 技能概述

本技能提供批量安装同花顺 Aime SkillHub 技能的能力，支持：
- 官方技能与第三方技能分类安装
- 按业务场景分类安装（数据查询、选股、建模、并购等）
- 交互式 IWENCAI 环境变量配置
- 支持单个或批量分类安装

## 核心处理流程

### 步骤 1: 接收用户请求

接收用户的批量安装请求，分析安装需求。

### 步骤 2: 确定安装范围

根据用户需求确定安装分类：

**顶层分类：**
- `official` - 官方技能（27个）+ 配置环境变量
- `third-party` - 第三方技能（77个）
- `all` - 所有技能（104个）

**业务场景分类：**
- `data-query` - 数据查询类（16个）
- `screener` - 选股筛选类（10个）
- `analysis` - 分析类（12个）
- `trading` - 交易与组合类（4个）
- `modeling` - 财务建模类（6个）
- `reports` - 研究与报告类（5个）
- `mna` - 并购类（14个）
- `fixed-income` - 固定收益类（4个）
- `fx-deriv` - 外汇与衍生品类（4个）
- `philosophy` - 投资理念类（7个）
- `tools` - 工具类（9个）
- `wealth` - 财富管理类（3个）
- `pe` - 私募类（2个）
- `fintech` - 金融科技类（3个）

### 步骤 3: 执行安装

使用 aime-skillhub-cli 执行安装：

```bash
# 安装官方技能（会提示配置环境变量）
aime-skillhub-cli install 技能名称

# 示例：安装所有数据查询类技能
aime-skillhub-cli install "行情数据查询"
aime-skillhub-cli install "财务数据查询"
aime-skillhub-cli install "宏观数据查询"
# ... 以此类推
```

### 步骤 4: 环境变量配置（如需）

对于官方技能，需要配置 IWENCAI 环境变量：

```bash
# 方式一：手动配置
export IWENCAI_BASE_URL=https://openapi.iwencai.com
export IWENCAI_API_KEY=你的APIKey

# 写入 shell 配置
echo 'export IWENCAI_BASE_URL=https://openapi.iwencai.com' >> ~/.zshrc
echo 'export IWENCAI_API_KEY=你的APIKey' >> ~/.zshrc
source ~/.zshrc
```

**获取环境变量：**
1. 访问 https://www.iwencai.com/skillhub
2. 登录后随机点击一个官方技能卡片
3. 页面会显示 IWENCAI_BASE_URL 和 IWENCAI_API_KEY

## 常用安装组合

```bash
# 核心数据查询 + 选股筛选（最常用）
install_category "DATA_QUERY"
install_category "SCREENER"

# 投资分析工具
install_category "ANALYSIS"
install_category "MODELING"
install_category "REPORTS"

# 投行业务
install_category "MNA"
install_category "TOOLS"

# 价值投资
install_category "PHILOSOPHY"
install_category "ANALYSIS"
```

## 技能列表

### 官方技能（需配置 IWENCAI）

- 行情数据查询、基本资料查询、财务数据查询、事件数据查询
- 行业数据查询、期货期权数据查询、宏观数据查询、机构研究与评级查询
- 公司股东股本查询、公司经营数据查询、指数数据查询
- 投资者关系活动搜索、研报搜索、公告搜索、新闻搜索
- 问财选A股、问财选港股、问财选美股、问财选ETF
- 问财选可转债、问财选基金经理、问财选基金公司
- 问财选基金、问财选期货期权、问财选板块、模拟炒股

### 第三方技能（无需额外配置）

**投资理念：** 《股票大作手》交易哲学、桥水基金决策术、富爸爸财商课、指数投资鼻祖视野、交易心理通关秘籍、全球资管旗舰策略、方舟颠覆性投资前瞻

**分析工具：** 量化因子选股、市场情绪偏离分析、科技炒作与基本面、低估值好股搜寻、小盘成长股挖掘、高分红股挑选、上市公司财报体检、监管内幕交易追踪、捕捉公司事件机会、行业轮动监控、产业链解读、环境社会治理投资筛选

**财务建模：** 现金流折现估值模型、并购模型、杠杆收购模型、三表模型、回报敏感性分析、单元经济模型

**研究报告：** 首次覆盖报告、股票研究、财报前瞻、财报前瞻报告测试版、行业概览

**并购 (MNA)：** 流程函、保密信息备忘录构建、潜在买方清单、匿名项目预告、尽调清单、尽调会议准备、项目初筛、项目拓源、项目跟踪、投委会备忘录、投委会数据包构建、可比公司分析、竞争格局分析

**固定收益：** 债券相对价值分析、债券期货基差分析、固定收益组合分析、宏观利率监控

**外汇与衍生品：** 外汇、外汇套息交易分析、期权波动率分析、掉期曲线策略

**工具类：** 融资摘要、路演材料填充、演示文稿刷新、演示文稿模板技能创建、投行材料质检、晨会纪要、催化剂日历、税损收割、电子表格数据清洗

**财富管理：** 财务规划、客户业绩报告、客户回顾会材料

**私募股权：** 价值创造计划、投后监控

**金融科技：** 人工智能就绪度评估、电子表格审计

## 错误处理

- 安装失败：检查 aime-skillhub-cli 是否正确安装
- 环境变量未生效：确认已写入 ~/.zshrc 并执行 source ~/.zshrc
- 权限错误：确保脚本有执行权限 `chmod +x install_skills.sh`