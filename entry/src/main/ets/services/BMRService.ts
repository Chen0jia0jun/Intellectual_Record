import { Gender } from '../models/UserModel';

/**
 * BMR计算结果
 */
export class BMRResult {
  bmr: number = 0; // kcal/day
}

class BMRService {
  /**
   * 使用Mifflin-St Jeor公式计算基础代谢率
   *
   * 男性: BMR = 88.362 + (13.397 × 体重kg) + (4.799 × 身高cm) - (5.677 × 年龄)
   * 女性: BMR = 447.593 + (9.247 × 体重kg) + (3.098 × 身高cm) - (4.330 × 年龄)
   */
  calculateBMR(weight: number, height: number, age: number, gender: Gender): number {
    if (weight <= 0 || height <= 0 || age <= 0) {
      return 0;
    }

    let bmr: number;
    if (gender === Gender.MALE) {
      bmr = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
    } else {
      bmr = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
    }

    return Math.round(bmr);
  }

  /**
   * 获取BMR计算结果
   */
  getBMRResult(weight: number, height: number, age: number, gender: Gender): BMRResult {
    const result = new BMRResult();
    result.bmr = this.calculateBMR(weight, height, age, gender);
    return result;
  }
}

export const bmrService = new BMRService();
