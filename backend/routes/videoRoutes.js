const express = require('express');
const { getVideosBySubTopic } = require('../controllers/videoController');
const { protect } = require('../middleware/authMiddleware');

const router = express.Router();

router.get('/:subTopic', protect, getVideosBySubTopic);

module.exports = router;

