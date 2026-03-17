import router from '@ohos.router';
import { recordViewModel } from '../viewmodels/RecordViewModel';
import { WeightRecord } from '../models/UserModel';
import { DateUtils } from '../utils/Utils';

@Entry
@Component
struct Record {
  @State weight: string = '';
  @State remark: string = '';
  @State timestamp: number = Date.now();
  @State showDatePicker: boolean = false;
  @State errorMessage: string = '';
  @State records: WeightRecord[] = [];
  @State showRecordList: boolean = false;
  @State selectedTab: number = 0;

  aboutToAppear() {
    this.loadRecords();
  }

  async loadRecords() {
    this.records = await recordViewModel.getWeightList();
  }

  async saveRecord() {
    recordViewModel.weight = this.weight;
    recordViewModel.remark = this.remark;
    recordViewModel.timestamp = this.timestamp;

    const success = await recordViewModel.saveRecord();
    if (success) {
      this.weight = '';
      this.remark = '';
      this.timestamp = Date.now();
      this.loadRecords();
    } else {
      this.errorMessage = recordViewModel.errorMessage;
    }
  }

  async deleteRecord(id: string) {
    await recordViewModel.deleteRecord(id);
    this.loadRecords();
  }

  build() {
    Column() {
      // 顶部导航
      Row() {
        Text('<')
          .fontSize(24)
          .fontColor('#333333')
          .onClick(() => router.back())
        Text('记录体重')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
        Text('')
          .width(24)
      }
      .width('100%')
      .padding(16)
      .justifyContent(FlexAlign.SpaceBetween)

      // Tab切换
      Row() {
        Column() {
          Text('添加记录')
            .fontSize(16)
            .fontColor(this.selectedTab === 0 ? '#1890FF' : '#666666')
          if (this.selectedTab === 0) {
            Divider()
              .width(40)
              .strokeWidth(2)
              .color('#1890FF')
              .margin({ top: 4 })
          }
        }
        .onClick(() => this.selectedTab = 0)

        Column() {
          Text('历史记录')
            .fontSize(16)
            .fontColor(this.selectedTab === 1 ? '#1890FF' : '#666666')
          if (this.selectedTab === 1) {
            Divider()
              .width(40)
              .strokeWidth(2)
              .color('#1890FF')
              .margin({ top: 4 })
          }
        }
        .onClick(() => this.selectedTab = 1)
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceEvenly)
      .padding({ bottom: 10 })
      .backgroundColor('#FFFFFF')

      if (this.selectedTab === 0) {
        // 添加记录表单
        this.buildAddForm()
      } else {
        // 历史记录列表
        this.buildRecordList()
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder
  buildAddForm() {
    Column() {
      // 体重输入
      Column() {
        Text('体重')
          .fontSize(14)
          .fontColor('#666666')
          .alignSelf(ItemAlign.Start)
          .margin({ bottom: 8 })

        Row() {
          TextInput({ placeholder: '请输入体重', text: this.weight })
            .width('100%')
            .height(56)
            .fontSize(24)
            .textAlign(TextAlign.Center)
            .type(InputType.Number)
            .onChange((value: string) => this.weight = value)

          Text('kg')
            .fontSize(18)
            .fontColor('#333333')
            .margin({ left: 12 })
        }
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')
      .borderRadius(12)
      .margin({ top: 16 })

      // 时间选择
      Column() {
        Text('记录时间')
          .fontSize(14)
          .fontColor('#666666')
          .alignSelf(ItemAlign.Start)
          .margin({ bottom: 8 })

        Row() {
          Text(DateUtils.formatDate(this.timestamp, 'YYYY-MM-DD HH:mm'))
            .fontSize(16)
            .fontColor('#333333')

          Text('📅')
            .fontSize(18)
            .margin({ left: 8 })
        }
        .onClick(() => this.showDatePicker = true)
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')
      .borderRadius(12)
      .margin({ top: 12 })

      // 备注输入
      Column() {
        Text('备注（可选）')
          .fontSize(14)
          .fontColor('#666666')
          .alignSelf(ItemAlign.Start)
          .margin({ bottom: 8 })

        TextInput({ placeholder: '添加备注', text: this.remark })
          .width('100%')
          .height(80)
          .fontSize(16)
          .textAlign(TextAlign.Start)
          .onChange((value: string) => this.remark = value)
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')
      .borderRadius(12)
      .margin({ top: 12 })

      // 错误提示
      if (this.errorMessage) {
        Text(this.errorMessage)
          .fontSize(14)
          .fontColor('#F5222D')
          .margin({ top: 12 })
      }

      // 保存按钮
      Button('保存记录')
        .width('100%')
        .height(50)
        .backgroundColor('#1890FF')
        .fontColor('#FFFFFF')
        .fontSize(16)
        .margin({ top: 24 })
        .onClick(() => this.saveRecord())
    }
    .width('100%')
    .padding(16)
  }

  @Builder
  buildRecordList() {
    if (this.records.length === 0) {
      Column() {
        Text('暂无记录')
          .fontSize(16)
          .fontColor('#999999')
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    } else {
      List() {
        ForEach(this.records, (record: WeightRecord) => {
          ListItem() {
            Row() {
              Column() {
                Text(`${record.weight.toFixed(1)} kg`)
                  .fontSize(18)
                  .fontWeight(FontWeight.Medium)
                Text(DateUtils.formatDate(record.timestamp, 'YYYY-MM-DD HH:mm'))
                  .fontSize(12)
                  .fontColor('#999999')
                  .margin({ top: 4 })
                if (record.remark) {
                  Text(record.remark)
                    .fontSize(12)
                    .fontColor('#666666')
                    .margin({ top: 4 })
                }
              }
              .alignItems(HorizontalAlign.Start)

              Text('🗑')
                .fontSize(20)
                .onClick(() => this.deleteRecord(record.id))
            }
            .width('100%')
            .padding(16)
            .justifyContent(FlexAlign.SpaceBetween)
          }
          .backgroundColor('#FFFFFF')
          .margin({ bottom: 8 })
          .borderRadius(12)
        })
      }
      .width('100%')
      .height('100%')
      .padding(16)
    }
  }
}
