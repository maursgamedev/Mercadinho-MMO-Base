const {ServiceModel} = require('../models/service.js');

module.exports = (app) => { 
    app.get('/services', (req, res) => {
        ServiceModel.find({}).then((services) => res.json(services));
    })
}