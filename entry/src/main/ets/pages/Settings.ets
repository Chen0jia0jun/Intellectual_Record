import router from '@ohos.router';
import { settingsViewModel } from '../viewmodels/SettingsViewModel';
import { Gender } from '../models/UserModel';
import common from '@ohos.app.ability.common';

@Entry
@Component
struct Settings {
  @State gender: Gender = Gender.MALE;
  @State age: string = '';
  @State userHeight: string = '';
  @State initialWeight: string = '';
  @State targetWeight: string = '';
  @State reminderEnabled: boolean = false;
  @State reminderTime: string = '08:00';
  @State errorMessage: string = '';
  @State saveSuccess: boolean = false;
  @State showTimePicker: boolean = false;

  async aboutToAppear() {
    await settingsViewModel.init();
    this.loadData();
  }

  loadData() {
    this.gender = settingsViewModel.userInfo.gender;
    this.age = settingsViewModel.userInfo.age.toString();
    this.userHeight = settingsViewModel.userInfo.height.toString();
    this.initialWeight = settingsViewModel.userInfo.initialWeight.toString();
    this.targetWeight = settingsViewModel.userInfo.targetWeight.toString();
    this.reminderEnabled = settingsViewModel.userSettings.reminderEnabled;
    this.reminderTime = settingsViewModel.userSettings.reminderTime;
  }

  async saveUserInfo() {
    settingsViewModel.setGender(this.gender);
    settingsViewModel.setAge(this.age);
    settingsViewModel.setHeight(this.userHeight);
    settingsViewModel.setInitialWeight(this.initialWeight);
    settingsViewModel.setTargetWeight(this.targetWeight);

    const success = await settingsViewModel.saveUserInfo();
    if (success) {
      this.saveSuccess = true;
      setTimeout(() => this.saveSuccess = false, 2000);
    } else {
      this.errorMessage = settingsViewModel.errorMessage;
    }
  }

  async saveReminderSettings() {
    settingsViewModel.toggleReminder(this.reminderEnabled);
    settingsViewModel.setReminderTime(this.reminderTime);

    const context = getContext(this) as common.UIAbilityContext;
    await settingsViewModel.saveReminderSettings(context);
  }

