import { userService } from './UserService';
import { weightService } from './WeightService';

/**
 * 服务管理器 - 统一初始化所有服务
 */
class ServiceManager {
  private initialized: boolean = false;

  async init(context): Promise<void> {
    if (this.initialized) {
      return;
    }

    await userService.init(context);
    await weightService.init(context);
    this.initialized = true;
  }
}

export const serviceManager = new ServiceManager();
