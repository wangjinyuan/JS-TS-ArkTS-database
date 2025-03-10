/**
 * Represents an attachment in a message.
 */
export class MessageAttachment {
  // 应用约束2: 显式声明类属性（ArkTS要求类属性必须在类体中显式声明）
  // 应用约束7: 使用private/readonly修饰符替代#私有字段
  readonly client: Client;
  message: Message;
  id: string; // 假设Snowflake类型为string
  filename: string;
  filesize: number;
  url: string;
  proxyURL: string;
  height: number | null;
  width: number | null;

  // 应用约束18: 禁止在构造函数参数中声明类字段
  constructor(message: Message, data: MessageAttachmentData) {
    // 应用约束2: 通过构造函数初始化字段
    this.client = message.client;
    this.message = message;

    // 应用约束39: 将setup方法逻辑合并到构造函数
    this.id = data.id;
    this.filename = data.filename;
    this.filesize = data.size;
    this.url = data.url;
    this.proxyURL = data.proxy_url;
    this.height = data.height ?? null;
    this.width = data.width ?? null;
  }
}

// 应用约束24: 使用接口替代对象字面量类型声明
interface MessageAttachmentData {
  id: string;
  filename: string;
  size: number;
  url: string;
  proxy_url: string;
  height?: number;
  width?: number;
}

// 应用约束60: 使用ES模块导出语法
// 假设Client和Message已在其他模块定义
// 示例类型声明（实际需根据项目定义）：
// interface Client { /* ... */ }
// interface Message { client: Client; /* ... */ }
