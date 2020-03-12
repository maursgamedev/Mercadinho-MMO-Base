const mongoose = require('mongoose');
const settings = require('../settings.js');

module.exports = () => mongoose.connect(settings.mongodb.address, {useNewUrlParser: true, useUnifiedTopology: true})