  build() {
    Column() {
      // 顶部导航
      Row() {
        Text('<')
          .fontSize(24)
          .fontColor('#333333')
          .onClick(() => router.back())
        Text('设置')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
        Text('')
          .width(24)
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')

      Scroll() {
        Column() {
          // 用户信息组
          this.buildUserInfoSection()

          // 提醒设置组
          this.buildReminderSection()

          // 关于信息
          this.buildAboutSection()
        }
        .width('100%')
        .padding(16)
      }
      .scrollable(ScrollDirection.Vertical)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder
  buildUserInfoSection() {
    Column() {
      Text('基本信息')
        .fontSize(14)
        .fontColor('#666666')
        .alignSelf(ItemAlign.Start)
        .margin({ bottom: 12 })

      // 性别
      Column() {
        Row() {
          Text('性别')
            .fontSize(16)
            .fontColor('#333333')
          Row() {
            Text(this.gender === Gender.MALE ? '男' : '女')
              .fontSize(16)
              .fontColor('#666666')
            Text('>')
              .fontSize(16)
              .fontColor('#999999')
          }
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)

        Row() {
          Text('男')
            .fontSize(14)
            .fontColor(this.gender === Gender.MALE ? '#1890FF' : '#666666')
            .padding({ left: 16, right: 16, top: 8, bottom: 8 })
            .backgroundColor(this.gender === Gender.MALE ? '#E6F7FF' : '#F5F5F5')
            .borderRadius(8)
            .onClick(() => {
              this.gender = Gender.MALE;
              this.saveUserInfo();
            })
          Text('女')
            .fontSize(14)
            .fontColor(this.gender === Gender.FEMALE ? '#FF6B8A' : '#666666')
            .padding({ left: 16, right: 16, top: 8, bottom: 8 })
            .backgroundColor(this.gender === Gender.FEMALE ? '#FFF0F5' : '#F5F5F5')
            .borderRadius(8)
            .margin({ left: 12 })
            .onClick(() => {
              this.gender = Gender.FEMALE;
              this.saveUserInfo();
            })
        }
        .margin({ top: 12 })
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')
      .borderRadius(12)
      .margin({ bottom: 12 })

      // 年龄
      Column() {
        Row() {
          Text('年龄')
            .fontSize(16)
            .fontColor('#333333')
          TextInput({ placeholder: '请输入年龄', text: this.age })
            .width(100)
            .height(36)
            .textAlign(TextAlign.End)
            .type(InputType.Number)
            .onChange((value: string) => this.age = value)
            .onBlur(() => this.saveUserInfo())
          Text('岁')
            .fontSize(14)
            .fontColor('#999999')
            .margin({ left: 4 })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')
      .borderRadius(12)
      .margin({ bottom: 12 })

      // 身高
      Column() {
        Row() {
          Text('身高')
            .fontSize(16)
            .fontColor('#333333')
          TextInput({ placeholder: '请输入身高', text: this.userHeight })
            .width(100)
            .height(36)
            .textAlign(TextAlign.End)
            .type(InputType.Number)
            .onChange((value: string) => this.userHeight = value)
            .onBlur(() => this.saveUserInfo())
          Text('cm')
            .fontSize(14)
            .fontColor('#999999')
            .margin({ left: 4 })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')
      .borderRadius(12)
      .margin({ bottom: 12 })

      // 初始体重
      Column() {
        Row() {
          Text('初始体重')
            .fontSize(16)
            .fontColor('#333333')
          TextInput({ placeholder: '请输入体重', text: this.initialWeight })
            .width(100)
            .height(36)
            .textAlign(TextAlign.End)
            .type(InputType.Number)
            .onChange((value: string) => this.initialWeight = value)
            .onBlur(() => this.saveUserInfo())
          Text('kg')
            .fontSize(14)
            .fontColor('#999999')
            .margin({ left: 4 })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')
      .borderRadius(12)
      .margin({ bottom: 12 })

      // 目标体重
      Column() {
        Row() {
          Text('目标体重')
            .fontSize(16)
            .fontColor('#333333')
          TextInput({ placeholder: '请输入目标体重', text: this.targetWeight })
            .width(100)
            .height(36)
            .textAlign(TextAlign.End)
            .type(InputType.Number)
            .onChange((value: string) => this.targetWeight = value)
            .onBlur(() => this.saveUserInfo())
          Text('kg')
            .fontSize(14)
            .fontColor('#999999')
            .margin({ left: 4 })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')
      .borderRadius(12)
    }

    if (this.errorMessage) {
      Text(this.errorMessage)
        .fontSize(14)
        .fontColor('#F5222D')
        .margin({ top: 8 })
    }

    if (this.saveSuccess) {
      Text('保存成功')
        .fontSize(14)
        .fontColor('#52C41A')
        .margin({ top: 8 })
    }
  }

  @Builder
  buildReminderSection() {
    Column() {
      Text('提醒设置')
        .fontSize(14)
        .fontColor('#666666')
        .alignSelf(ItemAlign.Start)
        .margin({ bottom: 12, top: 24 })

      // 提醒开关
      Column() {
        Row() {
          Text('每日提醒')
            .fontSize(16)
            .fontColor('#333333')
          Toggle({ type: ToggleType.Switch, isOn: this.reminderEnabled })
            .onChange((isOn: boolean) => {
              this.reminderEnabled = isOn;
              this.saveReminderSettings();
            })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')
      .borderRadius(12)

      // 提醒时间
      if (this.reminderEnabled) {
        Column() {
          Row() {
            Text('提醒时间')
              .fontSize(16)
              .fontColor('#333333')
            Row() {
              Text(this.reminderTime)
                .fontSize(16)
                .fontColor('#666666')
              Text('>')
                .fontSize(16)
                .fontColor('#999999')
            }
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#FFFFFF')
        .borderRadius(12)
        .margin({ top: 12 })
        .onClick(() => this.showTimePicker = true)
      }
    }
  }

  @Builder
  buildAboutSection() {
    Column() {
      Text('关于')
        .fontSize(14)
        .fontColor('#666666')
        .alignSelf(ItemAlign.Start)
        .margin({ bottom: 12, top: 24 })

      Column() {
        Row() {
          Text('版本')
            .fontSize(16)
            .fontColor('#333333')
          Text('1.0.0')
            .fontSize(14)
            .fontColor('#999999')
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#FFFFFF')
      .borderRadius(12)
    }
  }
}
