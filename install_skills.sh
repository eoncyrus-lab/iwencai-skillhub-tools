#!/bin/bash
# Aime SkillHub 批量安装脚本
# 用法: ./install_skills.sh [分类名]
# 
# 分类列表:
#   all              - 安装所有技能
#   official         - 官方技能 (27个) + 设置环境变量
#   third-party      - 第三方技能 (77个)
#   data-query       - 数据查询类 (16个)
#   screener         - 选股筛选类 (10个)
#   analysis         - 分析类 (12个)
#   trading          - 交易与组合类 (4个)
#   modeling         - 财务建模类 (6个)
#   reports          - 研究与报告类 (5个)
#   mna              - 并购类 (14个)
#   fixed-income     - 固定收益类 (4个)
#   fx-deriv         - 外汇与衍生品类 (4个)
#   philosophy       - 投资理念类 (7个)
#   tools            - 工具类 (9个)
#   wealth           - 财富管理类 (3个)
#   pe               - 私募类 (2个)
#   fintech          - 金融科技类 (3个)

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

install_skill() {
    local skill_name="$1"
    echo -e "${BLUE}[安装]${NC} $skill_name"
    aime-skillhub-cli install "$skill_name" 2>&1
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[成功]${NC} $skill_name"
    else
        echo -e "${RED}[失败]${NC} $skill_name"
    fi
    echo ""
}

setup_iwencai_env() {
    echo -e "${YELLOW}========================================${NC}"
    echo -e "${YELLOW}设置同花顺 IWENCAI 环境变量${NC}"
    echo -e "${YELLOW}========================================${NC}"
    echo ""
    echo -e "${CYAN}官方技能需要 IWENCAI API Key${NC}"
    echo ""
    echo "获取 API Key:"
    echo "  1. 访问 https://www.iwencai.com/skillhub"
    echo "  2. 登录后随机点击一个官方技能卡片"
    echo "  3. 页面会显示 IWENCAI_BASE_URL 和 IWENCAI_API_KEY"
    echo ""
    read -p "请输入 IWENCAI_BASE_URL: " base_url
    read -p "请输入 IWENCAI_API_KEY: " api_key
    
    if [ -z "$base_url" ]; then
        base_url="https://openapi.iwencai.com"
    fi
    
    if [ -z "$api_key" ]; then
        echo -e "${RED}错误: API Key 不能为空${NC}"
        return 1
    fi
    
    local shell_rc=""
    if [ -f "$HOME/.zshrc" ]; then
        shell_rc="$HOME/.zshrc"
    elif [ -f "$HOME/.bashrc" ]; then
        shell_rc="$HOME/.bashrc"
    else
        shell_rc="$HOME/.profile"
    fi
    
    if grep -q "IWENCAI_BASE_URL" "$shell_rc" 2>/dev/null; then
        sed -i '' "s|^export IWENCAI_BASE_URL=.*|export IWENCAI_BASE_URL=$base_url|" "$shell_rc"
        sed -i '' "s|^export IWENCAI_API_KEY=.*|export IWENCAI_API_KEY=$api_key|" "$shell_rc"
    else
        echo "" >> "$shell_rc"
        echo "# IWENCAI (同花顺)" >> "$shell_rc"
        echo "export IWENCAI_BASE_URL=$base_url" >> "$shell_rc"
        echo "export IWENCAI_API_KEY=$api_key" >> "$shell_rc"
    fi
    
    export IWENCAI_BASE_URL=$base_url
    export IWENCAI_API_KEY=$api_key
    
    echo ""
    echo -e "${GREEN}环境变量已配置到 $shell_rc${NC}"
    echo ""
    echo "当前会话应用环境变量:"
    echo "  IWENCAI_BASE_URL=$IWENCAI_BASE_URL"
    echo "  IWENCAI_API_KEY=${IWENCAI_API_KEY:0:20}..."
    echo ""
    echo -e "${GREEN}配置完成!${NC}"
}

