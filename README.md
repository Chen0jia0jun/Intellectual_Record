# 体重管理APP开发总结

## 项目概述

本项目是一款运行在鸿蒙系统（HarmonyOS）上的体重管理移动应用程序，旨在帮助用户科学地管理自身体重，追踪减肥进度，并提供准确的身体健康指标计算功能。

## 已完成的功能模块

### 1. 数据模型

**文件位置**: `entry/src/main/ets/models/UserModel.ts`

包含以下数据模型：

- **UserInfo** - 用户信息
  - id: 用户标识
  - gender: 性别（男/女）
  - age: 年龄
  - height: 身高（厘米）
  - initialWeight: 初始体重
  - targetWeight: 目标体重

- **WeightRecord** - 体重记录
  - id: 记录标识
  - weight: 体重值（公斤）
  - timestamp: 记录时间戳
  - remark: 备注信息

- **UserSettings** - 用户设置
  - reminderEnabled: 提醒开关状态
  - reminderTime: 提醒时间

### 2. 业务服务层

**文件位置**: `entry/src/main/ets/services/`

| 服务文件 | 功能说明 |
|---------|---------|
| UserService.ts | 用户信息管理（增删改查） |
| WeightService.ts | 体重记录CRUD操作 |
| BMIService.ts | BMI计算（标准公式 + 体型分类） |
| BMRService.ts | 基础代谢率计算（Mifflin-St Jeor公式） |
| NotificationService.ts | 定时提醒功能 |
| ServiceManager.ts | 服务统一管理器 |

#### BMI计算公式
```
BMI = 体重(kg) / 身高(m)²
```
体型分类标准（中国标准）：
- 偏瘦：BMI < 18.5
- 正常：18.5 ≤ BMI < 24
- 超重：24 ≤ BMI < 28
- 肥胖：BMI ≥ 28

#### BMR计算公式（Mifflin-St Jeor）
```
男性: BMR = 88.362 + (13.397 × 体重) + (4.799 × 身高) - (5.677 × 年龄)
女性: BMR = 447.593 + (9.247 × 体重) + (3.098 × 身高) - (4.330 × 年龄)
```

### 3. 视图模型层

**文件位置**: `entry/src/main/ets/viewmodels/`

| 视图模型 | 职责 |
|---------|------|
| HomeViewModel | 首页数据处理、BMI/BMR计算、进度计算 |
| RecordViewModel | 记录页逻辑、数据验证、CRUD操作 |
| ChartViewModel | 趋势数据处理、统计分析 |
| SettingsViewModel | 设置页逻辑、用户信息管理 |

### 4. 页面模块

**文件位置**: `entry/src/main/ets/pages/`

| 页面文件 | 功能说明 |
|---------|---------|
| Welcome.ets | 欢迎页，分步引导用户录入基本信息 |
| Index.ets | 首页，显示当前体重、健康指标、进度卡片 |
| Record.ets | 记录页，添加记录 + 历史记录列表 |
| Chart.ets | 趋势页，折线图 + 统计信息 |
| Settings.ets | 设置页，用户信息编辑 + 提醒设置 |

### 5. 配置文件

| 配置文件 | 说明 |
|---------|------|
| main_pages.json | 路由页面配置 |
| module.json5 | 模块配置（含提醒权限声明） |
| string.json | 字符串资源 |
| EntryAbility.ts | 应用入口，初始化服务 |

## 项目目录结构

```
entry/src/main/ets/
├── entryability/
│   └── EntryAbility.ts          # 应用入口
├── models/
│   └── UserModel.ts             # 数据模型
├── services/
│   ├── UserService.ts           # 用户服务
│   ├── WeightService.ts         # 体重服务
│   ├── BMIService.ts            # BMI计算服务
│   ├── BMRService.ts            # BMR计算服务
│   ├── NotificationService.ts   # 通知服务
│   └── ServiceManager.ts        # 服务管理器
├── viewmodels/
│   ├── HomeViewModel.ts         # 首页视图模型
│   ├── RecordViewModel.ts       # 记录页视图模型
│   ├── ChartViewModel.ts        # 趋势页视图模型
│   └── SettingsViewModel.ts     # 设置页视图模型
├── pages/
│   ├── Welcome.ets              # 欢迎页
│   ├── Index.ets                # 首页
│   ├── Record.ets              # 记录页
│   ├── Chart.ets                # 趋势页
│   └── Settings.ets            # 设置页
└── utils/
    └── Utils.ts                 # 工具函数
```

## 使用说明

1. **首次启动**：进入欢迎页，分步录入性别、年龄、身高、初始体重和目标体重
2. **首页功能**：
   - 显示当前体重
   - 显示BMI数值及体型分类
   - 显示基础代谢率
   - 显示减肥进度百分比
3. **添加记录**：点击"记录"按钮，添加每日体重
4. **查看趋势**：点击"趋势"按钮，查看体重变化折线图
5. **修改设置**：点击"设置"按钮，修改个人信息或提醒时间

## 技术栈

- **开发语言**: ArkTS
- **UI框架**: ArkUI
- **数据存储**: Preferences轻量级偏好数据库
- **状态管理**: AppStorage + LocalStorage
- **架构模式**: MVVM

## 编译运行

在DevEco Studio中打开项目，使用Hvigor构建系统进行编译构建。
