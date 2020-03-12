const settings = require('../../settings.js');
const {secret} = settings.application
const crypto = require('crypto')

// Small helpers
const addSecret = (password) => `${password}${secret}`;
const hashPassword = (password, salt) => crypto.pbkdf2Sync(
        addSecret(password), salt,
        1000, 64, `sha512`
    ).toString(`hex`);
const generateSalt = () => crypto.randomBytes(16).toString('hex');


module.exports = {addSecret, hashPassword, generateSalt};