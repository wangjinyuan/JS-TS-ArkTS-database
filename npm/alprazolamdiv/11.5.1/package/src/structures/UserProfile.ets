// 应用约束：60. 不支持require和import赋值表达式，改用import
import Collection from '../util/Collection.ets';
import UserConnection from './UserConnection.ets';

// 应用约束：24. 对象字面量不能用于类型声明，改用接口
interface UserProfileData {
    premium: boolean;
    premium_since?: string;
    mutual_guilds: Array<{ id: string }>;
    connected_accounts: Array<any>;
}

/**
 * Represents a user's profile on Discord.
 */
class UserProfile {
    // 应用约束：18. 在class中声明字段
    user: any;
    readonly client: any;
    mutualGuilds: Collection<string, any>;
    connections: Collection<string, UserConnection>;
    premium: boolean = false;
    premiumSince: Date | null = null;

    // 应用约束：10. 使用具体类型替代any（部分参数保持any因示例上下文限制）
    constructor(user: any, data: UserProfileData) {
        this.user = user;
        // 应用约束：67. 不支持在原型上赋值，改为直接属性赋值
        this.client = user.client;

        // 应用约束：14. 使用具体集合类型
        this.mutualGuilds = new Collection<string, any>();
        this.connections = new Collection<string, UserConnection>();

        this.setup(data);
    }

    // 应用约束：45. 显式标注返回类型
    setup(data: UserProfileData): void {
        this.premium = data.premium;
        this.premiumSince = data.premium_since ? new Date(data.premium_since) : null;

        // 应用约束：21. 使用点操作符访问属性
        for (const guild of data.mutual_guilds) {
            if (this.client.guilds.has(guild.id)) {
                this.mutualGuilds.set(guild.id, this.client.guilds.get(guild.id));
            }
        }

        for (const connection of data.connected_accounts) {
            // 应用约束：30. 使用as进行类型转换
            this.connections.set(connection.id, new UserConnection(this.user, connection as any));
        }
    }
}

// 应用约束：61. 使用ES6导出语法
export default UserProfile;

// 应用约束：76. 严格类型检查补充（需在真实环境中完善类型定义）
interface Guild {}
interface Client {
    guilds: Collection<string, Guild>;
}
