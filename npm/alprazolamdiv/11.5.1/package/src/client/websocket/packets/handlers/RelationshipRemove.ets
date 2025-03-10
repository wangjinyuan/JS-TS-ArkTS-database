// 应用约束60：使用import代替require
import AbstractHandler from './AbstractHandler.ets';

// 应用约束1：定义接口和类型以避免any
interface PacketData {
    type: number;
    id: string;
}

interface ClientType {
    user: {
        blocked: Set<string>;
        friends: Set<string>;
    };
}

interface PacketType {
    d: PacketData;
}

class RelationshipRemoveHandler extends AbstractHandler {
    // 应用约束1：显式声明client类型
    private packetManager: { client: ClientType };

    handle(packet: PacketType): void {
        const client = this.packetManager.client;
        const data = packet.d;
        
        if (data.type === 2) {
            if (client.user.blocked.has(data.id)) {
                client.user.blocked.delete(data.id); // 应用约束21：使用Set的标准API
            }
        } else if (data.type === 1) {
            if (client.user.friends.has(data.id)) {
                client.user.friends.delete(data.id); // 应用约束21：使用Set的标准API
            }
        }
    }
}

// 应用约束60：使用export default代替module.exports
export default RelationshipRemoveHandler;
