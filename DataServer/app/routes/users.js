const {User, UserValidator} = require('../models/user.js');

module.exports = (app) => { 
    app.get('/users', (req, res) => {
        User.find({}).then((users) => res.json(users));
    })

    app.post('/users', (req, res) => {
        const {username, email, password, password_confirmation} = req.body
        if (password != password_confirmation) {
            return res.status(400).sendJson({error: `Password and Password Confirmation doesn't match`})
        }
        let user = new User({username, password, email});
        let userValidator = new UserValidator(user);
        userValidator.save()
            .then(() => res.status(200).sendJson({message: `User registered successfully.`}))
            .catch((error) => res.status(400).sendJson({error}))
    })
}