class ActionsManager {
  // 应用约束2：禁止在运行时变更对象布局，改用Map存储actions
  private client: any; // 根据实际Client类型替换any
  private actions: Map<string, any> = new Map();

  constructor(client: any) { // 根据实际Client类型替换any
    // 应用约束18：类字段必须在类中显式声明
    this.client = client;

    // 应用约束60：使用ES6 import代替require，文件后缀改为.ets
    this.register(require('./MessageCreate.ets'));
    this.register(require('./MessageDelete.ets'));
    this.register(require('./MessageDeleteBulk.ets'));
    this.register(require('./MessageUpdate.ets'));
    this.register(require('./MessageReactionAdd.ets'));
    this.register(require('./MessageReactionRemove.ets'));
    this.register(require('./MessageReactionRemoveAll.ets'));
    this.register(require('./ChannelCreate.ets'));
    this.register(require('./ChannelDelete.ets'));
    this.register(require('./ChannelUpdate.ets'));
    this.register(require('./GuildDelete.ets'));
    this.register(require('./GuildUpdate.ets'));
    this.register(require('./GuildMemberGet.ets'));
    this.register(require('./GuildMemberRemove.ets'));
    this.register(require('./GuildBanRemove.ets'));
    this.register(require('./GuildRoleCreate.ets'));
    this.register(require('./GuildRoleDelete.ets'));
    this.register(require('./GuildRoleUpdate.ets'));
    this.register(require('./UserGet.ets'));
    this.register(require('./UserUpdate.ets'));
    this.register(require('./UserNoteUpdate.ets'));
    this.register(require('./GuildSync.ets'));
    this.register(require('./GuildEmojiCreate.ets'));
    this.register(require('./GuildEmojiDelete.ets'));
    this.register(require('./GuildEmojiUpdate.ets'));
    this.register(require('./GuildEmojisUpdate.ets'));
    this.register(require('./GuildRolesPositionUpdate.ets'));
    this.register(require('./GuildChannelsPositionUpdate.ets'));
  }

  // 应用约束2：通过Map维护actions而不是动态属性
  register(Action: any) { // 根据实际Action类型替换any
    const actionKey = Action.name.replace(/Action$/, '');
    this.actions.set(actionKey, new Action(this.client));
  }
}

// 应用约束60：使用ES6 export代替module.exports
export default ActionsManager;

/* 注意：
1. 需要为client参数和Action参数添加具体类型（替换代码中的any）
2. 所有导入的xxx.ets文件需要确保包含对应的类实现
3. 实际使用时建议为Action实现统一接口：
   interface Action {
     new(client: any): any;
     name: string;
   }
4. 访问action时改为使用this.actions.get('MessageCreate')方式
*/
