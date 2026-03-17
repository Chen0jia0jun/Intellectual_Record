import { WeightRecord } from '../models/UserModel';
import { weightService } from '../services/WeightService';
import { NumberUtils, DateUtils } from '../utils/Utils';

/**
 * 记录页视图模型
 */
export class RecordViewModel {
  // 体重输入值
  weight: string = '';
  // 记录时间戳
  timestamp: number = Date.now();
  // 备注
  remark: string = '';
  // 编辑的记录ID（如果是编辑模式）
  editRecordId: string = '';
  // 是否为编辑模式
  isEditMode: boolean = false;
  // 错误信息
  errorMessage: string = '';

  /**
   * 重置表单
   */
  resetForm(): void {
    this.weight = '';
    this.timestamp = Date.now();
    this.remark = '';
    this.editRecordId = '';
    this.isEditMode = false;
    this.errorMessage = '';
  }

  /**
   * 设置编辑模式
   */
  setEditMode(record: WeightRecord): void {
    this.editRecordId = record.id;
    this.weight = record.weight.toString();
    this.timestamp = record.timestamp;
    this.remark = record.remark;
    this.isEditMode = true;
  }

  /**
   * 验证输入
   */
  validate(): boolean {
    const weightValue = parseFloat(this.weight);
    if (!this.weight || isNaN(weightValue)) {
      this.errorMessage = '请输入体重';
      return false;
    }
    if (!NumberUtils.isValidWeight(weightValue)) {
      this.errorMessage = '请输入有效的体重值';
      return false;
    }
    this.errorMessage = '';
    return true;
  }

  /**
   * 保存记录
   */
  async saveRecord(): Promise<boolean> {
    if (!this.validate()) {
      return false;
    }

    const weightValue = parseFloat(this.weight);

    try {
      if (this.isEditMode) {
        // 更新记录
        await weightService.updateRecord(
          this.editRecordId,
          weightValue,
          this.timestamp,
          this.remark
        );
      } else {
        // 添加新记录
        await weightService.addRecord(weightValue, this.timestamp, this.remark);
      }
      return true;
    } catch (error) {
      this.errorMessage = '保存失败，请重试';
      return false;
    }
  }

  /**
   * 获取体重列表
   */
  async getWeightList(): Promise<WeightRecord[]> {
    return await weightService.getAllRecords();
  }

  /**
   * 删除记录
   */
  async deleteRecord(id: string): Promise<boolean> {
    return await weightService.deleteRecord(id);
  }

  /**
   * 格式化日期显示
   */
  formatDate(timestamp: number): string {
    return DateUtils.formatDate(timestamp, 'YYYY-MM-DD HH:mm');
  }
}

export const recordViewModel = new RecordViewModel();
