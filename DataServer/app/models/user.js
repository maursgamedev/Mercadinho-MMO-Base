require('../database.js')();

const mongoose = require('mongoose');
const { Schema } = require('mongoose');
const mailer = require('../mailer.js');
const {loadTemplate} = require('../views');
const UserValidator = require('./validators/userValidator');
const {hashPassword, generateSalt} = require('../helpers/hash.js');

// Settings
const {authAddress, senderEmail} = require('../../settings.js').application;

//
const UserSchema = new Schema({
    username: String,
    email: String,
    authorizations: [String],
    emailConfirmation: {
        salt: String,
        token: String,
        confirmed: Boolean,
    },
    secret: {
        hash: String,
        salt: String,
    }
}, { timestamps: true });

//
class UserClass {
    set password(_password) {
        this.secret.salt = generateSalt();
        this.secret.hash = hashPassword(_password, this.secret.salt);
    }

    isPasswordValid(_password) {
        const testHash = hashPassword(_password, this.secret.salt)
        return this.secret.hash === testHash;
    }

    sendEmailConfirmation() {
        let token = generateSalt();
        let salt = generateSalt();
        let hash = hashPassword(token, salt);
        let confirmed = false;
        this.emailConfirmation = {salt, hash, confirmed};
        
        mailer.sendMail({
            from: senderEmail,
            to: this.email,
            subject: 'Please confirm your email',
            html: loadTemplate('./views/email/emailConfirmation.hbs')({
                emailConfirmationLink: this.constructor.emailConfirmationLink(this.email, token),
                username: this.username
            })
        })
    }

    confirmEmail(token) {
        let {salt, hash} = this.emailConfirmation;
        this.emailConfirmation.confirmed = hash === hashPassword(token, salt);
        if (this.emailConfirmation.confirmed) {
            this.emailConfirmation.hash = null;
            this.emailConfirmation.salt = null;
        }
        return this.emailConfirmation.confirmed;
    }

    forceEmailConfirmation() {
        this.emailConfirmation.confirmed = true;
        this.emailConfirmation.hash = null;
        this.emailConfirmation.salt = null;
    }

    getToken() {
        return jwt.sign({
            id: this._id,
        }, secret, {expiresIn: '1h'});
    }

    static emailConfirmationLink(email,token) {
        return `${authAddress}/email_confirmation?email${email}&token=${token}`
    }
}

//
UserSchema.loadClass(UserClass);

//
const UserModel = mongoose.model('User', UserSchema);

const User = UserModel;
//
module.exports = {UserClass, UserSchema, UserModel, UserValidator, User};