/**
 * Represents a Discord voice region for guilds.
 */
// 应用约束18：在类中显式声明字段而非在构造函数中
interface VoiceRegionData {
  id: string;
  name: string;
  vip: boolean;
  deprecated: boolean;
  optimal: boolean;
  custom: boolean;
  sample_hostname: string;
}

class VoiceRegion {
  // 应用约束1：显式声明静态类型
  id: string;
  name: string;
  vip: boolean;
  deprecated: boolean;
  optimal: boolean;
  custom: boolean;
  sampleHostname: string;

  constructor(data: VoiceRegionData) {
    this.id = data.id;
    this.name = data.name;
    this.vip = data.vip;
    this.deprecated = data.deprecated;
    this.optimal = data.optimal;
    this.custom = data.custom;
    this.sampleHostname = data.sample_hostname; // 注意属性名转换
  }
}

// 应用约束60：使用ES模块导入导出
export default VoiceRegion;
