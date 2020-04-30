const express = require('express');
const router = express.Router();

router.use('users/', require('./users.js'))
router.use('services/', require('./services.js'))

module.exports = router