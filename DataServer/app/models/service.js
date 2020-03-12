require('../database.js')();

const mongoose = require('mongoose');
const { Schema } = require('mongoose');
const {hashPassword, generateSalt} = require('../helpers/hash.js')

const ServiceSchema = new Schema({
    name: String,
    identifier: String,
    hash: String,
    salt: String
});

class ServiceClass {
    setPasswordData() {
        let _password = generateSalt();
        this.identifier = generateSalt();
        this.salt = generateSalt();
        this.hash = hashPassword(_password, this.salt);
        return {identifier: this.identifier, password: _password};
    }

    isPasswordValid(_password) {
        const testHash = hashPassword(_password, this.salt)
        return this.hash === testHash;
    }
}

ServiceSchema.loadClass(ServiceClass);

const ServiceModel = mongoose.model('Service', ServiceSchema);

module.exports = {ServiceClass, ServiceSchema, ServiceModel};