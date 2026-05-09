const express = require('express');
const {
  toggleSaveVideo,
  toggleLikeVideo,
  getSavedVideos,
  updateProfile,
  markVideoWatched,
  getProfileStats
} = require('../controllers/userController');
const { protect } = require('../middleware/authMiddleware');

const router = express.Router();

router.post('/save/:videoId', protect, toggleSaveVideo);
router.post('/like/:videoId', protect, toggleLikeVideo);
router.post('/watched/:videoId', protect, markVideoWatched);
router.get('/saved', protect, getSavedVideos);
router.get('/stats', protect, getProfileStats);
router.put('/updateProfile', protect, updateProfile);

module.exports = router;

