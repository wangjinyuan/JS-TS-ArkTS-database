class GenericAction {
  // 应用约束1：禁止使用any类型，此处使用Object代替
  public client: Object;

  // 应用约束18：在类中显式声明字段而非在构造函数参数声明
  constructor(client: Object) {
    this.client = client;
  }

  // 应用约束1：参数和返回值使用具体类型Object代替any
  handle(data: Object): Object {
    return data;
  }
}

// 应用约束60：使用ES模块语法代替CommonJS
export default GenericAction;
