/**
 * 用户信息数据模型
 */
export class UserInfo {
  id: string = '';
  gender: Gender = Gender.MALE;
  age: number = 25;
  height: number = 170;
  initialWeight: number = 70;
  targetWeight: number = 65;
}

/**
 * 性别枚举
 */
export enum Gender {
  MALE = 'male',
  FEMALE = 'female'
}

/**
 * 体重记录数据模型
 */
export class WeightRecord {
  id: string = '';
  weight: number = 0;
  timestamp: number = 0;
  remark: string = '';
}

/**
 * 用户设置数据模型
 */
export class UserSettings {
  reminderEnabled: boolean = false;
  reminderTime: string = '08:00';
}
