#!/usr/bin/env python3
import os
import sys
import subprocess
import json

SKILLS = {
    "OFFICIAL": [
        "行情数据查询",
        "基本资料查询",
        "财务数据查询",
        "事件数据查询",
        "行业数据查询",
        "期货期权数据查询",
        "宏观数据查询",
        "机构研究与评级查询",
        "公司股东股本查询",
        "公司经营数据查询",
        "指数数据查询",
        "投资者关系活动搜索",
        "研报搜索",
        "公告搜索",
        "新闻搜索",
        "问财选A股",
        "问财选港股",
        "问财选美股",
        "问财选ETF",
        "问财选可转债",
        "问财选基金经理",
        "问财选基金公司",
        "问财选基金",
        "问财选期货期权",
        "问财选板块",
        "模拟炒股",
    ],
    "THIRD_PARTY": [
        "流程函",
        "融资摘要",
        "外汇套息交易分析",
        "投行材料质检",
        "《股票大作手》交易哲学",
        "首次覆盖报告",
        "杠杆收购模型",
        "晨会纪要",
        "路演材料填充",
        "期权波动率分析",
        "量化因子选股",
        "市场情绪偏离分析",
        "公司单页",
        "捕捉公司事件机会",
        "现金流折现估值模型",
        "外汇",
        "桥水基金决策术",
        "催化剂日历",
        "富爸爸财商课",
        "指数投资鼻祖视野",
        "交易心理通关秘籍",
        "全球资管旗舰策略",
        "方舟颠覆性投资前瞻",
        "价值创造计划",
        "单元经济模型",
        "投资逻辑跟踪",
        "低估值好股搜寻",
        "匿名项目预告",
        "科技炒作与基本面",
        "税损收割",
        "掉期曲线策略",
        "公司画像页",
        "投资者风险评估",
        "小盘成长股挖掘",
        "行业轮动监控",
        "行业概览",
        "风险收益优化配置",
        "回报敏感性分析",
        "演示文稿模板技能创建",
        "股票研究",
        "财报前瞻报告测试版",
        "组合再平衡",
        "投后监控",
        "投资组合诊断",
        "模型更新",
        "并购模型",
        "宏观利率监控",
        "监管内幕交易追踪",
        "投资提案",
        "投委会备忘录",
        "投资想法生成",
        "高分红股挑选",
        "固定收益组合分析",
        "上市公司财报体检",
        "财务规划",
        "环境社会治理投资筛选",
        "财报前瞻",
        "演示文稿刷新",
        "项目跟踪",
        "项目拓源",
        "项目初筛",
        "尽调会议准备",
        "尽调清单",
        "投委会数据包构建",
        "可比公司分析",
        "竞争格局分析",
        "客户回顾会材料",
        "客户业绩报告",
        "债券期货基差分析",
        "电子表格数据清洗",
        "三表模型",
        "保密信息备忘录构建",
        "潜在买方清单",
        "债券相对价值分析",
        "电子表格审计",
        "人工智能就绪度评估",
        "产业链解读",
    ],
    "DATA_QUERY": [
        "行情数据查询",
        "基本资料查询",
        "财务数据查询",
        "事件数据查询",
        "行业数据查询",
        "期货期权数据查询",
        "宏观数据查询",
        "机构研究与评级查询",
        "公司股东股本查询",
        "公司经营数据查询",
        "指数数据查询",
        "投资者关系活动搜索",
        "研报搜索",
        "公告搜索",
        "新闻搜索",
    ],
    "SCREENER": [
        "问财选A股",
        "问财选港股",
        "问财选美股",
        "问财选ETF",
        "问财选可转债",
        "问财选基金经理",
        "问财选基金公司",
        "问财选基金",
        "问财选期货期权",
        "问财选板块",
    ],
    "ANALYSIS": [
        "量化因子选股",
        "市场情绪偏离分析",
        "科技炒作与基本面",
        "低估值好股搜寻",
        "小盘成长股挖掘",
        "高分红股挑选",
        "上市公司财报体检",
        "监管内幕交易追踪",
        "捕捉公司事件机会",
        "行业轮动监控",
        "产业链解读",
        "环境社会治理投资筛选",
    ],
    "MODELING": [
        "现金流折现估值模型",
        "并购模型",
        "杠杆收购模型",
        "三表模型",
        "回报敏感性分析",
        "单元经济模型",
    ],
    "MNA": [
        "流程函",
        "保密信息备忘录构建",
        "潜在买方清单",
        "匿名项目预告",
        "尽调清单",
        "尽调会议准备",
        "项目初筛",
        "项目拓源",
        "项目跟踪",
        "投委会备忘录",
        "投委会数据包构建",
        "可比公司分析",
        "竞争格局分析",
    ],
    "PHILOSOPHY": [
        "《股票大作手》交易哲学",
        "桥水基金决策术",
        "富爸爸财商课",
        "指数投资鼻祖视野",
        "交易心理通关秘籍",
        "全球资管旗舰策略",
        "方舟颠覆性投资前瞻",
    ],
}


