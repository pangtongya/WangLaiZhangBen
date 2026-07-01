# 往来账本 iOS App - 使用说明

## 项目文件已创建完成

所有 Swift 源文件已创建在 `WangLaiZhangBen` 文件夹中。

## 如何在 Xcode 中打开

### 方法一：手动创建 Xcode 项目（推荐）

1. **打开 Xcode**，选择 "Create New Project"
2. 选择 **iOS** → **App**
3. 填写项目信息：
   - Product Name: `WangLaiZhangBen`
   - Team: 选择你的开发者账号（如果没有可以选择 None）
   - Organization Identifier: `com.yourname`（随意填写）
   - Interface: **SwiftUI**
   - Language: **Swift**
4. 点击 **Next**，选择保存位置，建议保存到：
   ```
   /Users/pangtong/WorkBuddy/2026-06-30-21-00-33/WangLaiZhangBen/
   ```
   （注意：不要覆盖现有的 WangLaiZhangBen 文件夹，可以选择上层目录）
5. 创建完成后，Xcode 会自动打开项目

### 方法二：使用已有的文件

如果你已经按照方法一创建了项目，现在需要把我的代码文件添加进去：

1. 在 Xcode 中，右键点击项目导航器中的 `WangLaiZhangBen` 文件夹
2. 选择 **Add Files to "WangLaiZhangBen"...**
3. 选择以下文件夹中的所有文件：
   - `/Users/pangtong/WorkBuddy/2026-06-30-21-00-33/WangLaiZhangBen/WangLaiZhangBen/Models/`
   - `/Users/pangtong/WorkBuddy/2026-06-30-21-00-33/WangLaiZhangBen/WangLaiZhangBen/Views/`
   - `/Users/pangtong/WorkBuddy/2026-06-30-21-00-33/WangLaiZhangBen/WangLaiZhangBen/ViewModels/`
   - `/Users/pangtong/WorkBuddy/2026-06-30-21-00-33/WangLaiZhangBen/WangLaiZhangBen/Utilities/`
4. 确保勾选 "Copy items if needed"
5. 点击 **Add**

### 方法三：直接复制代码（最快）

1. 在 Xcode 中创建新项目（参考方法一）
2. 打开以下文件，**用我创建的文件内容替换** Xcode 自动生成的文件：
   - `WangLaiZhangBenApp.swift` - 替换项目入口文件
   - `ContentView.swift` - 替换默认内容视图
3. 然后**新建文件**（File → New → File），创建以下文件，并把我生成的内容复制进去：
   - `Models/Models.swift`
   - `ViewModels/AccountViewModel.swift`
   - `Views/PersonBarView.swift`
   - `Views/SummaryCardView.swift`
   - `Views/BillListView.swift`
   - `Views/CompareView.swift`
   - `Views/MeView.swift`
   - `Views/AddBillView.swift`
   - `Views/PersonEditView.swift`
   - `Utilities/DataManager.swift`
   - `Utilities/ColorHex.swift`

## 项目结构

```
WangLaiZhangBen/
├── WangLaiZhangBenApp.swift     # App 入口
├── ContentView.swift            # 主界面（TabView）
├── Models/
│   └── Models.swift           # 数据模型（Person, BillRecord）
├── ViewModels/
│   └── AccountViewModel.swift # 业务逻辑
├── Views/
│   ├── PersonBarView.swift   # 人物切换条
│   ├── SummaryCardView.swift # 净额卡片
│   ├── BillListView.swift    # 账单列表
│   ├── CompareView.swift     # 对比页面
│   ├── MeView.swift          # 我的页面
│   ├── AddBillView.swift     # 添加账单
│   └── PersonEditView.swift # 编辑人物
└── Utilities/
    ├── DataManager.swift      # 数据管理（UserDefaults）
    └── ColorHex.swift       # Color Hex 扩展
```

## 功能说明

这个 App 完全还原了你的网页版功能：

1. **账目页面**：
   - 顶部人物切换条（点击切换，长按编辑）
   - 显示当前人物的净额、总付出、总收得
   - 往来记录列表
   - 点击 + 按钮添加账单

2. **对比页面**：
   - 总付出对比（谁花钱多）
   - 总收得对比（谁拿得多）
   - 净额对比
   - 支出分类饼图
   - 综合排行

3. **我的页面**：
   - 人物管理（添加/编辑/删除）
   - 数据导出（JSON 格式）
   - 数据导入

4. **其他功能**：
   - 首次打开自动加载示例数据
   - 引导横幅（可关闭）
   - 数据保存在本地（UserDefaults）

## 注意事项

1. **iOS 版本要求**：iOS 16.0+（因为使用了 `NavigationView` 和一些新特性）
2. **数据持久化**：使用 `UserDefaults` 存储，数据保存在本地设备
3. **图表功能**：对比页面使用了 `Charts` 框架（iOS 16+）

## 如果需要修改 Bundle Identifier

在 Xcode 中：
1. 点击左侧项目导航器顶部的项目名
2. 在 TARGETS 中选择 `WangLaiZhangBen`
3. 修改 **Bundle Identifier**（例如：`com.pangtong.WangLaiZhangBen`）

## 运行项目

1. 选择模拟器（例如 iPhone 15 Pro）
2. 点击 Xcode 左上角的 **Play** 按钮（或按 Cmd + R）
3. 等待编译完成，模拟器会自动启动

## 常见问题

### Q: 编译报错 "Cannot find type 'xxx' in scope"
A: 确保所有文件都已正确添加到项目中，并且 Target Membership 已勾选。

### Q: 预览不工作
A: 在 Xcode 中打开 `ContentView.swift`，然后点击 Editor → Canvas 显示预览。

### Q: 想要真机运行
A: 需要：
1. 注册 Apple Developer（免费账号即可）
2. 在 Xcode 中登录你的 Apple ID
3. 连接 iPhone，选择设备作为运行目标
4. 可能需要修改 Bundle Identifier 和签名设置

---

**祝你使用愉快！** 如果有任何问题，可以随时问我。
