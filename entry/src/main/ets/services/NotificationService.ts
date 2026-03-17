import reminderAgentManager from '@ohos.reminderAgentManager';
import wantAgent from '@ohos.wantAgent';

class NotificationService {
  private reminderId: number = -1;

  /**
   * 创建定时提醒
   */
  async createReminder(context, hour: number, minute: number): Promise<boolean> {
    try {
      // 先取消已有的提醒
      await this.cancelReminder();

      // 创建wantAgent
      const wantAgentInfo: WantAgentInfo = {
        wants: [
          {
            bundleName: 'com.example.weightmanagement',
            abilityName: 'EntryAbility'
          }
        ],
        operationType: wantAgent.OperationType.START_ABILITY,
        requestCode: 0,
        wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG]
      };

      const agent = await this.getWantAgent(context, wantAgentInfo);

      // 创建提醒
      const reminderRequest: reminderAgentManager.ReminderRequestCalendar = {
        reminderType: reminderAgentManager.ReminderType.REMINDER_TYPE_CALENDAR,
        dateTime: {
          year: new Date().getFullYear(),
          month: new Date().getMonth() + 1,
          day: new Date().getDate(),
          hour: hour,
          minute: minute
        },
        repeatMonths: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
        repeatDays: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31],
        title: '体重记录提醒',
        content: '该记录今天的体重了哦',
        wantAgent: agent
      };

      this.reminderId = await reminderAgentManager.publishReminder(reminderRequest);
      return true;
    } catch (error) {
      console.error('创建提醒失败:', error);
      return false;
    }
  }

  private getWantAgent(context, info: WantAgentInfo): Promise<object> {
    return new Promise((resolve, reject) => {
      wantAgent.getWantAgent(context, info, (err, data) => {
        if (err) {
          reject(err);
        } else {
          resolve(data);
        }
      });
    });
  }

  /**
   * 取消定时提醒
   */
  async cancelReminder(): Promise<boolean> {
    try {
      if (this.reminderId !== -1) {
        await reminderAgentManager.cancelReminder(this.reminderId);
        this.reminderId = -1;
      }
      return true;
    } catch (error) {
      console.error('取消提醒失败:', error);
      return false;
    }
  }

  /**
   * 检查提醒是否已开启
   */
  hasReminder(): boolean {
    return this.reminderId !== -1;
  }
}

interface WantAgentInfo {
  wants: Array<{
    bundleName: string;
    abilityName: string;
  }>;
  operationType: wantAgent.OperationType;
  requestCode: number;
  wantAgentFlags: wantAgent.WantAgentFlags[];
}

interface WantAgent {
  pkgName: string;
  abilityName: string;
}

export const notificationService = new NotificationService();
