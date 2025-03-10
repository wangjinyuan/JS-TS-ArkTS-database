const browser = typeof window !== 'undefined';
const webpack = !!process.env.__DISCORD_WEBPACK__;

const Discord = require('./');

module.exports = Discord;
if (browser && webpack) window.Discord = Discord; // eslint-disable-line no-undef
// eslint-disable-next-line no-console
else if (!browser);