declare -A SKILLS_OFFICIAL=(
    ["行情数据查询"]=""
    ["基本资料查询"]=""
    ["财务数据查询"]=""
    ["事件数据查询"]=""
    ["行业数据查询"]=""
    ["期货期权数据查询"]=""
    ["宏观数据查询"]=""
    ["机构研究与评级查询"]=""
    ["公司股东股本查询"]=""
    ["公司经营数据查询"]=""
    ["指数数据查询"]=""
    ["投资者关系活动搜索"]=""
    ["研报搜索"]=""
    ["公告搜索"]=""
    ["新闻搜索"]=""
    ["问财选A股"]=""
    ["问财选港股"]=""
    ["问财选美股"]=""
    ["问财选ETF"]=""
    ["问财选可转债"]=""
    ["问财选基金经理"]=""
    ["问财选基金公司"]=""
    ["问财选基金"]=""
    ["问财选期货期权"]=""
    ["问财选板块"]=""
    ["模拟炒股"]=""
)

declare -A SKILLS_THIRD_PARTY=(
    ["流程函"]=""
    ["融资摘要"]=""
    ["外汇套息交易分析"]=""
    ["投行材料质检"]=""
    ["《股票大作手》交易哲学"]=""
    ["首次覆盖报告"]=""
    ["杠杆收购模型"]=""
    ["晨会纪要"]=""
    ["路演材料填充"]=""
    ["期权波动率分析"]=""
    ["量化因子选股"]=""
    ["市场情绪偏离分析"]=""
    ["公司单页"]=""
    ["捕捉公司事件机会"]=""
    ["现金流折现估值模型"]=""
    ["外汇"]=""
    ["桥水基金决策术"]=""
    ["催化剂日历"]=""
    ["富爸爸财商课"]=""
    ["指数投资鼻祖视野"]=""
    ["交易心理通关秘籍"]=""
    ["全球资管旗舰策略"]=""
    ["方舟颠覆性投资前瞻"]=""
    ["价值创造计划"]=""
    ["单元经济模型"]=""
    ["投资逻辑跟踪"]=""
    ["低估值好股搜寻"]=""
    ["匿名项目预告"]=""
    ["科技炒作与基本面"]=""
    ["税损收割"]=""
    ["掉期曲线策略"]=""
    ["公司画像页"]=""
    ["投资者风险评估"]=""
    ["小盘成长股挖掘"]=""
    ["行业轮动监控"]=""
    ["行业概览"]=""
    ["风险收益优化配置"]=""
    ["回报敏感性分析"]=""
    ["演示文稿模板技能创建"]=""
    ["股票研究"]=""
    ["财报前瞻报告测试版"]=""
    ["组合再平衡"]=""
    ["投后监控"]=""
    ["投资组合诊断"]=""
    ["模型更新"]=""
    ["并购模型"]=""
    ["宏观利率监控"]=""
    ["监管内幕交易追踪"]=""
    ["投资提案"]=""
    ["投委会备忘录"]=""
    ["投资想法生成"]=""
    ["高分红股挑选"]=""
    ["固定收益组合分析"]=""
    ["上市公司财报体检"]=""
    ["财务规划"]=""
    ["环境社会治理投资筛选"]=""
    ["财报前瞻"]=""
    ["演示文稿刷新"]=""
    ["项目跟踪"]=""
    ["项目拓源"]=""
    ["项目初筛"]=""
    ["尽调会议准备"]=""
    ["尽调清单"]=""
    ["投委会数据包构建"]=""
    ["可比公司分析"]=""
    ["竞争格局分析"]=""
    ["客户回顾会材料"]=""
    ["客户业绩报告"]=""
    ["债券期货基差分析"]=""
    ["电子表格数据清洗"]=""
    ["三表模型"]=""
    ["保密信息备忘录构建"]=""
    ["潜在买方清单"]=""
    ["债券相对价值分析"]=""
    ["电子表格审计"]=""
    ["人工智能就绪度评估"]=""
    ["产业链解读"]=""
)

