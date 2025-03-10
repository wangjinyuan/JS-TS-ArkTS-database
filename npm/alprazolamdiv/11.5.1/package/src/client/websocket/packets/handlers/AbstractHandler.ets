// 应用ArkTS约束：
// 7. 不支持以#开头的私有字段，改用private关键字
// 18. 不支持在constructor中声明字段，在class中声明这些字段
// 10. 使用具体的类型而非any或unknown，添加泛型类型参数
class AbstractHandler<T, U> {
  private packetManager: T;

  constructor(packetManager: T) {
    this.packetManager = packetManager;
  }

  handle(packet: U): U {
    return packet;
  }
}

export default AbstractHandler;
