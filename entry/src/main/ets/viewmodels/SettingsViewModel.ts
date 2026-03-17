import { UserInfo, Gender, UserSettings } from '../models/UserModel';
import { userService } from '../services/UserService';

/**
 * 设置页视图模型
 */
export class SettingsViewModel {
  // 用户信息
  userInfo: UserInfo = new UserInfo();
  // 用户设置
  userSettings: UserSettings = new UserSettings();
  // 错误信息
  errorMessage: string = '';
  // 是否保存成功
  saveSuccess: boolean = false;

  /**
   * 初始化
   */
  async init(): Promise<void> {
    this.userInfo = await userService.getUserInfo();
    this.userSettings = await userService.getUserSettings();
  }

  /**
   * 验证用户信息
   */
  validate(): boolean {
    this.errorMessage = '';
    this.saveSuccess = false;

    if (this.userInfo.age <= 0 || this.userInfo.age > 150) {
      this.errorMessage = '请输入有效的年龄';
      return false;
    }

    if (this.userInfo.height <= 0 || this.userInfo.height > 300) {
      this.errorMessage = '请输入有效的身高';
      return false;
    }

    if (this.userInfo.initialWeight <= 0 || this.userInfo.initialWeight > 500) {
      this.errorMessage = '请输入有效的初始体重';
      return false;
    }

    if (this.userInfo.targetWeight <= 0 || this.userInfo.targetWeight > 500) {
      this.errorMessage = '请输入有效的目标体重';
      return false;
    }

    return true;
  }

  /**
   * 保存用户信息
   */
  async saveUserInfo(): Promise<boolean> {
    if (!this.validate()) {
      return false;
    }

    try {
      await userService.saveUserInfo(this.userInfo);
      this.saveSuccess = true;
      return true;
    } catch (error) {
      this.errorMessage = '保存失败，请重试';
      return false;
    }
  }

  /**
   * 保存提醒设置
   */
  async saveReminderSettings(context): Promise<boolean> {
    try {
      await userService.saveUserSettings(this.userSettings);
      // 提醒服务暂时禁用
      return true;
    } catch (error) {
      this.errorMessage = '保存提醒设置失败';
      return false;
    }
  }

  /**
   * 设置性别
   */
  setGender(gender: Gender): void {
    this.userInfo.gender = gender;
  }

  /**
   * 设置年龄
   */
  setAge(age: string): void {
    const ageNum = parseInt(age);
    if (!isNaN(ageNum)) {
      this.userInfo.age = ageNum;
    }
  }

  /**
   * 设置身高
   */
  setHeight(height: string): void {
    const heightNum = parseInt(height);
    if (!isNaN(heightNum)) {
      this.userInfo.height = heightNum;
    }
  }

  /**
   * 设置初始体重
   */
  setInitialWeight(weight: string): void {
    const weightNum = parseFloat(weight);
    if (!isNaN(weightNum)) {
      this.userInfo.initialWeight = weightNum;
    }
  }

  /**
   * 设置目标体重
   */
  setTargetWeight(weight: string): void {
    const weightNum = parseFloat(weight);
    if (!isNaN(weightNum)) {
      this.userInfo.targetWeight = weightNum;
    }
  }

  /**
   * 切换提醒开关
   */
  toggleReminder(enabled: boolean): void {
    this.userSettings.reminderEnabled = enabled;
  }

  /**
   * 设置提醒时间
   */
  setReminderTime(time: string): void {
    this.userSettings.reminderTime = time;
  }
}

export const settingsViewModel = new SettingsViewModel();
