import router from '@ohos.router';
import { Gender } from '../models/UserModel';
import { userService } from '../services/UserService';
import { serviceManager } from '../services/ServiceManager';

@Entry
@Component
struct Welcome {
  @State currentStep: number = 0;
  @State gender: Gender = Gender.MALE;
  @State age: string = '';
  @State userHeight: string = '';
  @State initialWeight: string = '';
  @State targetWeight: string = '';
  @State errorMessage: string = '';
  @State isLoading: boolean = false;

  async aboutToAppear() {
    // 检查是否已设置用户信息
    const isSet = await userService.isUserInfoSet();
    if (isSet) {
      router.replaceUrl({ url: 'pages/Index' });
    }
  }

  validateCurrentStep(): boolean {
    this.errorMessage = '';
    switch (this.currentStep) {
      case 0:
        // 性别不需要验证
        return true;
      case 1:
        const ageNum = parseInt(this.age);
        if (!this.age || isNaN(ageNum) || ageNum <= 0 || ageNum > 150) {
          this.errorMessage = '请输入有效的年龄';
          return false;
        }
        return true;
      case 2:
        const heightNum = parseInt(this.userHeight);
        if (!this.userHeight || isNaN(heightNum) || heightNum <= 0 || heightNum > 300) {
          this.errorMessage = '请输入有效的身高';
          return false;
        }
        return true;
      case 3:
        const weightNum = parseFloat(this.initialWeight);
        if (!this.initialWeight || isNaN(weightNum) || weightNum <= 0 || weightNum > 500) {
          this.errorMessage = '请输入有效的体重';
          return false;
        }
        return true;
      case 4:
        const targetNum = parseFloat(this.targetWeight);
        if (!this.targetWeight || isNaN(targetNum) || targetNum <= 0 || targetNum > 500) {
          this.errorMessage = '请输入有效的目标体重';
          return false;
        }
        return true;
      default:
        return true;
    }
  }

  async nextStep() {
    if (!this.validateCurrentStep()) {
      return;
    }

    if (this.currentStep < 4) {
      this.currentStep++;
    } else {
      await this.saveAndGoHome();
    }
  }

  previousStep() {
    if (this.currentStep > 0) {
      this.currentStep--;
      this.errorMessage = '';
    }
  }

  async saveAndGoHome() {
    this.isLoading = true;
    try {
      const userInfo = {
        id: '1',
        gender: this.gender,
        age: parseInt(this.age),
        height: parseInt(this.userHeight),
        initialWeight: parseFloat(this.initialWeight),
        targetWeight: parseFloat(this.targetWeight)
      };
      await userService.saveUserInfo(userInfo);
      router.replaceUrl({ url: 'pages/Index' });
    } catch (error) {
      this.errorMessage = '保存失败，请重试';
    }
    this.isLoading = false;
  }

  build() {
    Column() {
      // 进度指示器
      Row() {
        ForEach([0, 1, 2, 3, 4], (index: number) => {
          Column() {
            Row()
              .width(this.currentStep >= index ? '100%' : '100%')
              .height('100%')
              .backgroundColor(this.currentStep >= index ? '#1890FF' : '#E0E0E0')
              .borderRadius(4)
          }
          .width(40)
          .height(4)
          .margin({ right: 8 })
        })
      }
      .width('80%')
      .margin({ top: 60, bottom: 40 })

      // 标题
      Text(this.getStepTitle())
        .fontSize(28)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 40 })

      // 内容区域
      Column() {
        if (this.currentStep === 0) {
          // 性别选择
          this.buildGenderSelector()
        } else if (this.currentStep === 1) {
          // 年龄输入
          this.buildAgeInput()
        } else if (this.currentStep === 2) {
          // 身高输入
          this.buildHeightInput()
        } else if (this.currentStep === 3) {
          // 初始体重
          this.buildInitialWeightInput()
        } else {
          // 目标体重
          this.buildTargetWeightInput()
        }
      }
      .width('85%')
      .layoutWeight(1)

      // 错误提示
      if (this.errorMessage) {
        Text(this.errorMessage)
          .fontSize(14)
          .fontColor('#F5222D')
          .margin({ bottom: 16 })
      }

