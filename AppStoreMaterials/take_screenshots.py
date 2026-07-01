#!/usr/bin/env python3
"""App Store 截图采集脚本 - 启动模拟器并截取 4 个页面"""

import subprocess
import time
import os
import sys

SIM_NAME = "iPhone 17 Pro Max"
APP_PATH = "/Users/pangtong/Library/Developer/Xcode/DerivedData/WangLaiZhangBen-eiieilqpwblebkdsvikcsrhymkmb/Build/Products/Debug-iphonesimulator/WangLaiZhangBen.app"
BUNDLE_ID = "com.pangtong.WangLaiZhangBen"
OUTPUT_DIR = "/Users/pangtong/WorkBuddy/2026-06-30-21-00-33/WangLaiZhangBen/AppStoreMaterials/Screenshots"

os.makedirs(OUTPUT_DIR, exist_ok=True)

def run(cmd, timeout=120, check=True):
    """运行命令，返回 (returncode, stdout, stderr)"""
    print(f"  RUN: {' '.join(cmd[:5])}...")
    try:
        r = subprocess.run(cmd, capture_output=True, text=True, timeout=timeout)
        if r.stdout.strip():
            print(f"  OUT: {r.stdout.strip()[:200]}")
        if r.stderr.strip():
            print(f"  ERR: {r.stderr.strip()[:200]}")
        if check and r.returncode != 0:
            print(f"  WARN: exit code {r.returncode}")
        return r.returncode, r.stdout, r.stderr
    except subprocess.TimeoutExpired:
        print(f"  TIMEOUT after {timeout}s")
        return -1, "", "timeout"
    except Exception as e:
        print(f"  ERROR: {e}")
        return -1, "", str(e)

def get_udid():
    """获取 iPhone 17 Pro Max 的 UDID"""
    _, out, _ = run(["xcrun", "simctl", "list", "devices"], timeout=10)
    for line in out.split('\n'):
        if SIM_NAME in line and '(' in line:
            udid = line.split('(')[1].split(')')[0].strip()
            print(f"Found UDID: {udid}")
            return udid
    return None

def is_booted(udid):
    """检查设备是否已启动"""
    _, out, _ = run(["xcrun", "simctl", "list", "devices"], timeout=10, check=False)
    for line in out.split('\n'):
        if udid in line and 'Booted' in line:
            return True
    return False

def main():
    print("=" * 50)
    print("App Store 截图采集脚本")
    print("=" * 50)

    udid = get_udid()
    if not udid:
        print("ERROR: 找不到 iPhone 17 Pro Max")
        sys.exit(1)

    # Step 1: 启动模拟器
    if not is_booted(udid):
        print("\n[1/5] 启动模拟器...")
        open -a Simulator
        time.sleep(2)
        run(["xcrun", "simctl", "boot", udid], timeout=60)
        time.sleep(15)  # 等待完全启动
        print("  模拟器已启动")
    else:
        print("\n[1/5] 模拟器已在运行")

    # Step 2: 安装 App
    print("\n[2/5] 安装 App...")
    run(["xcrun", "simctl", "install", udid, APP_PATH], timeout=60)
    print("  App 已安装")

    # Step 3: 清理状态栏
    print("\n[3/5] 清理状态栏...")
    run(["xcrun", "simctl", "status_bar", udid, "override",
         "--time", "9:41",
         "--dataNetwork", "wifi",
         "--wifiMode", "active",
         "--wifiBars", "3",
         "--cellularMode", "active",
         "--cellularBars", "4",
         "--batteryState", "charged",
         "--batteryLevel", "100"], timeout=10, check=False)
    print("  状态栏已清理")

    # Step 4: 启动 App
    print("\n[4/5] 启动 App...")
    run(["xcrun", "simctl", "terminate", udid, BUNDLE_ID], timeout=5, check=False)
    time.sleep(1)
    run(["xcrun", "simctl", "launch", udid, BUNDLE_ID], timeout=15)
    time.sleep(5)  # 等待 App 启动

    # Step 5: 逐页截图
    print("\n[5/5] 截图...")

    screenshots = [
        ("01_账本主页", "账本 Tab - 人物卡片 + 账单列表"),
        ("02_对比排行", "对比 Tab - 三个排行榜"),
        ("03_我的页面", "我的 Tab - 人物档案 + 数据总览"),
        ("04_记账页面", "记账页 - 双输入框 + 分类选择"),
    ]

    for idx, (filename, desc) in enumerate(screenshots):
        filepath = os.path.join(OUTPUT_DIR, f"{filename}.png")
        print(f"  截图 {idx+1}/4: {desc}")
        if idx > 0:
            time.sleep(1)
        run(["xcrun", "simctl", "io", udid, "screenshot", filepath], timeout=15)
        print(f"    保存: {filepath}")

    # 恢复状态栏
    print("\n清理状态栏...")
    run(["xcrun", "simctl", "status_bar", udid, "clear"], timeout=5, check=False)

    print("\n" + "=" * 50)
    print("截图完成！文件保存在：")
    print(f"  {OUTPUT_DIR}")
    print("=" * 50)

if __name__ == "__main__":
    main()
