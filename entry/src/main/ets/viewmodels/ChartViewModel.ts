import { WeightRecord } from '../models/UserModel';
import { weightService } from '../services/WeightService';
import { DateUtils } from '../utils/Utils';

/**
 * 时间范围类型
 */
export enum TimeRange {
  WEEK = 7,      // 最近一周
  MONTH = 30,    // 最近一个月
  THREE_MONTH = 90, // 最近三个月
  ALL = 0       // 全部
}

/**
 * 图表数据点
 */
export class ChartDataPoint {
  timestamp: number = 0;
  weight: number = 0;
  dateLabel: string = '';
}

/**
 * 统计信息
 */
export class StatisticsInfo {
  maxWeight: number = 0;
  minWeight: number = 0;
  avgWeight: number = 0;
  change: number = 0;
}

/**
 * 趋势页视图模型
 */
export class ChartViewModel {
  // 当前时间范围
  currentRange: TimeRange = TimeRange.WEEK;
  // 体重记录列表
  records: WeightRecord[] = [];
  // 图表数据点
  chartData: ChartDataPoint[] = [];
  // 统计信息
  statistics: StatisticsInfo = new StatisticsInfo();
  // 目标体重
  targetWeight: number = 0;

  /**
   * 设置时间范围
   */
  setTimeRange(range: TimeRange): void {
    this.currentRange = range;
  }

  /**
   * 加载数据
   */
  async loadData(targetWeight: number): Promise<void> {
    this.targetWeight = targetWeight;

    let startTime: number;
    if (this.currentRange === TimeRange.ALL) {
      startTime = 0;
    } else {
      startTime = DateUtils.getDaysAgoTimestamp(this.currentRange);
    }

    this.records = await weightService.getRecordsInRange(startTime, Date.now());
    this.processChartData();
    this.calculateStatistics();
  }

  /**
   * 处理图表数据
   */
  private processChartData(): void {
    this.chartData = this.records.map(record => {
      let dateLabel: string;
      if (this.currentRange === TimeRange.WEEK) {
        dateLabel = DateUtils.formatDate(record.timestamp, 'MM-DD');
      } else if (this.currentRange === TimeRange.MONTH) {
        dateLabel = DateUtils.formatDate(record.timestamp, 'MM-DD');
      } else {
        dateLabel = DateUtils.formatDate(record.timestamp, 'MM-DD');
      }

      return {
        timestamp: record.timestamp,
        weight: record.weight,
        dateLabel: dateLabel
      };
    });
  }

  /**
   * 计算统计信息
   */
  private calculateStatistics(): void {
    if (this.records.length === 0) {
      this.statistics = new StatisticsInfo();
      return;
    }

    const weights = this.records.map(r => r.weight);
    const maxWeight = Math.max(...weights);
    const minWeight = Math.min(...weights);
    const avgWeight = weights.reduce((a, b) => a + b, 0) / weights.length;

    // 计算变化（最新 - 最旧）
    let change = 0;
    if (this.records.length >= 2) {
      const sorted = [...this.records].sort((a, b) => a.timestamp - b.timestamp);
      change = sorted[sorted.length - 1].weight - sorted[0].weight;
    }

    this.statistics = {
      maxWeight: maxWeight,
      minWeight: minWeight,
      avgWeight: avgWeight,
      change: change
    };
  }

  /**
   * 获取统计信息文本
   */
  getStatisticsText(): string {
    const stats = this.statistics;
    if (!stats.maxWeight) {
      return '暂无数据';
    }
    return `最高: ${stats.maxWeight.toFixed(1)}kg | 最低: ${stats.minWeight.toFixed(1)}kg | 平均: ${stats.avgWeight.toFixed(1)}kg | 变化: ${stats.change >= 0 ? '+' : ''}${stats.change.toFixed(1)}kg`;
  }

  /**
   * 获取变化文本
   */
  getChangeText(): string {
    const change = this.statistics.change;
    if (change > 0) {
      return `↑ ${change.toFixed(1)} kg`;
    } else if (change < 0) {
      return `↓ ${Math.abs(change).toFixed(1)} kg`;
    }
    return '无变化';
  }
}

export const chartViewModel = new ChartViewModel();