declare -A SKILLS_DATA_QUERY=(
    ["行情数据查询"]=""
    ["基本资料查询"]=""
    ["财务数据查询"]=""
    ["事件数据查询"]=""
    ["行业数据查询"]=""
    ["期货期权数据查询"]=""
    ["宏观数据查询"]=""
    ["机构研究与评级查询"]=""
    ["公司股东股本查询"]=""
    ["公司经营数据查询"]=""
    ["指数数据查询"]=""
    ["投资者关系活动搜索"]=""
    ["研报搜索"]=""
    ["公告搜索"]=""
    ["新闻搜索"]=""
)

declare -A SKILLS_SCREENER=(
    ["问财选A股"]=""
    ["问财选港股"]=""
    ["问财选美股"]=""
    ["问财选ETF"]=""
    ["问财选可转债"]=""
    ["问财选基金经理"]=""
    ["问财选基金公司"]=""
    ["问财选基金"]=""
    ["问财选期货期权"]=""
    ["问财选板块"]=""
)

declare -A SKILLS_ANALYSIS=(
    ["量化因子选股"]=""
    ["市场情绪偏离分析"]=""
    ["科技炒作与基本面"]=""
    ["低估值好股搜寻"]=""
    ["小盘成长股挖掘"]=""
    ["高分红股挑选"]=""
    ["上市公司财报体检"]=""
    ["监管内幕交易追踪"]=""
    ["捕捉公司事件机会"]=""
    ["行业轮动监控"]=""
    ["产业链解读"]=""
    ["环境社会治理投资筛选"]=""
)

declare -A SKILLS_TRADING=(
    ["模拟炒股"]=""
    ["组合再平衡"]=""
    ["投资组合诊断"]=""
    ["风险收益优化配置"]=""
)

declare -A SKILLS_MODELING=(
    ["现金流折现估值模型"]=""
    ["并购模型"]=""
    ["杠杆收购模型"]=""
    ["三表模型"]=""
    ["回报敏感性分析"]=""
    ["单元经济模型"]=""
)

declare -A SKILLS_REPORTS=(
    ["首次覆盖报告"]=""
    ["股票研究"]=""
    ["财报前瞻"]=""
    ["财报前瞻报告测试版"]=""
    ["行业概览"]=""
)

declare -A SKILLS_MNA=(
    ["流程函"]=""
    ["保密信息备忘录构建"]=""
    ["潜在买方清单"]=""
    ["匿名项目预告"]=""
    ["尽调清单"]=""
    ["尽调会议准备"]=""
    ["项目初筛"]=""
    ["项目拓源"]=""
    ["项目跟踪"]=""
    ["投委会备忘录"]=""
    ["投委会数据包构建"]=""
    ["可比公司分析"]=""
    ["竞争格局分析"]=""
)

declare -A SKILLS_FIXED_INCOME=(
    ["债券相对价值分析"]=""
    ["债券期货基差分析"]=""
    ["固定收益组合分析"]=""
    ["宏观利率监控"]=""
)

declare -A SKILLS_FX_DERIV=(
    ["外汇"]=""
    ["外汇套息交易分析"]=""
    ["期权波动率分析"]=""
    ["掉期曲线策略"]=""
)

declare -A SKILLS_PHILOSOPHY=(
    ["《股票大作手》交易哲学"]=""
    ["桥水基金决策术"]=""
    ["富爸爸财商课"]=""
    ["指数投资鼻祖视野"]=""
    ["交易心理通关秘籍"]=""
    ["全球资管旗舰策略"]=""
    ["方舟颠覆性投资前瞻"]=""
)

declare -A SKILLS_TOOLS=(
    ["融资摘要"]=""
    ["路演材料填充"]=""
    ["演示文稿刷新"]=""
    ["演示文稿模板技能创建"]=""
    ["投行材料质检"]=""
    ["晨会纪要"]=""
    ["催化剂日历"]=""
    ["税损收割"]=""
    ["电子表格数据清洗"]=""
)

