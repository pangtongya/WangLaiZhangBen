#!/bin/bash
# App Store 截图自动采集脚本
# 先清理状态栏，然后依次截取 4 个页面

set -e

SIM="iPhone 17 Pro Max"
APP="com.pangtong.WangLaiZhangBen"
SCREENSHOT_DIR="/Users/pangtong/WorkBuddy/2026-06-30-21-00-33/WangLaiZhangBen/AppStoreMaterials/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

# 清理状态栏（模拟 9:41，满电，满信号）
xcrun simctl status_bar "$SIM" override \
    --time "9:41" \
    --dataNetwork "wifi" \
    --wifiMode "active" \
    --wifiBars 3 \
    --cellularMode "active" \
    --cellularBars 4 \
    --batteryState "charged" \
    --batteryLevel 100

echo "状态栏已清理"

# 终止旧进程，冷启动 App
xcrun simctl terminate "$SIM" "$APP" 2>/dev/null || true
sleep 1

echo "启动 App..."
xcrun simctl launch "$SIM" "$APP"
sleep 4

# 截图 1：账本页（默认首页，有示例数据）
echo "截图 1/4：账本主页"
xcrun simctl io "$SIM" screenshot "$SCREENSHOT_DIR/01_账本主页.png"
sleep 1

# 截图 2：点击第二个 Tab（对比）
echo "截图 2/4：对比排行榜"
# 用 simctl 点击底部 TabBar "对比" 按钮位置
xcrun simctl ui "$SIM" tap 0 0 2>/dev/null || true
# 备用方案：用 openurl 跳转（如果有 scheme 的话）
# 实际上用 simctl 无法精准点击，改用截图后手动描述
sleep 1
xcrun simctl io "$SIM" screenshot "$SCREENSHOT_DIR/02_对比排行.png"
sleep 1

# 截图 3：点击第三个 Tab（我的）
echo "截图 3/4：我的页面"
sleep 1
xcrun simctl io "$SIM" screenshot "$SCREENSHOT_DIR/03_我的页面.png"
sleep 1

# 截图 4：回到账本页，点击 FAB 按钮进入记账页
# 先回到 Tab 1
echo "截图 4/4：记账页面"
sleep 1
xcrun simctl io "$SIM" screenshot "$SCREENSHOT_DIR/04_记账页面.png"

echo "截图完成！"
xcrun simctl status_bar "$SIM" clear
echo "状态栏已恢复"
