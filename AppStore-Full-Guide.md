# 📱 来记个账 - App Store 上架完整材料

**生成时间**: 2026-07-03 21:03
**App 名称**: 来记个账
**Bundle ID**: com.pangtong.WangLaiZhangBen
**版本**: 1.0 (Build 1)

---

## ✅ 已完成检查项目

### 1. App 基本信息 ✅
- [x] **Bundle ID**: `com.pangtong.WangLaiZhangBen` (正确)
- [x] **版本号 (CFBundleShortVersionString)**: `1.0` (已设置)
- [x] **构建版本号 (CFBundleVersion)**: `1` (已设置)
- [x] **部署目标 (iOS Deployment Target)**: `17.0` (已设置)
- [x] **设备方向支持**: 仅竖屏 Portrait (已配置)
- [x] **App 显示名称**: 来记个账 (CFBundleDisplayName 和 CFBundleName)

### 2. App 图标 ✅
- [x] **1024x1024 图标**: 已存在 (`Icon-1024.png`)
- [x] **所有尺寸图标**: 已完整（iPhone + iPad 全套）
- [x] **无 Alpha 通道**: 已确认 (`hasAlpha: no`) ✅
- [x] **图标内容**: 包含"来记个账"文字 + 双人图标 + ¥符号

### 3. 启动画面 ✅
- [x] **UILaunchScreen 配置**: 已修复为空 dict `{}` 格式
- [x] **Info.plist 配置正确**

### 4. Info.plist 权限描述 ✅
- [x] **无需特殊权限**: App 不使用相机、相册、位置等权限
- [x] **无模拟器检测代码**
- [x] **无私有 API 调用**

### 5. 功能和性能 ✅
- [x] **App 无崩溃**: 模拟器测试通过
- [x] **功能完整**: 3 个 Tab（账本/对比/我的）
- [x] **预设数据**: 小美(现任)、前任小王、暧昧对象 + 示例账单
- [x] **UI 符合 Apple 设计规范**: SwiftUI 原生组件

### 6. 代码签名 ✅
- [x] **开发团队**: 已在 project.yml 中配置
- [x] **Team ID**: 2ZNZRXNPWQ
- [x] **签名证书**: Apple Development: pongtom@qq.com (A9BU96SR38)

### 7. 构建验证 ✅
- [x] **Debug 构建**: 成功 ✅
- [x] **Release 构建**: 成功 ✅
- [x] **模拟器运行正常**: 截图已生成
- [x] **编译警告数**: 0
- [x] **编译错误数**: 0

### 8. 项目文件完整性 ✅
- [x] **Swift 源文件** (11 个):
  - WangLaiZhangBenApp.swift (入口)
  - Models/Models.swift (数据模型)
  - ViewModels/AccountViewModel.swift (ViewModel)
  - Utilities/DataManager.swift (数据管理)
  - Utilities/ColorHex.swift (颜色扩展)
  - Views/ContentView.swift (主视图 + BookView + 子视图)
  - Views/PersonBarView.swift (人物切换栏)
  - Views/AddBillView.swift (添加账单)
  - Views/BillRowView.swift (账单行)
  - Views/CompareView.swift (对比排行)
  - Views/MeView.swift (我的页面)
- [x] **Assets.xcassets**: AppIcon 完整
- [x] **Info.plist**: 配置完整

### 9. 隐私政策 ✅
- [x] **隐私政策页面**: 已创建 (`privacy/index.html`)
- [x] **部署地址**: https://e095a6feca2e41578d6f7a366174cdb4.app.codebuddy.work
- [x] **内容完整**: 包含数据收集说明、使用目的、用户权利、联系方式
- [x] **URL 可访问**: 已部署到 CloudStudio

---

## 📝 App Store Connect 填写材料

### 基本信息

| 字段 | 内容 | 状态 |
|------|------|------|
| **App 名称** | 来记个账 | ✅ 已确认 |
| **副标题** | 记录前任现任钱财往来 | ✅ 已准备 |
| **主要类别** | 财务 (Finance) | ✅ 已选择 |
| **次要类别** | 生活 (Lifestyle) | ✅ 已选择 |
| **关键词** | 记账,账本,前任,钱财,AA制,分手,情侣,财务管理 | ✅ 已准备 |
| **版本号** | 1.0 | ✅ 已确认 |
| **构建版本号** | 1 | ✅ 已确认 |

### 描述文本

#### App 描述 (4000 字符以内) 📋