declare -A SKILLS_WEALTH=(
    ["财务规划"]=""
    ["客户业绩报告"]=""
    ["客户回顾会材料"]=""
)

declare -A SKILLS_PE=(
    ["价值创造计划"]=""
    ["投后监控"]=""
)

declare -A SKILLS_FINTECH=(
    ["人工智能就绪度评估"]=""
    ["电子表格审计"]=""
)

install_category() {
    local category=$1
    local skills_name="SKILLS_${category}"
    local -n skills_ref=$skills_name
    
    echo -e "${YELLOW}========================================${NC}"
    echo -e "${YELLOW}安装分类: $category${NC}"
    echo -e "${YELLOW}========================================${NC}"
    echo ""
    
    for skill in "${!skills_ref[@]}"; do
        install_skill "$skill"
    done
}

install_all() {
    echo -e "${YELLOW}========================================${NC}"
    echo -e "${YELLOW}安装所有技能 (共104个)${NC}"
    echo -e "${YELLOW}========================================${NC}"
    echo ""
    
    local categories=(
        "OFFICIAL"
        "THIRD_PARTY"
    )
    
    for cat in "${categories[@]}"; do
        install_category "$cat"
    done
}

install_official_with_env() {
    echo -e "${YELLOW}========================================${NC}"
    echo -e "${YELLOW}安装官方技能 + 配置环境变量${NC}"
    echo -e "${YELLOW}========================================${NC}"
    echo ""
    
    setup_iwencai_env
    
    echo ""
    echo -e "${YELLOW}开始安装官方技能...${NC}"
    echo ""
    install_category "OFFICIAL"
}

show_help() {
    echo "Aime SkillHub 批量安装脚本"
    echo ""
    echo "用法: $0 [分类名]"
    echo ""
    echo "可用分类:"
    echo "  all              - 安装所有技能 (104个)"
    echo "  official         - 官方技能 (27个) + 设置环境变量"
    echo "  third-party      - 第三方技能 (77个)"
    echo "  data-query       - 数据查询类 (16个)"
    echo "  screener         - 选股筛选类 (10个)"
    echo "  analysis         - 分析类 (12个)"
    echo "  trading          - 交易与组合类 (4个)"
    echo "  modeling         - 财务建模类 (6个)"
    echo "  reports          - 研究与报告类 (5个)"
    echo "  mna              - 并购类 (14个)"
    echo "  fixed-income     - 固定收益类 (4个)"
    echo "  fx-deriv         - 外汇与衍生品类 (4个)"
    echo "  philosophy       - 投资理念类 (7个)"
    echo "  tools            - 工具类 (9个)"
    echo "  wealth           - 财富管理类 (3个)"
    echo "  pe               - 私募类 (2个)"
    echo "  fintech          - 金融科技类 (3个)"
    echo ""
    echo "示例:"
    echo "  $0 official              # 安装官方技能并设置环境变量"
    echo "  $0 third-party           # 安装第三方技能"
    echo "  $0 all                   # 安装所有技能"
    echo "  $0 data-query screener   # 安装多个分类"
}

case "$1" in
    all)
        install_all
        ;;
    official)
        install_official_with_env
        ;;
    third-party)
        install_category "THIRD_PARTY"
        ;;
    data-query)
        install_category "DATA_QUERY"
        ;;
    screener)
        install_category "SCREENER"
        ;;
    analysis)
        install_category "ANALYSIS"
        ;;
    trading)
        install_category "TRADING"
        ;;
    modeling)
        install_category "MODELING"
        ;;
    reports)
        install_category "REPORTS"
        ;;
    mna)
        install_category "MNA"
        ;;
    fixed-income)
        install_category "FIXED_INCOME"
        ;;
    fx-deriv)
        install_category "FX_DERIV"
        ;;
    philosophy)
        install_category "PHILOSOPHY"
        ;;
    tools)
        install_category "TOOLS"
        ;;
    wealth)
        install_category "WEALTH"
        ;;
    pe)
        install_category "PE"
        ;;
    fintech)
        install_category "FINTECH"
        ;;
    *)
        show_help
        ;;
