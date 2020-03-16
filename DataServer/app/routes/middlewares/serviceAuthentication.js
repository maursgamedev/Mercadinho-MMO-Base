const jwt = require('jsonwebtoken');
const settings = require('../../../settings.js');
const {secret} = settings.application
const {ServiceModel} = require('../../models/service');

module.exports = (req, res, next) => {
    let decoded = null
    let token = null
    let authHeader = null

    if (!req.headers.authorization) {
        res.statusCode = 400
        res.json({error: 'no authorization header'})
        return;
    }

    authHeader = req.headers.authorization.split(' ')

    if (authHeader[0] !== 'Bearer') {
        res.statusCode = 400
        res.json({error: 'Header not correctly formatted'})
        return;
    }

    token = authHeader[1]

    try {
        decoded = jwt.verify(token, secret);
    } catch(error) {
        res.statusCode = 401
        res.json({error: 'Invalid Token'})
        return;
    }

    req.service = ServiceModel.findOne({_id: decoded.id}).then((service) => {
        req.service = service
        next()
    }).catch((error) => {
        res.statusCode = 500
        res.json({error: `Could not find the service, got error: ${error}`})
    });
}