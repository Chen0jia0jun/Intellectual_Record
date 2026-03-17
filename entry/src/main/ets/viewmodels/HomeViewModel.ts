import { UserInfo, WeightRecord, UserSettings } from '../models/UserModel';
import { userService } from '../services/UserService';
import { weightService } from '../services/WeightService';
import { bmiService, BodyType, BMIResult } from '../services/BMIService';
import { bmrService, BMRResult } from '../services/BMRService';
import { NumberUtils } from '../utils/Utils';

/**
 * 首页视图模型
 */
export class HomeViewModel {
  // 用户信息
  userInfo: UserInfo = new UserInfo();
  // 当前体重
  currentWeight: number = 0;
  // 最新记录
  latestRecord: WeightRecord | null = null;
  // BMI结果
  bmiResult: BMIResult = new BMIResult();
  // BMR结果
  bmrResult: BMRResult = new BMRResult();
  // 进度百分比
  progressPercent: number = 0;
  // 目标差距
  weightDiff: number = 0;

  /**
   * 初始化首页数据
   */
  async init(): Promise<void> {
    // 获取用户信息
    this.userInfo = await userService.getUserInfo();

    // 获取最新体重记录
    this.latestRecord = await weightService.getLatestRecord();

    // 确定当前体重
    if (this.latestRecord) {
      this.currentWeight = this.latestRecord.weight;
    } else {
      this.currentWeight = this.userInfo.initialWeight;
    }

    // 计算BMI
    if (this.userInfo.height > 0 && this.currentWeight > 0) {
      this.bmiResult = bmiService.getBMIResult(this.currentWeight, this.userInfo.height);
    }

    // 计算BMR
    if (this.userInfo.height > 0 && this.userInfo.age > 0 && this.currentWeight > 0) {
      this.bmrResult = bmrService.getBMRResult(
        this.currentWeight,
        this.userInfo.height,
        this.userInfo.age,
        this.userInfo.gender
      );
    }

    // 计算进度
    this.calculateProgress();
  }

  /**
   * 计算进度
   */
  private calculateProgress(): void {
    if (this.userInfo.initialWeight <= 0 || this.userInfo.targetWeight <= 0) {
      this.progressPercent = 0;
      this.weightDiff = 0;
      return;
    }

    const initialWeight = this.userInfo.initialWeight;
    const targetWeight = this.userInfo.targetWeight;

    // 计算进度
    if (initialWeight > targetWeight) {
      // 减肥模式
      const totalLoss = initialWeight - targetWeight;
      const currentLoss = initialWeight - this.currentWeight;
      this.progressPercent = Math.max(0, Math.min(100, (currentLoss / totalLoss) * 100));
      this.weightDiff = this.currentWeight - targetWeight;
    } else if (initialWeight < targetWeight) {
      // 增重模式
      const totalGain = targetWeight - initialWeight;
      const currentGain = this.currentWeight - initialWeight;
      this.progressPercent = Math.max(0, Math.min(100, (currentGain / totalGain) * 100));
      this.weightDiff = this.currentWeight - targetWeight;
    } else {
      this.progressPercent = 100;
      this.weightDiff = 0;
    }
  }

  /**
   * 获取进度字符串
   */
  getProgressText(): string {
    return `${this.progressPercent.toFixed(0)}%`;
  }

  /**
   * 获取体重差距字符串
   */
  getWeightDiffText(): string {
    const diff = this.weightDiff;
    if (diff > 0) {
      return `还差 ${NumberUtils.formatWeight(diff)} kg`;
    } else if (diff < 0) {
      return `已超过目标 ${NumberUtils.formatWeight(Math.abs(diff))} kg`;
    } else {
      return '已达到目标';
    }
  }

  /**
   * 获取当前体重字符串
   */
  getCurrentWeightText(): string {
    return `${NumberUtils.formatWeight(this.currentWeight)} kg`;
  }

  /**
   * 获取BMI字符串
   */
  getBMIText(): string {
    return NumberUtils.formatBMI(this.bmiResult.bmi);
  }

  /**
   * 获取BMR字符串
   */
  getBMRText(): string {
    return `${this.bmrResult.bmr} kcal`;
  }
}

export const homeViewModel = new HomeViewModel();
