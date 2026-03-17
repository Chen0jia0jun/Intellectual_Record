/**
 * 体型分类
 */
export enum BodyType {
  UNDERWEIGHT = '偏瘦',     // BMI < 18.5
  NORMAL = '正常',          // 18.5 <= BMI < 24
  OVERWEIGHT = '超重',     // 24 <= BMI < 28
  OBESE = '肥胖'            // BMI >= 28
}

/**
 * BMI计算结果
 */
export class BMIResult {
  bmi: number = 0;
  bodyType: BodyType = BodyType.NORMAL;
}

class BMIService {
  /**
   * 计算BMI
   * 公式: 体重(kg) / 身高(m)^2
   */
  calculateBMI(weight: number, height: number): number {
    if (weight <= 0 || height <= 0) {
      return 0;
    }
    const heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }

  /**
   * 获取BMI结果（包含BMI值和体型分类）
   */
  getBMIResult(weight: number, height: number): BMIResult {
    const bmi = this.calculateBMI(weight, height);
    const result = new BMIResult();
    result.bmi = bmi;
    result.bodyType = this.getBodyType(bmi);
    return result;
  }

  /**
   * 根据BMI值获取体型分类
   */
  getBodyType(bmi: number): BodyType {
    if (bmi < 18.5) {
      return BodyType.UNDERWEIGHT;
    } else if (bmi < 24) {
      return BodyType.NORMAL;
    } else if (bmi < 28) {
      return BodyType.OVERWEIGHT;
    } else {
      return BodyType.OBESE;
    }
  }

  /**
   * 获取体型对应的颜色
   */
  getBodyTypeColor(bodyType: BodyType): string {
    switch (bodyType) {
      case BodyType.UNDERWEIGHT:
        return '#1890FF'; // 蓝色
      case BodyType.NORMAL:
        return '#52C41A'; // 绿色
      case BodyType.OVERWEIGHT:
        return '#FAAD14'; // 橙色
      case BodyType.OBESE:
        return '#F5222D'; // 红色
      default:
        return '#999999';
    }
  }
}

export const bmiService = new BMIService();
