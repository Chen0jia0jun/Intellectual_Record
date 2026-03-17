import preferences from '@ohos.data.preferences';
import { WeightRecord } from '../models/UserModel';
import { UUIDUtils } from '../utils/Utils';

const WEIGHT_RECORDS_KEY = 'weight_records';

class WeightService {
  private preferences: preferences.Preferences | null = null;

  async init(context): Promise<void> {
    this.preferences = await preferences.getPreferences(context, 'weight_data');
  }

  /**
   * 添加体重记录
   */
  async addRecord(weight: number, timestamp: number, remark: string = ''): Promise<WeightRecord> {
    if (!this.preferences) {
      return new WeightRecord();
    }

    const records = await this.getAllRecords();
    const newRecord: WeightRecord = {
      id: UUIDUtils.generate(),
      weight: weight,
      timestamp: timestamp,
      remark: remark
    };

    records.push(newRecord);
    await this.saveRecords(records);
    return newRecord;
  }

  /**
   * 获取所有体重记录
   */
  async getAllRecords(): Promise<WeightRecord[]> {
    if (!this.preferences) {
      return [];
    }
    const jsonStr = await this.preferences.get(WEIGHT_RECORDS_KEY, '[]') as string;
    return JSON.parse(jsonStr) as WeightRecord[];
  }

  /**
   * 获取最近的体重记录
   */
  async getLatestRecord(): Promise<WeightRecord | null> {
    const records = await this.getAllRecords();
    if (records.length === 0) {
      return null;
    }
    // 按时间倒序排列
    records.sort((a, b) => b.timestamp - a.timestamp);
    return records[0];
  }

  /**
   * 获取指定时间范围内的记录
   */
  async getRecordsInRange(startTime: number, endTime: number): Promise<WeightRecord[]> {
    const records = await this.getAllRecords();
    return records.filter(record => record.timestamp >= startTime && record.timestamp <= endTime);
  }

  /**
   * 更新体重记录
   */
  async updateRecord(id: string, weight: number, timestamp: number, remark: string): Promise<boolean> {
    const records = await this.getAllRecords();
    const index = records.findIndex(r => r.id === id);
    if (index === -1) {
      return false;
    }

    records[index].weight = weight;
    records[index].timestamp = timestamp;
    records[index].remark = remark;

    await this.saveRecords(records);
    return true;
  }

  /**
   * 删除体重记录
   */
  async deleteRecord(id: string): Promise<boolean> {
    const records = await this.getAllRecords();
    const index = records.findIndex(r => r.id === id);
    if (index === -1) {
      return false;
    }

    records.splice(index, 1);
    await this.saveRecords(records);
    return true;
  }

  /**
   * 保存记录到存储
   */
  private async saveRecords(records: WeightRecord[]): Promise<void> {
    if (!this.preferences) {
      return;
    }
    // 按时间倒序排列
    records.sort((a, b) => b.timestamp - a.timestamp);
    await this.preferences.put(WEIGHT_RECORDS_KEY, JSON.stringify(records));
    await this.preferences.flush();
  }
}

export const weightService = new WeightService();
