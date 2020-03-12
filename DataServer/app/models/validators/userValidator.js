class UserValidator {
    constructor(user) {
        this.user = user;
        this.UserModel = user.constructor;
        this.isFieldUnique = this.isFieldUnique.bind(this)
    }

    isFieldUnique(fieldName) {
        return this.UserModel.where(fieldName, this.user[fieldName]).exec().then((result) => {
            new Promise((resolve) => resolve(!result && !result.length));
        });
    }

    save() {
        return this.isFieldUnique('email').then((result) => {
            if (result) {
                return this.isFieldUnique('username')
            }
            return new Promise( (_, failure) => failure('This email is already in use.') )
        }).then((result) => {
            if (result) {
                this.user.sendEmailConfirmation();
                return this.user.save();
            }
            return new Promise( (_, failure) => failure('This username is already in use.') )
        })
    }
}

module.exports = UserValidator;