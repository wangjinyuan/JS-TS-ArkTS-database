// 应用约束60：使用import代替require
import Permissions from '../../util/Permissions.ets';
import Collection from '../../util/Collection.ets';

// 应用约束24：使用接口代替对象字面量类型声明
interface PermissionOverwrite {
    id: string;
    type: string;
    allow?: number;
    allowed?: number;
    deny?: number;
    denied?: number;
}

interface ResolvedPermission {
    allow: number;
    deny: number;
    type: string;
    id: string;
}

// 应用约束60：使用export代替module.exports
export function resolvePermissions(overwrites: Collection<PermissionOverwrite> | PermissionOverwrite[], guild: any): ResolvedPermission[] {
    // 应用约束14：使用数组类型代替索引签名
    if (overwrites instanceof Collection || overwrites instanceof Array) {
        // 应用约束23：显式标注map回调参数类型
        return overwrites.map((overwrite: PermissionOverwrite) => {
            const role = this.client.resolver.resolveRole(guild, overwrite.id);
            let resolvedType: string;
            let resolvedId: string;

            if (role) {
                resolvedId = role.id;
                resolvedType = 'role';
            } else {
                resolvedId = this.client.resolver.resolveUserID(overwrite.id);
                resolvedType = 'member';
            }

            // 应用约束10：使用具体类型代替any
            return {
                allow: Permissions.resolve(overwrite.allow || overwrite.allowed || 0),
                deny: Permissions.resolve(overwrite.deny || overwrite.denied || 0),
                type: resolvedType,
                id: resolvedId
            } as ResolvedPermission;
        });
    }
    return overwrites as ResolvedPermission[];
}

// 应用约束9：使用const/let代替var（已在函数参数和返回值中处理）