esac

echo -e "${GREEN}安装完成!${NC}"
    ["行情数据查询"]=""
    ["基本资料查询"]=""
    ["财务数据查询"]=""
    ["事件数据查询"]=""
    ["行业数据查询"]=""
    ["期货期权数据查询"]=""
    ["宏观数据查询"]=""
    ["机构研究与评级查询"]=""
    ["公司股东股本查询"]=""
    ["公司经营数据查询"]=""
    ["指数数据查询"]=""
    ["投资者关系活动搜索"]=""
    ["研报搜索"]=""
    ["公告搜索"]=""
    ["新闻搜索"]=""
)

declare -A SKILLS_SCREENER=(
    ["问财选A股"]=""
    ["问财选港股"]=""
    ["问财选美股"]=""
    ["问财选ETF"]=""
    ["问财选可转债"]=""
    ["问财选基金经理"]=""
    ["问财选基金公司"]=""
    ["问财选基金"]=""
    ["问财选期货期权"]=""
    ["问财选板块"]=""
)

declare -A SKILLS_ANALYSIS=(
    ["量化因子选股"]=""
    ["市场情绪偏离分析"]=""
    ["科技炒作与基本面"]=""
    ["低估值好股搜寻"]=""
    ["小盘成长股挖掘"]=""
    ["高分红股挑选"]=""
    ["上市公司财报体检"]=""
    ["监管内幕交易追踪"]=""
    ["捕捉公司事件机会"]=""
    ["行业轮动监控"]=""
    ["产业链解读"]=""
    ["环境社会治理投资筛选"]=""
)

declare -A SKILLS_TRADING=(
    ["模拟炒股"]=""
    ["组合再平衡"]=""
    ["投资组合诊断"]=""
    ["风险收益优化配置"]=""
)

declare -A SKILLS_MODELING=(
    ["现金流折现估值模型"]=""
    ["并购模型"]=""
    ["杠杆收购模型"]=""
    ["三表模型"]=""
    ["回报敏感性分析"]=""
    ["单元经济模型"]=""
)

declare -A SKILLS_REPORTS=(
    ["首次覆盖报告"]=""
    ["股票研究"]=""
    ["财报前瞻"]=""
    ["财报前瞻报告测试版"]=""
    ["行业概览"]=""
)

declare -A SKILLS_MNA=(
    ["流程函"]=""
    ["保密信息备忘录构建"]=""
    ["潜在买方清单"]=""
    ["匿名项目预告"]=""
    ["尽调清单"]=""
    ["尽调会议准备"]=""
    ["项目初筛"]=""
    ["项目拓源"]=""
    ["项目跟踪"]=""
    ["投委会备忘录"]=""
    ["投委会数据包构建"]=""
    ["可比公司分析"]=""
    ["竞争格局分析"]=""
)

declare -A SKILLS_FIXED_INCOME=(
    ["债券相对价值分析"]=""
    ["债券期货基差分析"]=""
    ["固定收益组合分析"]=""
    ["宏观利率监控"]=""
)

declare -A SKILLS_FX_DERIV=(
    ["外汇"]=""
    ["外汇套息交易分析"]=""
    ["期权波动率分析"]=""
    ["掉期曲线策略"]=""
)

declare -A SKILLS_PHILOSOPHY=(
    ["《股票大作手》交易哲学"]=""
    ["桥水基金决策术"]=""
    ["富爸爸财商课"]=""
    ["指数投资鼻祖视野"]=""
    ["交易心理通关秘籍"]=""
    ["全球资管旗舰策略"]=""
    ["方舟颠覆性投资前瞻"]=""
)

declare -A SKILLS_TOOLS=(
    ["融资摘要"]=""
    ["路演材料填充"]=""
    ["演示文稿刷新"]=""
    ["演示文稿模板技能创建"]=""
    ["投行材料质检"]=""
    ["晨会纪要"]=""
    ["催化剂日历"]=""
    ["税损收割"]=""
    ["电子表格数据清洗"]=""
)

