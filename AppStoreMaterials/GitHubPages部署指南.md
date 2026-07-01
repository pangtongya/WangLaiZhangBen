# GitHub Pages 部署指南

## 1. 创建仓库

在 GitHub（pangtongya）上创建一个新的公开仓库：

```
仓库名：WangLaiZhangBen
描述：来记个账 App 官网
类型：Public
```

⚠️ 注意：如果同名仓库已存在（比如 Sourcetree 用的），可以创建仓库 `WangLaiZhangBen-App`，然后以下所有 URL 对应调整。

## 2. 上传文件

```bash
cd /Users/pangtong/WorkBuddy/2026-06-30-21-00-33/WangLaiZhangBen/AppStoreMaterials

# 克隆新建的仓库
git clone https://github.com/pangtongya/WangLaiZhangBen.git gh-pages-temp
cd gh-pages-temp

# 复制页面文件
cp ../index.html .
cp ../privacy.html .

# 提交推送
git add -A
git commit -m "初始化：支持页 + 隐私政策"
git push origin main
```

## 3. 启用 GitHub Pages

1. 打开仓库 Settings → Pages
2. Source 选择 `Deploy from a branch`
3. Branch 选择 `main`，目录选择 `/ (root)`
4. 点击 Save

等待 1-2 分钟后即可访问：

| 用途 | URL |
|------|-----|
| 支持页 | https://pangtongya.github.io/WangLaiZhangBen/ |
| 隐私政策 | https://pangtongya.github.io/WangLaiZhangBen/privacy |
