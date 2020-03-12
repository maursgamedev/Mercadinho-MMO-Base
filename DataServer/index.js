const express = require('express');
const initDatabase = require('./app/database.js');
const settings = require('./settings.js'); 

initDatabase();
const app = express();
const port = settings.application.port;

app.use(express.json());

require('./app/routes')(app);

app.listen(port, () => console.log(`Data server started at the port ${port}`))