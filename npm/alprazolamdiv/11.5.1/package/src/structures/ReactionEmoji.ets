// 应用约束18：在类中声明字段而非构造函数中
class ReactionEmoji {
  // 应用约束1：使用静态类型
  public reaction: Object;
  public name: string;
  public id: string | null;

  // 应用约束1：参数添加类型标注
  constructor(reaction: Object, name: string, id: string | null) {
    this.reaction = reaction;
    this.name = name;
    this.id = id;
  }

  // 应用约束1：添加返回类型标注
  get identifier(): string {
    if (this.id) return `${this.name}:${this.id}`;
    return encodeURIComponent(this.name);
  }

  // 应用约束1：添加返回类型标注
  toString(): string {
    return this.id ? `<:${this.name}:${this.id}>` : this.name;
  }
}

// 应用约束60：使用ES模块导出语法
export default ReactionEmoji;

// 应用约束24：使用类替代对象字面量类型
interface MessageReaction {} // 假设存在的类型定义

/* 原始注释保留：
 * Represents a limited emoji set used for both custom and unicode emojis. Custom emojis
 * will use this class opposed to the Emoji class when the client doesn't know enough
 * information about them.
 */
