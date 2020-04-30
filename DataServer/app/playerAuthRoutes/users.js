const express = require('express');
const router = express.Router();
const {UserModel, UserClass, UserValidator} = require('../models/user.js')

const internalError = (res, message = null) => () => {
    res.statusCode = 500
    res.json({error: message || 'A error ocurred while trying to fetch your data'})
}

router.post('/auth', (req, res) => {
    let {email, password} = req.body
    UserModel.findOne({ email: email }).then((user) => {
        if (!user) { 
            res.statusCode = 404
            res.json({error: `No user found with this email.`})
            return
        }
        if (!user.isPasswordValid(password)) {
            res.statusCode = 401
            res.json({error: `Password doesn't match.`})
            return
        }
        if (!user.isPasswordValid(password)) {
            res.statusCode = 401
            res.json({error: `Please confirm your email.`})
            return
        }
        res.json({token: user.getToken()})
    }).catch(internalError(res))
})

router.get('/email_confirmation', (req, res) => {
    let {email, token} = req.query
    UserModel.findOne({email}, (user) => {
        if (!user) {
            res.statusCode = 404
            res.json({error: `No user found with this email.`})
            return
        }

        if (!user.confirmEmail(token)){
            res.statusCode = 400
            res.json({error: `Your confirmation token doesn't match.`})
            return
        }

        user.save().catch(internalError(res, 'An internal error ocurred trying to confirm your email'))
    }).catch(internalError(res))
})

router.post('/', (req, res) => {
    let {username, email, password, password_confirmation} = req.body
    let data = {username, email, password, password_confirmation}
    let user = new UserValidator(data, new UserModel(data))
    user.create().then(() => {
        res.json({message: 'User Successfully Created, a email Confirmation was sent.'})
    }).catch((error) => {
        res.statusCode = 400
        res.json({error})
    }) 
})

module.exports = router