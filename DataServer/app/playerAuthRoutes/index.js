const express = require('express');
const router = express.Router();

router.use('/users', require('./users.js'))
router.get('/', (req, res) => res.json({message: `Everything is fine.`}))

module.exports = router