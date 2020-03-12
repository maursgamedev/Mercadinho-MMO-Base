

module.exports = (app) => {
    require('./users.js')(app)
    require('./services.js')(app)
}