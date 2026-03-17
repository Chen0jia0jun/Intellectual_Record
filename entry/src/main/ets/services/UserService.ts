import preferences from '@ohos.data.preferences';
import { UserInfo, Gender, UserSettings } from '../models/UserModel';
import { UUIDUtils } from '../utils/Utils';

const USER_INFO_KEY = 'user_info';
const USER_SETTINGS_KEY = 'user_settings';

class UserService {
  private preferences: preferences.Preferences | null = null;

  async init(context): Promise<void> {
    this.preferences = await preferences.getPreferences(context, 'user_data');
  }

  /**
   * 获取用户信息
   */
  async getUserInfo(): Promise<UserInfo> {
    if (!this.preferences) {
      return new UserInfo();
    }
    const jsonStr = await this.preferences.get(USER_INFO_KEY, '') as string;
    if (!jsonStr) {
      return new UserInfo();
    }
    return JSON.parse(jsonStr) as UserInfo;
  }

  /**
   * 保存用户信息
   */
  async saveUserInfo(userInfo: UserInfo): Promise<void> {
    if (!this.preferences) {
      return;
    }
    if (!userInfo.id) {
      userInfo.id = UUIDUtils.generate();
    }
    await this.preferences.put(USER_INFO_KEY, JSON.stringify(userInfo));
    await this.preferences.flush();
  }

  /**
   * 检查用户是否已设置信息
   */
  async isUserInfoSet(): Promise<boolean> {
    const userInfo = await this.getUserInfo();
    return !!userInfo.id;
  }

  /**
   * 获取用户设置
   */
  async getUserSettings(): Promise<UserSettings> {
    if (!this.preferences) {
      return new UserSettings();
    }
    const jsonStr = await this.preferences.get(USER_SETTINGS_KEY, '') as string;
    if (!jsonStr) {
      return new UserSettings();
    }
    return JSON.parse(jsonStr) as UserSettings;
  }

  /**
   * 保存用户设置
   */
  async saveUserSettings(settings: UserSettings): Promise<void> {
    if (!this.preferences) {
      return;
    }
    await this.preferences.put(USER_SETTINGS_KEY, JSON.stringify(settings));
    await this.preferences.flush();
  }
}

export const userService = new UserService();
