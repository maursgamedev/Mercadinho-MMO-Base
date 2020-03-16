const settings = require('../../settings.js');
const {secret} = settings.application
const {ServiceModel, ServiceClass} = require('../models/service.js');
const serviceAuthentication = require('./middlewares/serviceAuthentication.js');

module.exports = (app) => { 
    app.get('/services', serviceAuthentication, (req, res) => {
        ServiceModel.find({}).then((services) => res.json(services));
    })

    app.post('/service/token', (req, res) => {
        let {identifier, password} = req.body;
        ServiceModel.findOne({identifier}).then((service) => {
            if(service.isPasswordValid(password)) {
                res.json({token: service.getToken()})
                return;
            }
            res.statusCode = 401
            res.json({error: "Password didn't match"})
        })
    })
}