def install_skill(skill_name):
    print(f"[安装] {skill_name}")
    try:
        result = subprocess.run(
            ["aime-skillhub-cli", "install", skill_name],
            capture_output=True,
            text=True,
            timeout=60,
        )
        if result.returncode == 0:
            print(f"  ✓ 成功")
            return True
        else:
            print(f"  ✗ 失败: {result.stderr}")
            return False
    except subprocess.TimeoutExpired:
        print(f"  ✗ 超时")
        return False
    except FileNotFoundError:
        print(f"  ✗错误: aime-skillhub-cli 未安装")
        return False


def install_category(category):
    skills = SKILLS.get(category.upper())
    if not skills:
        print(f"未知分类: {category}")
        print(f"可用分类: {', '.join(SKILLS.keys())}")
        return False

    print(f"\n{'=' * 40}")
    print(f"安装分类: {category} ({len(skills)}个技能)")
    print(f"{'=' * 40}\n")

    success = 0
    failed = 0
    for skill in skills:
        if install_skill(skill):
            success += 1
        else:
            failed += 1

    print(f"\n完成: 成功 {success}, 失败 {failed}")
    return True


def install_all():
    print(f"\n{'=' * 40}")
    print(f"安装所有技能 (共{len(SKILLS['OFFICIAL']) + len(SKILLS['THIRD_PARTY'])}个)")
    print(f"{'=' * 40}\n")

    install_category("OFFICIAL")
    install_category("THIRD_PARTY")
    print("\n所有技能安装完成!")


def setup_env():
    print("\n配置 IWENCAI 环境变量")
    print("获取方式: 访问 https://www.iwencai.com/skillhub")
    print("          登录后点击任意官方技能卡片，页面会显示环境变量\n")

    base_url = input("IWENCAI_BASE_URL: ").strip()
    api_key = input("IWENCAI_API_KEY: ").strip()

    if not base_url:
        base_url = "https://openapi.iwencai.com"
    if not api_key:
        print("错误: API Key 不能为空")
        return False

    shell_rc = os.path.expanduser("~/.zshrc")
    if not os.path.exists(shell_rc):
        shell_rc = os.path.expanduser("~/.bashrc")

    env_config = f"""
# IWENCAI (同花顺)
export IWENCAI_BASE_URL={base_url}
export IWENCAI_API_KEY={api_key}
"""

    with open(shell_rc, "a") as f:
        f.write(env_config)

    os.environ["IWENCAI_BASE_URL"] = base_url
    os.environ["IWENCAI_API_KEY"] = api_key

    print(f"\n✓ 环境变量已配置到 {shell_rc}")
    print(f"  BASE_URL: {base_url}")
    print(f"  API_KEY: {api_key[:20]}...")
    return True


def list_categories():
    print("\n可用分类:")
    for name, skills in SKILLS.items():
        print(f"  {name}: {len(skills)}个技能")


def main():
    if len(sys.argv) < 2:
        print("用法: python3 cli.py <command> [options]")
        print("\n命令:")
        print("  list                    - 列出所有分类")
        print("  install <category>      - 安装指定分类")
        print("  install-all             - 安装所有技能")
        print("  setup-env               - 配置 IWENCAI 环境变量")
        print(
            "\n分类: OFFICIAL, THIRD_PARTY, DATA_QUERY, SCREENER, ANALYSIS, MODELING, MNA, PHILOSOPHY"
        )
        sys.exit(1)

    command = sys.argv[1].lower()

    if command == "list":
        list_categories()
    elif command == "install":
        if len(sys.argv) < 3:
            print("用法: python3 cli.py install <category>")
            list_categories()
            sys.exit(1)
        category = sys.argv[2]
        install_category(category)
    elif command == "install-all":
        install_all()
    elif command == "setup-env":
        setup_env()
    else:
        print(f"未知命令: {command}")
        sys.exit(1)


if __name__ == "__main__":
    main()