      // 按钮区域
      Row() {
        if (this.currentStep > 0) {
          Button('上一步')
            .width(120)
            .height(44)
            .backgroundColor('#F5F5F5')
            .fontColor('#333333')
            .onClick(() => this.previousStep())
        }

        Button(this.currentStep === 4 ? '完成' : '下一步')
          .width(120)
          .height(44)
          .backgroundColor('#1890FF')
          .fontColor('#FFFFFF')
          .enabled(!this.isLoading)
          .onClick(() => this.nextStep())
      }
      .width('85%')
      .justifyContent(this.currentStep > 0 ? FlexAlign.SpaceBetween : FlexAlign.Center)
      .margin({ bottom: 40 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }

  @Builder
  buildGenderSelector() {
    Column() {
      Text('请选择您的性别')
        .fontSize(16)
        .fontColor('#666666')
        .margin({ bottom: 30 })

      Row() {
        Column() {
          Text('男')
            .fontSize(20)
            .fontWeight(FontWeight.Medium)
            .fontColor(this.gender === Gender.MALE ? '#FFFFFF' : '#333333')
          Text('Male')
            .fontSize(12)
            .fontColor(this.gender === Gender.MALE ? '#FFFFFF' : '#999999')
        }
        .width(120)
        .height(120)
        .backgroundColor(this.gender === Gender.MALE ? '#1890FF' : '#F5F5F5')
        .borderRadius(16)
        .justifyContent(FlexAlign.Center)
        .onClick(() => this.gender = Gender.MALE)

        Column() {
          Text('女')
            .fontSize(20)
            .fontWeight(FontWeight.Medium)
            .fontColor(this.gender === Gender.FEMALE ? '#FFFFFF' : '#333333')
          Text('Female')
            .fontSize(12)
            .fontColor(this.gender === Gender.FEMALE ? '#FFFFFF' : '#999999')
        }
        .width(120)
        .height(120)
        .backgroundColor(this.gender === Gender.FEMALE ? '#FF6B8A' : '#F5F5F5')
        .borderRadius(16)
        .justifyContent(FlexAlign.Center)
        .onClick(() => this.gender = Gender.FEMALE)
      }
      .justifyContent(FlexAlign.SpaceEvenly)
      .width('100%')
    }
  }

  @Builder
  buildAgeInput() {
    Column() {
      Text('请输入您的年龄')
        .fontSize(16)
        .fontColor('#666666')
        .margin({ bottom: 30 })

      TextInput({ placeholder: '请输入年龄', text: this.age })
        .width('100%')
        .height(56)
        .fontSize(24)
        .textAlign(TextAlign.Center)
        .type(InputType.Number)
        .onChange((value: string) => this.age = value)

      Text('岁')
        .fontSize(18)
        .fontColor('#333333')
        .margin({ top: 16 })
    }
  }

  @Builder
  buildHeightInput() {
    Column() {
      Text('请输入您的身高')
        .fontSize(16)
        .fontColor('#666666')
        .margin({ bottom: 30 })

      TextInput({ placeholder: '请输入身高', text: this.userHeight })
        .width('100%')
        .height(56)
        .fontSize(24)
        .textAlign(TextAlign.Center)
        .type(InputType.Number)
        .onChange((value: string) => this.userHeight = value)

      Text('厘米 (cm)')
        .fontSize(18)
        .fontColor('#333333')
        .margin({ top: 16 })
    }
  }

  @Builder
  buildInitialWeightInput() {
    Column() {
      Text('请输入您的初始体重')
        .fontSize(16)
        .fontColor('#666666')
        .margin({ bottom: 30 })

      TextInput({ placeholder: '请输入体重', text: this.initialWeight })
        .width('100%')
        .height(56)
        .fontSize(24)
        .textAlign(TextAlign.Center)
        .type(InputType.Number)
        .onChange((value: string) => this.initialWeight = value)

      Text('公斤 (kg)')
        .fontSize(18)
        .fontColor('#333333')
        .margin({ top: 16 })
    }
  }

  @Builder
  buildTargetWeightInput() {
    Column() {
      Text('请输入您的目标体重')
        .fontSize(16)
        .fontColor('#666666')
        .margin({ bottom: 30 })

      TextInput({ placeholder: '请输入目标体重', text: this.targetWeight })
        .width('100%')
        .height(56)
        .fontSize(24)
        .textAlign(TextAlign.Center)
        .type(InputType.Number)
        .onChange((value: string) => this.targetWeight = value)

      Text('公斤 (kg)')
        .fontSize(18)
        .fontColor('#333333')
        .margin({ top: 16 })
    }
  }

  getStepTitle(): string {
    const titles = [
      '欢迎使用',
      '您的年龄是？',
      '您的身高是？',
      '您的初始体重是？',
      '您的目标体重是？'
    ];
    return titles[this.currentStep];
  }
}
