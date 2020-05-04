class UserValidator {
    constructor(rawData, user) {
        this.rawData = rawData;
        this.user = user;
        this.UserModel = user.constructor;
        this.isFieldUnique = this.isFieldUnique.bind(this)
    }

    isFieldUnique(fieldName) {
        let query = {}
        query[fieldName] = this.rawData[fieldName]
        return new Promise((resolve, reject) => {
            this.UserModel.where(query).exec((err,users) => {
                let isUnique = !users.length || !users;
                if (err) {
                    return reject(err)
                }
                if (isUnique) {
                    return reject(`${fieldName} isn't unique`)
                }
                resolve()
            });
        });
    }

    validatePassword() {
        let err = null
        let {password, password_confirmation} = this.rawData
        let validPassowrdLenght = password >= 6
        let passwordMatch = password === password_confirmation
        
        if (!validPassowrdLenght){
            err = 'password needs to have at least 6 characters';
        }
        if (!err && !passwordMatch) {
            err = `the password and password confirmation doesn't match`;
        }
        return new Promise((resolve,reject) => err ? reject(err) : resolve())
    }

    create() {
        return this.isFieldUnique('email')
            .then(this.isFieldUnique('username'))
            .then(this.validatePassword())
            .then(() => {
                this.user.sendEmailConfirmation();
                return this.user.save();
            })
    }
}

module.exports = UserValidator;