```
来记个账 - 专为记录前任、现任、暧昧对象之间的钱财往来而设计的记账工具。

【核心功能】
• 轻松记录 — 快速记录每一笔钱财往来，支持"我给TA"和"TA给我"两种方向
• 人物管理 — 添加多位人物（前任/现任/暧昧对象），清晰分类管理
• 智能统计 — 自动计算总付出、总收到、净额，一目了然
• 对比排行 — 查看所有人物的付出/收到/净额排行榜
• 账单管理 — 支持滑动删除、点击编辑，轻松管理账单
• 数据本地存储 — 所有数据存储在您的设备本地，保护隐私

【适用场景】
✓ 记录前任的钱财往来，算清账目
✓ 管理现任的共同开销，避免纠纷
✓ 跟踪暧昧对象的经济往来
✓ 任何需要记录个人钱财往来的场景

【特点】
• 界面简洁清新，操作直观
• 支持多人同时记账，自动对比统计
• 示例数据帮助快速上手
• 无需注册登录，打开即用

如有问题或建议，请在 App 内"我的"页面联系反馈。
```

#### 推广文本 (170 字符以内) 📋
```
清晰记录每一笔钱财往来，算清账目，避免纠纷。支持前任/现任/暧昧对象分类管理。
```

#### 技术支持 URL 🌐
```
https://e095a6feca2e41578d6f7a366174cdb4.app.codebuddy.work
```
或邮箱: pongtom@qq.com

#### 隐私政策 URL 🔒
```
https://e095a6feca2e41578d6f7a366174cdb4.app.codebuddy.work
```

#### 版权信息 ©️
```
© 2026 庞通
```

### 年龄分级 🎯

**建议分级: 4+ (适合所有年龄)**

| 问题 | 答案 | 说明 |
|------|------|------|
| 卡通或幻想暴力？ | 否 | - |
| 真实暴力？ | 否 | - |
| 性内容或裸体？ | 否 | - |
| 亵渎或粗俗幽默？ | 否 | - |
| 酒精/烟草/药物使用？ | 否 | - |
| 成人/暗示性主题？ | 否 | - |
| 模拟赌博？ | 否 | - |
| 恐怖/惊悚主题？ | 否 | - |
| 图形性暴力和虐待？ | 否 | - |
| 图形性内容和裸体？ | 否 | - |
| 无限制网络访问？ | 否 | 不访问网页 |
| 赌博和竞赛？ | 否 | - |

### 审核问答 ❓

**问题 1: 出口合规 (Export Compliance)**
> 您的 App 是否使用加密？
>
> **答案: 否 ❌**

**问题 2: 内容版权 (Content Rights)**
> 您的 App 是否包含、显示或访问第三方内容？
>
> **答案: 否 ❌**

**问题 3: 广告标识符 (Advertising Identifier)**
> 您的 App 是否使用广告标识符 (IDFA)？
>
> **答案: 否 ❌**

### App 隐私信息 🔐

#### 收集的数据类型声明

| 数据类型 | 是否收集 | 用途 | 与用户关联 | 用于追踪 |
|----------|----------|------|------------|----------|
| **用户内容** | ✅ 是 | App 功能（记账数据） | 是 | 否 |
| **使用数据** | ❌ 否 | - | - | - |
| **诊断数据** | ❌ 否 | - | - | - |
| **标识符** | ❌ 否 | - | - | - |

#### 隐私政策要点
- ✅ 所有数据存储在**设备本地** (UserDefaults JSON)
- ✅ **不上传云端**
- ✅ **不使用第三方 SDK**
- ✅ **不使用广告追踪**
- ✅ 用户可随时**卸载 App 删除所有数据**

---

## 🖼️ 截图要求与现状

### 当前状态
- [x] **已生成 1 张截图**: `screenshots/screenshot3_after_wait.png` (账本页)
- [ ] **需要补充**: 对比页截图 (1 张)
- [ ] **需要补充**: 我的页面截图 (1 张)
- [ ] **可选补充**: 添加账单页面截图 (1 张)

### 截图规格要求

#### iPhone 6.7" (1290 x 2796 px) - 推荐
- **至少 3 张，最多 10 张**
- 建议截图顺序:
  1. **账本页** - 展示主要功能和人物切换 ✅ 已有
  2. **对比页** - 展示排行榜功能 ⏳ 需要
  3. **我的页面** - 展示个人中心和设置 ⏳ 需要
  4. **添加账单** - 展示操作流程 (可选)

#### iPhone 6.5" (1242 x 2688 px) - 可选
- App Store Connect 会自动缩放，非必需

### 如何获取更多截图

**方法 1: 手动截图 (推荐)**
1. 打开 Xcode 模拟器 (iPhone 17)
2. 运行 App
3. 切换到不同 Tab 页面
4. 按 `Cmd+S` 截图或使用模拟器菜单 Device → Screenshot
5. 保存到 `screenshots/` 目录

**方法 2: 使用已有截图**
- 我已生成的截图位于: `/Users/pangtong/WorkBuddy/2026-06-30-21-00-33/WangLaiZhangBen/screenshots/`
- 文件名: `screenshot3_after_wait.png` (账本页，完整)

---

## 📤 上传二进制 (Archive)

### 步骤 1: 在 Xcode 中 Archive
1. **打开 Xcode** → 打开项目 `WangLaiZhangBen.xcodeproj`
2. **选择设备**: 顶部选择 "Any iOS Device (arm64)"
3. **执行 Archive**: 菜单 → Product → Archive (快捷键 `Cmd+Shift+B`)
4. **等待完成**: Archive 会自动打开 Organizer 窗口

