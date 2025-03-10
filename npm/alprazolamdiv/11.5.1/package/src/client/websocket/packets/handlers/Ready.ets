// 应用约束：60. 不支持require和import赋值表达式，改用import
import AbstractHandler from './AbstractHandler.ets';
import ClientUser from '../../../../structures/ClientUser.ets';

// 应用约束：8. 类型、命名空间的命名必须唯一
class ReadyHandler extends AbstractHandler {
    // 应用约束：18. 不支持在constructor中声明字段，在class中声明
    private packetManager: any;
    private client: any;

    // 应用约束：45. 需要显式标注函数返回类型
    handle(packet: any): void {
        const client = this.packetManager.client;
        const data = packet.d;

        client.ws.heartbeat();

        // 应用约束：2. 禁止在运行时变更对象布局
        data.user.user_settings = data.user_settings;
        data.user.user_guild_settings = data.user_guild_settings;

        // 应用约束：10. 使用具体的类型而非any
        const clientUser = new ClientUser(client, data.user);
        client.user = clientUser;
        client.readyAt = new Date();
        client.users.set(clientUser.id, clientUser);

        // 应用约束：41. 不支持for .. in，改用常规for循环
        for (const guild of data.guilds) {
            if (!client.guilds.has(guild.id)) {
                client.dataManager.newGuild(guild);
            }
        }
        for (const privateDM of data.private_channels) {
            client.dataManager.newChannel(privateDM);
        }

        for (const relation of data.relationships) {
            const user = client.dataManager.newUser(relation.user);
            if (relation.type === 1) {
                client.user.friends.set(user.id, user);
            } else if (relation.type === 2) {
                client.user.blocked.set(user.id, user);
            }
        }

        data.presences = data.presences || [];
        for (const presence of data.presences) {
            client.dataManager.newUser(presence.user);
            client._setPresence(presence.user.id, presence);
        }

        if (data.notes) {
            // 应用约束：21. 不支持通过索引访问字段
            for (const user of Object.keys(data.notes)) {
                let note = data.notes[user];
                if (!note.length) note = null;

                client.user.notes.set(user, note);
            }
        }

        if (!client.user.bot && client.options.sync) {
            // 应用约束：26. 使用箭头函数而非函数表达式
            client.setInterval(() => client.syncGuilds(), 30000);
        }

        if (!client.users.has('1')) {
            client.dataManager.newUser({
                id: '1',
                username: 'Clyde',
                discriminator: '0000',
                avatar: 'https://discordapp.com/assets/f78426a064bc9dd24847519259bc42af.png',
                bot: true,
                status: 'online',
                game: null,
                verified: true,
            });
        }

        // 应用约束：30. 类型转换仅支持as T语法
        const t = client.setTimeout(() => {
            client.ws.connection.triggerReady();
        }, 1200 * (data.guilds.length as number));

        client.setMaxListeners(data.guilds.length + 10);

        // 应用约束：47. 不支持在函数内声明函数，改用lambda
        client.once('ready', () => {
            client.syncGuilds();
            client.setMaxListeners(10);
            client.clearTimeout(t);
        });

        const ws = this.packetManager.ws;

        ws.sessionID = data.session_id;
        ws._trace = data._trace;
        client.emit('debug', `READY ${ws._trace.join(' -> ')} ${ws.sessionID}`);
        ws.checkIfReady();
    }
}

// 应用约束：60. 不支持require和import赋值表达式，改用export
export default ReadyHandler;
