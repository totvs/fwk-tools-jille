const PROXY_CONFIG = [
  {
    context: ['/totvs-rest', '/totvs-login', '/dts/datasul-rest/resources', '/api'],
    target: 'http://localhost:8180',
    secure: false,
    changeOrigin: false,
    logLevel: 'debug',
    autoRewrite: false
  }
];

module.exports = PROXY_CONFIG;
