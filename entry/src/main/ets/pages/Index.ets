import router from '@ohos.router';
import { homeViewModel } from '../viewmodels/HomeViewModel';
import { bmiService, BodyType } from '../services/BMIService';

@Entry
@Component
struct Index {
  @State currentWeight: string = '--';
  @State bmi: string = '--';
  @State bmiBodyType: string = '--';
  @State bmiColor: string = '#999999';
  @State bmr: string = '--';
  @State progressPercent: number = 0;
  @State progressText: string = '--';
  @State weightDiffText: string = '--';
  @State targetWeight: number = 0;

  async aboutToAppear() {
    await homeViewModel.init();
    this.updateUI();
  }

  onPageShow() {
    this.refreshData();
  }

  async refreshData() {
    await homeViewModel.init();
    this.updateUI();
  }

  updateUI() {
    this.currentWeight = homeViewModel.getCurrentWeightText();
    this.bmi = homeViewModel.getBMIText();
    this.bmiBodyType = homeViewModel.bmiResult.bodyType;
    this.bmiColor = bmiService.getBodyTypeColor(homeViewModel.bmiResult.bodyType);
    this.bmr = homeViewModel.getBMRText();
    this.progressPercent = homeViewModel.progressPercent;
    this.progressText = homeViewModel.getProgressText();
    this.weightDiffText = homeViewModel.getWeightDiffText();
    this.targetWeight = homeViewModel.userInfo.targetWeight;
  }

  build() {
    Column() {
      // 顶部标题
      Text('体重管理')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20 })

      Scroll() {
        Column() {
          // 当前体重卡片
          this.buildCurrentWeightCard()

          // 健康指标卡片
          this.buildHealthMetricsCard()

          // 进度卡片
          this.buildProgressCard()

          // 操作按钮
          this.buildActionButtons()
        }
        .width('100%')
        .padding({ left: 16, right: 16, bottom: 20 })
      }
      .scrollable(ScrollDirection.Vertical)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder
  buildCurrentWeightCard() {
    Column() {
      Text('当前体重')
        .fontSize(14)
        .fontColor('#666666')
        .margin({ bottom: 8 })

      Row() {
        Text(this.currentWeight)
          .fontSize(48)
          .fontWeight(FontWeight.Bold)
      }
      .margin({ bottom: 8 })

      Text(`目标: ${this.targetWeight.toFixed(1)} kg`)
        .fontSize(14)
        .fontColor('#999999')
    }
    .width('100%')
    .padding(24)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
    .margin({ top: 20 })
  }

  @Builder
  buildHealthMetricsCard() {
    Column() {
      Text('健康指标')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .alignSelf(ItemAlign.Start)
        .margin({ bottom: 16 })

      Row() {
        // BMI
        Column() {
          Text('BMI')
            .fontSize(12)
            .fontColor('#666666')
            .margin({ bottom: 8 })
          Text(this.bmi)
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
          Text(this.bmiBodyType)
            .fontSize(12)
            .fontColor(this.bmiColor)
            .margin({ top: 4 })
        }
        .layoutWeight(1)

        // 分割线
        Column() {
          Divider()
            .width(1)
            .height(50)
            .backgroundColor('#E0E0E0')
        }
        .layoutWeight(1)

        // BMR
        Column() {
          Text('基础代谢')
            .fontSize(12)
            .fontColor('#666666')
            .margin({ bottom: 8 })
          Text(this.bmr)
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
          Text('kcal/天')
            .fontSize(12)
            .fontColor('#999999')
            .margin({ top: 4 })
        }
        .layoutWeight(1)
      }
    }
    .width('100%')
    .padding(20)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
    .margin({ top: 16 })
  }

  @Builder
  buildProgressCard() {
    Column() {
      Row() {
        Text('进度')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
        Text(this.progressText)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor('#1890FF')
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ bottom: 12 })

      // 进度条
      Column() {
        Row() {
          Progress({ value: this.progressPercent, total: 100, style: ProgressStyle.Linear })
            .width('100%')
            .color('#1890FF')
            .backgroundColor('#E0E0E0')
        }
        .width('100%')
        .height(8)
      }
      .width('100%')

      Text(this.weightDiffText)
        .fontSize(14)
        .fontColor('#666666')
        .margin({ top: 12 })
    }
    .width('100%')
    .padding(20)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
    .margin({ top: 16 })
  }

  @Builder
  buildActionButtons() {
    Row() {
      // 添加记录按钮
      Column() {
        Text('+')
          .fontSize(40)
          .fontColor('#FFFFFF')
        Text('记录')
          .fontSize(14)
          .fontColor('#FFFFFF')
          .margin({ top: 8 })
      }
      .width('45%')
      .height(100)
      .backgroundColor('#1890FF')
      .borderRadius(16)
      .justifyContent(FlexAlign.Center)
      .onClick(() => router.pushUrl({ url: 'pages/Record' }))

      // 趋势和设置
      Column() {
        // 趋势按钮
        Row() {
          Text('📈')
            .fontSize(16)
          Text('趋势')
            .fontSize(14)
            .fontColor('#1890FF')
            .margin({ left: 8 })
        }
        .width('100%')
        .height(48)
        .backgroundColor('#E6F7FF')
        .borderRadius(12)
        .justifyContent(FlexAlign.Center)
        .onClick(() => router.pushUrl({ url: 'pages/Chart' }))

        // 设置按钮
        Row() {
          Text('⚙')
            .fontSize(16)
          Text('设置')
            .fontSize(14)
            .fontColor('#666666')
            .margin({ left: 8 })
        }
        .width('100%')
        .height(48)
        .backgroundColor('#F5F5F5')
        .borderRadius(12)
        .justifyContent(FlexAlign.Center)
        .margin({ top: 12 })
        .onClick(() => router.pushUrl({ url: 'pages/Settings' }))
      }
      .width('45%')
      .margin({ left: '10%' })
    }
    .width('100%')
    .margin({ top: 16 })
  }
}
