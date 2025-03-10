// 应用ArkTS约束：使用import代替require，文件后缀改为.ets
import Action from './Action.ets';
import Constants from '../../util/Constants.ets';

// 应用ArkTS约束：类属性需要显式初始化，但本例中属性继承自父类
class UserNoteUpdateAction extends Action {
  // 应用ArkTS约束：参数需要明确类型定义
  handle(data: { id: string; note: string }) {
    const client = this.client;

    // 应用ArkTS约束：Map需要明确类型参数
    const oldNote = client.user.notes.get(data.id);
    const note = data.note.length > 0 ? data.note : null;

    client.user.notes.set(data.id, note);

    // 应用ArkTS约束：常量需要从模块导入
    client.emit(Constants.Events.USER_NOTE_UPDATE, data.id, oldNote, note);

    return {
      old: oldNote,
      updated: note,
    };
  }
}

/**
 * Emitted whenever a note is updated.
 * @event Client#userNoteUpdate
 * @param {User} user The user the note belongs to
 * @param {string} oldNote The note content before the update
 * @param {string} newNote The note content after the update
 */

// 应用ArkTS约束：使用export default代替module.exports
export default UserNoteUpdateAction;
