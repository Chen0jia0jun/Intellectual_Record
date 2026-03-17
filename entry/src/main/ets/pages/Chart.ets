import router from '@ohos.router';
import { chartViewModel, TimeRange, ChartDataPoint } from '../viewmodels/ChartViewModel';
import { userService } from '../services/UserService';
import { WeightRecord } from '../models/UserModel';

@Entry
@Component
struct Chart {
  @State selectedRange: number = 0;
  @State chartData: ChartDataPoint[] = [];
  @State statisticsText: string = '暂无数据';
  @State changeText: string = '';
  @State targetWeight: number = 0;
  @State maxWeight: number = 0;
  @State minWeight: number = 0;

  aboutToAppear() {
    this.loadData();
  }

  async loadData() {
    const userInfo = await userService.getUserInfo();
    this.targetWeight = userInfo.targetWeight;
    chartViewModel.setTimeRange(this.getTimeRange());
    await chartViewModel.loadData(userInfo.targetWeight);
    this.updateUI();
  }

  updateUI() {
    this.chartData = chartViewModel.chartData;
    this.statisticsText = chartViewModel.getStatisticsText();
    this.changeText = chartViewModel.getChangeText();

    if (chartViewModel.statistics.maxWeight > 0) {
      this.maxWeight = chartViewModel.statistics.maxWeight;
      this.minWeight = chartViewModel.statistics.minWeight;
    }
  }

  getTimeRange(): TimeRange {
    switch (this.selectedRange) {
      case 0: return TimeRange.WEEK;
      case 1: return TimeRange.MONTH;
      case 2: return TimeRange.THREE_MONTH;
      case 3: return TimeRange.ALL;
      default: return TimeRange.WEEK;
    }
  }

  onRangeChange(index: number) {
    this.selectedRange = index;
    this.loadData();
  }

  build() {
    Column() {
      // 顶部导航
      Row() {
        Text('<')
          .fontSize(24)
          .fontColor('#333333')
          .onClick(() => router.back())
        Text('体重趋势')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
        Text('')
          .width(24)
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')

      // 时间范围选择
      Row() {
        ForEach(['一周', '一个月', '三个月', '全部'], (item: string, index: number) => {
          Column() {
            Text(item)
              .fontSize(14)
              .fontColor(this.selectedRange === index ? '#1890FF' : '#666666')
            if (this.selectedRange === index) {
              Divider()
                .width(30)
                .strokeWidth(2)
                .color('#1890FF')
                .margin({ top: 4 })
            }
          }
          .onClick(() => this.onRangeChange(index))
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceEvenly)
      .padding({ top: 12, bottom: 12 })
      .backgroundColor('#FFFFFF')

      // 图表区域
      Column() {
        if (this.chartData.length === 0) {
          Text('暂无数据')
            .fontSize(16)
            .fontColor('#999999')
        } else {
          // 简单折线图
          this.buildChart()
        }
      }
      .width('100%')
      .height(250)
      .backgroundColor('#FFFFFF')
      .margin({ top: 12 })

      // 统计信息
      Column() {
        Row() {
          Text('统计')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
          Text(this.changeText)
            .fontSize(14)
            .fontColor('#1890FF')
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({ bottom: 12 })

        Text(this.statisticsText)
          .fontSize(14)
          .fontColor('#666666')
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')
      .margin({ top: 12 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder
  buildChart() {
    Stack() {
      // 绘制图表内容
      Column() {
        // Y轴标签
        Row() {
          Column() {
            Text(`${this.maxWeight.toFixed(1)}`)
              .fontSize(10)
              .fontColor('#999999')
            Text('')
              .height(20)
            Text(`${this.targetWeight.toFixed(1)}`)
              .fontSize(10)
              .fontColor('#1890FF')
            Text('')
              .height(20)
            Text(`${this.minWeight.toFixed(1)}`)
              .fontSize(10)
              .fontColor('#999999')
          }
          .width(30)
          .alignItems(HorizontalAlign.End)
          .padding({ right: 4 })

          // 图表区域
          Column() {
            // 目标体重线
            Row() {
              Rect({ width: '100%', height: 1 })
                .fill('#1890FF')
            }
            .height(this.getTargetLinePosition())
            .width('100%')

            // 数据点 - 使用多个小圆形来表示
            ForEach(this.chartData, (point: ChartDataPoint, index: number) => {
              Column() {
                Circle({ width: 6, height: 6 })
                  .fill('#1890FF')
              }
              .position({
                x: this.getPointX(index),
                y: this.getPointY(point.weight)
              })
            })
          }
          .width(280)
          .height(150)
          .layoutWeight(1)
        }
      }
      .width('100%')
      .padding({ left: 34, right: 16 })

      // X轴标签
      Row() {
        ForEach(this.getXAxisLabels(), (label: string) => {
          Text(label)
            .fontSize(10)
            .fontColor('#999999')
        })
      }
      .width(280)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ left: 34, right: 16, top: 150 })
    }
  }

  getTargetLinePosition(): string {
    if (this.maxWeight === this.minWeight) {
      return '50%';
    }
    const ratio = (this.targetWeight - this.minWeight) / (this.maxWeight - this.minWeight);
    const y = 150 * (1 - ratio);
    return `${y}px`;
  }

  getLineSegments(): {x1: number, y1: number, x2: number, y2: number}[] {
    if (this.chartData.length < 2) {
      return [];
    }

    const segments: {x1: number, y1: number, x2: number, y2: number}[] = [];
    const count = this.chartData.length;

    for (let i = 0; i < count - 1; i++) {
      const x1 = (i / (count - 1)) * 280;
      const ratio1 = (this.chartData[i].weight - this.minWeight) / (this.maxWeight - this.minWeight);
      const y1 = 150 * (1 - ratio1);

      const x2 = ((i + 1) / (count - 1)) * 280;
      const ratio2 = (this.chartData[i + 1].weight - this.minWeight) / (this.maxWeight - this.minWeight);
      const y2 = 150 * (1 - ratio2);

      segments.push({ x1, y1, x2, y2 });
    }

    return segments;
  }

  getPointX(index: number): number {
    const count = this.chartData.length;
    if (count <= 1) {
      return 140;
    }
    return (index / (count - 1)) * 280 - 3;
  }

  getPointY(weight: number): number {
    if (this.maxWeight === this.minWeight) {
      return 75 - 3;
    }
    const ratio = (weight - this.minWeight) / (this.maxWeight - this.minWeight);
    return 150 * (1 - ratio) - 3;
  }

  getXAxisLabels(): string[] {
    const labels: string[] = [];
    const count = Math.min(5, this.chartData.length);

    if (count === 0) {
      return labels;
    }

    const step = Math.floor(this.chartData.length / count);
    for (let i = 0; i < count; i++) {
      const index = i * step;
      if (index < this.chartData.length) {
        labels.push(this.chartData[index].dateLabel);
      }
    }

    return labels;
  }
}