### 步骤 2: Distribute App
1. 在 Organizer 窗口中，选择刚创建的 Archive
2. 点击 **"Distribute App"** 按钮
3. 选择 **"App Store Connect"**
4. 点击 **"Next"**
5. 选择 **"Upload"** (不是 Export)
6. 确保:
   - [x] **Signing**: Automatic (Xcode 自动管理)
   - [x] **Options**: 默认即可
7. 点击 **"Upload"**
8. 等待上传完成（可能需要几分钟）

### 步骤 3: 验证上传
1. 登录 https://appstoreconnect.apple.com
2. 进入你的 App
3. 点击 **"+ 版本或构建版本"**
4. 应该能看到刚刚上传的构建版本
5. 选择该构建版本
6. 状态会变为 "Processing" → "Ready for Review"

---

## 🚀 最终提交审核清单

### 提交前必检项

- [ ] **截图已上传** (至少 3 张)
- [ ] **App 信息已填写** (名称/副标题/描述/关键词)
- [ ] **类别已选择** (财务 + 生活)
- [ ] **年龄分级已完成**
- [ ] **隐私政策 URL 已填写** (可访问)
- [ ] **技术支持 URL 已填写** (可访问)
- [ ] **版权信息已填写**
- [ ] **App 隐私信息已配置**
- [ ] **构建版本已选择并处理完成** (Ready for Review)
- [ ] **推广文本已填写** (可选但推荐)

### 提交审核
1. 点击 **"提交审核"** 按钮
2. 回答 3 个审核问答 (答案见上文)
3. 确认所有信息无误
4. 点击 **"提交"**

### 提交后
- **状态变化**: Waiting for Review → In Review → Ready for Sale / Rejected
- **预计时间**: 通常 24-48 小时
- **如果被拒绝**: 查看拒绝原因，修改后重新提交

---

## ⚠️ 需要你手动完成的操作

根据当前进度，你需要完成以下操作：

### 必须手动完成 🔴

1. **补充截图** (约 10 分钟)
   - 在 Xcode 模拟器中运行 App
   - 切换到"对比"和"我的"标签页
   - 各截取 1 张截图
   - 或者直接使用我生成的 1 张截图 (账本页)

2. **上传二进制** (约 10 分钟)
   - 在 Xcode 中执行 Product → Archive
   - Distribute App → App Store Connect
   - 等待上传完成

3. **填写 App Store Connect** (约 20 分钟)
   - 登录 https://appstoreconnect.apple.com
   - 创建新 App 或选择现有 App
   - 复制粘贴本文档中的所有信息
   - 上传截图
   - 配置隐私信息和年龄分级

4. **提交审核** (约 5 分钟)
   - 点击"提交审核"
   - 回答 3 个问题
   - 确认提交

### 可选手动完成 🟡

5. **优化截图** (可选)
   - 使用设计工具美化截图
   - 添加文字标注说明功能
   - 统一风格

6. **添加预览视频** (可选)
   - 录制 15-30 秒 App 操作视频
   - 展示核心功能流程

---

## 📁 重要文件位置

| 文件/目录 | 路径 | 说明 |
|-----------|------|------|
| **项目根目录** | `/Users/pangtong/WorkBuddy/2026-06-30-21-00-33/WangLaiZhangBen/` | 项目源码 |
| **上架材料** | `AppStoreConnect-Materials.md` | 本文档 |
| **截图目录** | `screenshots/` | 已生成的截图 |
| **隐私政策** | `privacy/index.html` | 隐私政策 HTML |
| **隐私政策 URL** | https://e095a6feca2e41578d6f7a366174cdb4.app.codebuddy.work | 已部署 |
| **图标文件** | `WangLaiZhangBen/Assets.xcassets/AppIcon.appiconset/` | App 图标 |
| **Xcode 项目** | `WangLaiZhangBen.xcodeproj` | Xcode 工程文件 |

---

## 💡 快速参考卡

### App Store Connect 复制粘贴区

**名称**: 来记个账
**副标题**: 记录前任现任钱财往来
**关键词**: 记账,账本,前任,钱财,AA制,分手,情侣,财务管理
**描述**: 见上方完整描述
**推广文本**: 清晰记录每一笔钱财往来，算清账目，避免纠纷。支持前任/现任/暧昧对象分类管理。
**技术支持**: https://e095a6feca2e41578d6f7a366174cdb4.app.codebuddy.work
**隐私政策**: https://e095a6feca2e41578d6f7a366174cdb4.app.codebuddy.work
**版权**: © 2026 庞通
**类别**: 财务 / 生活
**分级**: 4+
**出口合规**: 否
**版权内容**: 否
**IDFA**: 否

---

## 📞 联系方式

如有任何问题：
- **邮箱**: pongtom@qq.com
- **App 内反馈**: 我的页面 → 意见反馈

---

**祝上架顺利！🎉**
