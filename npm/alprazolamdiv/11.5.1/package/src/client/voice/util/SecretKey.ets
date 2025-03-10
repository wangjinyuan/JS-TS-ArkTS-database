/**
 * Represents a Secret Key used in encryption over voice.
 * @private
 */
class SecretKey {
  // 应用约束18：在类中声明字段
  public key: Uint8Array;

  // 应用约束1：为参数添加明确类型注解
  constructor(key: number[]) {
    // 应用约束2：显式初始化类属性
    this.key = new Uint8Array(new ArrayBuffer(key.length));
    
    // 应用约束37：将for-in循环改为常规for循环
    for (let i = 0; i < key.length; i++) {
      this.key[i] = key[i];
    }
  }
}

// 应用约束60：使用ES模块导出语法
export default SecretKey;
