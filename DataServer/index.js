const express = require('express');
const initDatabase = require('./app/database.js');
const settings = require('./settings.js'); 
const argv = require('yargs').argv;
const bodyParser = require('body-parser')
const app = express();
const {port, authPort} = settings.application;


initDatabase().then(() => {
    app.use(express.json());
    app.use(bodyParser.json());

    app.use((req, _res, next) => {
        console.log(`Got a "${req.method}" request at "${req.originalUrl}" with "`, req.query, `"`)
        console.log(`with data`, req.body)
        next()
    })

    if(argv.players) {
        app.use('/players', require('./app/playerAuthRoutes'))
    } else {
        app.use('/services', require('./app/routes'))
    }

    let currentPort = null
    if (argv.port) {
        currentPort = argv.port
    } else {
        currentPort = argv.players ? authPort : port
    }

    app.listen(currentPort, () => console.log(`Data server started at the port ${currentPort}`))
}).catch((error) => {
    console.log('There was a error trying to connect to the mongodb database:')
    console.error(error)
    process.exit(1)
});