declare -A SKILLS_WEALTH=(
    ["财务规划"]=""
    ["客户业绩报告"]=""
    ["客户回顾会材料"]=""
)

declare -A SKILLS_PE=(
    ["价值创造计划"]=""
    ["投后监控"]=""
)

declare -A SKILLS_FINTECH=(
    ["人工智能就绪度评估"]=""
    ["电子表格审计"]=""
)

# 安装指定分类
install_category() {
    local category=$1
    local skills_name="SKILLS_${category}"
    
    echo -e "${YELLOW}========================================${NC}"
    echo -e "${YELLOW}安装分类: $category${NC}"
    echo -e "${YELLOW}========================================${NC}"
    echo ""
    
    # 动态获取关联数组
    local -n skills_ref=$skills_name
    
    for skill in "${!skills_ref[@]}"; do
        install_skill "$skill"
    done
}

# 安装所有技能
install_all() {
    echo -e "${YELLOW}========================================${NC}"
    echo -e "${YELLOW}安装所有技能 (共104个)${NC}"
    echo -e "${YELLOW}========================================${NC}"
    echo ""
    
    local categories=(
        "DATA_QUERY"
        "SCREENER"
        "ANALYSIS"
        "TRADING"
        "MODELING"
        "REPORTS"
        "MNA"
        "FIXED_INCOME"
        "FX_DERIV"
        "PHILOSOPHY"
        "TOOLS"
        "WEALTH"
        "PE"
        "FINTECH"
    )
    
    for cat in "${categories[@]}"; do
        install_category "$cat"
    done
}

# 显示帮助
show_help() {
    echo "Aime SkillHub 批量安装脚本"
    echo ""
    echo "用法: $0 [分类名]"
    echo ""
    echo "可用分类:"
    echo "  all          - 安装所有技能 (104个)"
    echo "  data-query   - 数据查询类 (16个)"
    echo "  screener     - 选股筛选类 (10个)"
    echo "  analysis     - 分析类 (12个)"
    echo "  trading      - 交易与组合类 (4个)"
    echo "  modeling     - 财务建模类 (6个)"
    echo "  reports      - 研究与报告类 (5个)"
    echo "  mna          - 并购类 (14个)"
    echo "  fixed-income - 固定收益类 (4个)"
    echo "  fx-deriv     - 外汇与衍生品类 (4个)"
    echo "  philosophy   - 投资理念类 (7个)"
    echo "  tools        - 工具类 (9个)"
    echo "  wealth       - 财富管理类 (3个)"
    echo "  pe           - 私募类 (2个)"
    echo "  fintech      - 金融科技类 (3个)"
    echo ""
    echo "示例:"
    echo "  $0 all                    # 安装所有技能"
    echo "  $0 data-query             # 仅安装数据查询类"
    echo "  $0 screener analysis      # 安装选股筛选类和分析类"
}

# 主逻辑
case "$1" in
    all)
        install_all
        ;;
    data-query)
        install_category "DATA_QUERY"
        ;;
    screener)
        install_category "SCREENER"
        ;;
    analysis)
        install_category "ANALYSIS"
        ;;
    trading)
        install_category "TRADING"
        ;;
    modeling)
        install_category "MODELING"
        ;;
    reports)
        install_category "REPORTS"
        ;;
    mna)
        install_category "MNA"
        ;;
    fixed-income)
        install_category "FIXED_INCOME"
        ;;
    fx-deriv)
        install_category "FX_DERIV"
        ;;
    philosophy)
        install_category "PHILOSOPHY"
        ;;
    tools)
        install_category "TOOLS"
        ;;
    wealth)
        install_category "WEALTH"
        ;;
    pe)
        install_category "PE"
        ;;
    fintech)
        install_category "FINTECH"
        ;;
    *)
        show_help
        ;;
esac

echo -e "${GREEN}安装完成!${NC}"
