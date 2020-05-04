const Handlebars = require('handlebars');
const fs = require('fs');

const loadTemplate = (view) => Handlebars.compile(fs.readFileSync(`${__dirname}/${view}`, 'utf-8'));

module.exports = {loadTemplate}