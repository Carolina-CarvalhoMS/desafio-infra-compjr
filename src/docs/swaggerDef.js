const config = require('../config/config');
const { version } = require('../../package.json');

const swaggerDef = {
  openapi: '3.0.0',
  info: {
    title: 'node-express-boilerplate API documentation',
    version,
  },
  servers: [
    {
      url: `https://desafio-infra-compjr.onrender.com/v1`,
      description: 'Production Server',
    },
    {
      url: `http://localhost:${config.port}/v1`,
      description: 'Development Server',
    },
  ],
};

module.exports = swaggerDef;
