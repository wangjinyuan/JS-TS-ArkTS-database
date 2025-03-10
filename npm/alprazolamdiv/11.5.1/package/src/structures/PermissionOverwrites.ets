// 应用约束：60. 不支持require和import赋值表达式，改用import
import Permissions from '../util/Permissions.ets'; // 约束78：文件后缀转换

// 约束24：对象字面量不能用于类型声明，改用接口
interface PermissionOverwriteData {
    id: string;
    type: string;
    deny: number;
    allow: number;
}

/**
 * Represents a permission overwrite for a role or member in a guild channel.
 */
class PermissionOverwrites {
    // 约束2：禁止在运行时变更对象布局，使用显式属性声明
    public readonly channel: any; // 约束1：需替换any为具体类型
    public id: string = '';
    public type: string = '';
    public deny: number = 0;
    public allow: number = 0;
    public denied: Permissions;
    public allowed: Permissions;

    // 约束18：构造函数中不能声明字段，需在类中声明
    constructor(guildChannel: any, data?: PermissionOverwriteData) { // 约束1：需替换any为具体类型
        // 约束2：使用属性赋值替代Object.defineProperty
        this.channel = guildChannel;

        if (data) {
            this.setup(data);
        }
    }

    setup(data: PermissionOverwriteData): void { // 约束1：添加具体类型
        this.id = data.id;
        this.type = data.type;
        this.deny = data.deny;
        this.allow = data.allow;

        // 约束1：避免any类型，保持Permissions类型
        this.denied = new Permissions(data.deny).freeze();
        this.allowed = new Permissions(data.allow).freeze();
    }

    /**
     * Delete this Permission Overwrite.
     * @param reason Reason for deleting this overwrite
     */
    // 约束45：需要显式标注返回类型
    delete(reason?: string): Promise<PermissionOverwrites> {
        // 约束1：需替换any为具体类型
        return this.channel.client.rest.methods.deletePermissionOverwrites(this, reason);
    }
}

// 约束61：不支持export = ...语法，改用export default
export default PermissionOverwrites;

// 应用约束说明：
// 1. 转换require为import并修改文件后缀（约束60、78）
// 2. 使用接口替代对象字面量类型声明（约束24）
// 3. 类属性显式声明并初始化（约束2、18）
// 4. 移除Object.defineProperty改用属性声明（约束2）
// 5. 为所有方法和参数添加类型标注（约束1、10）
// 6. 修改module.exports为export default（约束61）
// 7. 保持Promise返回类型显式声明（约束45）
// 注意：channel属性类型需要根据实际GuildChannel类型定义替换any类型
