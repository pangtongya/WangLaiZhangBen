# WangLaiZhangBen (来记个账) 项目记忆

## 项目概述
- 名称：来记个账 (WangLaiZhangBen)
- 类型：iOS SwiftUI App
- Bundle ID: com.pangtong.WangLaiZhangBen
- 定位：记录前任/现任钱财往来的记账工具

## 技术栈
- SwiftUI + Combine
- 数据持久化：UserDefaults (JSON)
- Deployment Target: iOS 17.0
- Swift 5.0

## 项目结构
- Models/Models.swift — Person, BillRecord, Relationship 数据模型
- ViewModels/AccountViewModel.swift — 核心 ViewModel
- Utilities/DataManager.swift — UserDefaults 数据管理
- Utilities/ColorHex.swift — Color hex 扩展
- Views/ — 所有 SwiftUI 视图

## 关键修复记录 (2026-06-30 ~ 2026-07-01)

### 第一轮：编译错误修复 (2026-06-30)
- formatAmount 从 private 改为 internal
- CategoryInfo / PersonStats 添加 Identifiable
- presentationMode → dismiss
- deployment target: 16.0 → 17.0
- Charts 从本地嵌入改为系统 SDK 链接
- pbxproj 清理重复组引用

### 第二轮：核心功能 Bug 修复 (2026-06-30)
- currentPid 不持久化（致命Bug）
- BillRecord ID 碰撞风险
- CompareView 标签语义颠倒
- UIKit AlertController 替换为 SwiftUI .alert
- 新建人物自动切换
- ViewModel 重构：本地数组直接 mutate

### 第三轮：文案逻辑梳理 (2026-06-30)
- CompareView 标题修正
- MeView 空状态文案修正
- formatAmount 全局统一 ¥ 前缀
- BillRowView out 颜色统一为 .red
- 日期中文化：formatChineseDate() 输出 M月d日

### 第四轮：体验升级 (2026-06-30)
- 净额显示重设计：去除前置负号，改为动态标签
- NavigationView→NavigationStack
- 账单滑动删除 + 点击编辑
- 触觉反馈
- MeView 升级：统计卡片、添加按钮

### 第五轮：App 重构 - 前任/现任钱财往来 (2026-07-01)
- 重写架构：3个Tab（账本/对比/我的）
- 新增 PersonBarView：人物切换栏
- 新增 CompareView：排行榜页面（总付出/总收到/净额排行）
- 重写 ContentView：账本页包含人物切换 + 账单列表
- 修改 AddBillView：移除"关联人物"选择（personId 从外部传入）
- 修改 BillRowView：方向标签改为"我给TA"/"TA给我"
- 预设数据：小美（现任）、前任小王、暧昧对象 + 示例账单
- 删除 HomeView.swift 和 StatsView.swift（不再需要）

## 编译状态
- 最后一次编译：2026-07-01 01:20
- 结果：BUILD SUCCEEDED
- 错误数：0
- 警告数：0

## 待办事项
- [ ] 测试 App 运行时功能是否完整
- [ ] 优化 UI 样式和交互体验
