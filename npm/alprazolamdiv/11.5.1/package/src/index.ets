// 应用约束：60. 不支持require和import赋值表达式，改用import
import * as Util from './util/Util.ets';
import Client from './client/Client.ets';
import Shard from './sharding/Shard.ets';
import ShardClientUtil from './sharding/ShardClientUtil.ets';
import ShardingManager from './sharding/ShardingManager.ets';
import WebhookClient from './client/WebhookClient.ets';
import Collection from './util/Collection.ets';
import Constants from './util/Constants.ets';
import DiscordAPIError from './client/rest/DiscordAPIError.ets';
import EvaluatedPermissions from './util/Permissions.ets';
import Permissions from './util/Permissions.ets';
import Snowflake from './util/Snowflake.ets';
import SnowflakeUtil from './util/Snowflake.ets';
import version from '../package.ets';
import Attachment from './structures/Attachment.ets';
import CategoryChannel from './structures/CategoryChannel.ets';
import Channel from './structures/Channel.ets';
import ClientUser from './structures/ClientUser.ets';
import ClientUserSettings from './structures/ClientUserSettings.ets';
import Collector from './structures/interfaces/Collector.ets';
import DMChannel from './structures/DMChannel.ets';
import Emoji from './structures/Emoji.ets';
import { Game } from './structures/Presence.ets';
import GroupDMChannel from './structures/GroupDMChannel.ets';
import Guild from './structures/Guild.ets';
import GuildAuditLogs from './structures/GuildAuditLogs.ets';
import GuildChannel from './structures/GuildChannel.ets';
import GuildMember from './structures/GuildMember.ets';
import Invite from './structures/Invite.ets';
import Message from './structures/Message.ets';
import MessageAttachment from './structures/MessageAttachment.ets';
import MessageCollector from './structures/MessageCollector.ets';
import MessageEmbed from './structures/MessageEmbed.ets';
import MessageMentions from './structures/MessageMentions.ets';
import MessageReaction from './structures/MessageReaction.ets';
import NewsChannel from './structures/NewsChannel.ets';
import OAuth2Application from './structures/OAuth2Application.ets';
import ClientOAuth2Application from './structures/OAuth2Application.ets';
import PartialGuild from './structures/PartialGuild.ets';
import PartialGuildChannel from './structures/PartialGuildChannel.ets';
import PermissionOverwrites from './structures/PermissionOverwrites.ets';
import { Presence } from './structures/Presence.ets';
import ReactionEmoji from './structures/ReactionEmoji.ets';
import ReactionCollector from './structures/ReactionCollector.ets';
import RichEmbed from './structures/RichEmbed.ets';
import Role from './structures/Role.ets';
import StoreChannel from './structures/StoreChannel.ets';
import TextChannel from './structures/TextChannel.ets';
import User from './structures/User.ets';
import VoiceChannel from './structures/VoiceChannel.ets';
import Webhook from './structures/Webhook.ets';

// 应用约束：24. 对象字面量不能用于类型声明，改用接口或类
export default {
  // "Root" classes (starting points)
  Client,
  Shard,
  ShardClientUtil,
  ShardingManager,
  WebhookClient,

  // Utilities
  Collection,
  Constants,
  DiscordAPIError,
  EvaluatedPermissions: EvaluatedPermissions,
  Permissions,
  Snowflake,
  SnowflakeUtil,
  Util: Util,
  util: Util,
  version,

  // Shortcuts to Util methods
  escapeMarkdown: Util.escapeMarkdown,
  fetchRecommendedShards: Util.fetchRecommendedShards,
  splitMessage: Util.splitMessage,

  // Structures
  Attachment,
  CategoryChannel,
  Channel,
  ClientUser,
  ClientUserSettings,
  Collector,
  DMChannel,
  Emoji,
  Game,
  GroupDMChannel,
  Guild,
  GuildAuditLogs,
  GuildChannel,
  GuildMember,
  Invite,
  Message,
  MessageAttachment,
  MessageCollector,
  MessageEmbed,
  MessageMentions,
  MessageReaction,
  NewsChannel,
  OAuth2Application,
  ClientOAuth2Application,
  PartialGuild,
  PartialGuildChannel,
  PermissionOverwrites,
  Presence,
  ReactionEmoji,
  ReactionCollector,
  RichEmbed,
  Role,
  StoreChannel,
  TextChannel,
  User,
  VoiceChannel,
  Webhook
};
