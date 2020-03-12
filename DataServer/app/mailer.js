const nodemailer = require('nodemailer');
const settings = require('../settings.js'); 
const mailerSettings = settings.nodemailer;

const mailer = nodemailer.createTransport(mailerSettings);

module.exports = mailer;