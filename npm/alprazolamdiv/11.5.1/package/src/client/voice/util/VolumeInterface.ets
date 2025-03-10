// 应用ArkTS约束：
// 1. 使用let代替var（约束9）
// 2. 显式类型标注（约束1,10,23）
// 3. 类属性必须显式声明和初始化（约束18）
// 4. 使用ES模块导入/导出（约束60,61）
// 5. 使用箭头函数（约束26）
// 6. 禁止使用any类型（约束1）
// 7. 使用具体类型代替Object（约束24）

import { EventEmitter } from 'events'; // 假设已转换为ets模块

/**
 * An interface class for volume transformation.
 * @extends {EventEmitter}
 */
class VolumeInterface extends EventEmitter {
    // 显式声明类属性（约束18）
    private _volume: number = 0;

    constructor(options: { volume?: number } = {}) {
        super();
        const volume = options.volume ?? 1;
        this.setVolume(volume);
    }

    /**
     * The current volume of the broadcast
     * @readonly
     */
    get volume(): number {
        return this._volume;
    }

    /**
     * The current volume of the broadcast in decibels
     * @readonly
     */
    get volumeDecibels(): number {
        return Math.log10(this._volume) * 20;
    }

    /**
     * The current volume of the broadcast from a logarithmic scale
     * @readonly
     */
    get volumeLogarithmic(): number {
        return Math.pow(this._volume, 1 / 1.660964);
    }

    applyVolume(buffer: ArrayBuffer, volume?: number): ArrayBuffer {
        const appliedVolume = volume ?? this._volume;
        if (appliedVolume === 1) return buffer;

        const out = new Uint8Array(buffer.byteLength);
        const view = new DataView(buffer);
        const outView = new DataView(out.buffer);

        for (let i = 0; i < buffer.byteLength; i += 2) {
            if (i >= buffer.byteLength - 1) break;
            const sample = view.getInt16(i, true);
            const uint = Math.min(32767, Math.max(-32767, Math.floor(appliedVolume * sample));
            outView.setInt16(i, uint, true);
        }

        return out.buffer;
    }

    /**
     * Sets the volume relative to the input stream
     * @param volume The volume that you want to set
     */
    setVolume(volume: number): void {
        this.emit('volumeChange', this._volume, volume);
        this._volume = volume;
    }

    /**
     * Set the volume in decibels.
     * @param db The decibels
     */
    setVolumeDecibels(db: number): void {
        this.setVolume(Math.pow(10, db / 20));
    }

    /**
     * Set the volume logarithmically
     * @param value The value for the volume
     */
    setVolumeLogarithmic(value: number): void {
        this.setVolume(Math.pow(value, 1.660964));
    }
}

export default VolumeInterface;
