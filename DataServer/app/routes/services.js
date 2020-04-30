const express = require('express');
const router = express.Router();
const settings = require('../../settings.js');
const {secret} = settings.application
const {ServiceModel, ServiceClass} = require('../models/service.js');
const serviceAuthentication = require('./middlewares/serviceAuthentication.js');

router.get('/', serviceAuthentication, (req, res) => {
    ServiceModel.find({}).then((services) => res.json(services));
})

router.post('/token', (req, res) => {
    let {identifier, password} = req.body;
    ServiceModel.findOne({identifier}).then((service) => {
        if(service.isPasswordValid(password)) {
            res.json({token: service.getToken()})
            return;
        }
        res.statusCode = 401
        res.json({error: "Token didn't match"})
    })
})

module.exports = router;