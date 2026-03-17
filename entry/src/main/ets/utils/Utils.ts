/**
 * 日期格式化工具
 */
export class DateUtils {
  /**
   * 格式化日期为字符串
   */
  static formatDate(timestamp: number, format: string = 'YYYY-MM-DD'): string {
    const date = new Date(timestamp);
    const year = date.getFullYear().toString();
    const month = (date.getMonth() + 1).toString().padStart(2, '0');
    const day = date.getDate().toString().padStart(2, '0');
    const hour = date.getHours().toString().padStart(2, '0');
    const minute = date.getMinutes().toString().padStart(2, '0');

    return format
      .replace('YYYY', year)
      .replace('MM', month)
      .replace('DD', day)
      .replace('HH', hour)
      .replace('mm', minute);
  }

  /**
   * 获取今天的日期戳
   */
  static getTodayTimestamp(): number {
    const now = new Date();
    now.setHours(0, 0, 0, 0);
    return now.getTime();
  }

  /**
   * 获取n天前的日期戳
   */
  static getDaysAgoTimestamp(days: number): number {
    const date = new Date();
    date.setDate(date.getDate() - days);
    date.setHours(0, 0, 0, 0);
    return date.getTime();
  }

  /**
   * 格式化时间为友好显示
   */
  static getFriendlyTime(timestamp: number): string {
    const now = Date.now();
    const diff = now - timestamp;
    const oneDay = 24 * 60 * 60 * 1000;

    if (diff < oneDay) {
      return '今天';
    } else if (diff < 2 * oneDay) {
      return '昨天';
    } else {
      return this.formatDate(timestamp, 'MM-DD');
    }
  }
}

/**
 * 数值计算工具
 */
export class NumberUtils {
  /**
   * 格式化体重数值，保留一位小数
   */
  static formatWeight(weight: number): string {
    return weight.toFixed(1);
  }

  /**
   * 格式化BMI数值，保留一位小数
   */
  static formatBMI(bmi: number): string {
    return bmi.toFixed(1);
  }

  /**
   * 验证体重输入是否合法
   */
  static isValidWeight(weight: number): boolean {
    return weight > 0 && weight < 500;
  }

  /**
   * 验证年龄输入是否合法
   */
  static isValidAge(age: number): boolean {
    return age > 0 && age < 150;
  }

  /**
   * 验证身高输入是否合法
   */
  static isValidHeight(height: number): boolean {
    return height > 0 && height < 300;
  }
}

/**
 * UUID生成工具
 */
export class UUIDUtils {
  static generate(): string {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) => {
      const r = Math.random() * 16 | 0;
      const v = c === 'x' ? r : (r & 0x3 | 0x8);
      return v.toString(16);
    });
  }
}
