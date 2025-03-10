// 应用约束：强制使用静态类型（错误1），使用let而非var（错误9），不支持在constructor中声明字段（错误18），显式标注类型（错误10）
interface FileInfo {
  attachment: Object;
  name?: string;
}

class Attachment {
  // 应用约束：显式声明类字段（错误18）
  private file: FileInfo | null = null;

  // 应用约束：构造函数参数不声明字段（错误18）
  constructor(file: Object, name?: string) {
    if (name) {
      this.setAttachment(file, name);
    } else {
      this._attach(file);
    }
  }

  // 应用约束：显式类型标注（错误10）
  get name(): string | undefined {
    return this.file?.name;
  }

  get attachment(): Object | undefined {
    return this.file?.attachment;
  }

  // 应用约束：显式返回类型（错误45）
  setAttachment(file: Object, name: string): Attachment {
    this.file = { attachment: file, name: name };
    return this;
  }

  setFile(attachment: Object): Attachment {
    this.file = { attachment: attachment };
    return this;
  }

  setName(name: string): Attachment {
    if (this.file) {
      this.file.name = name;
    }
    return this;
  }

  // 应用约束：私有方法使用private修饰符（错误7）
  private _attach(file: Object, name?: string): void {
    if (typeof file === 'string') {
      this.file = { attachment: file, name: name };
    } else {
      this.setAttachment(file, name ?? '');
    }
  }
}

// 应用约束：使用ES模块导出（错误60）
export default Attachment;
