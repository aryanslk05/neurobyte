const mongoose = require('mongoose');
const User = require('../models/User');
const Video = require('../models/Video');
const { buildResponse } = require('../utils/apiResponse');

const toggleSaveVideo = async (req, res) => {
  try {
    const { videoId } = req.params;

    if (!mongoose.Types.ObjectId.isValid(videoId)) {
      return res
        .status(400)
        .json(buildResponse({ success: false, message: 'Invalid videoId' }));
    }

    const video = await Video.findById(videoId);
    if (!video) {
      return res
        .status(404)
        .json(buildResponse({ success: false, message: 'Video not found' }));
    }

    const user = await User.findById(req.user.id);
    const index = user.savedVideos.findIndex(
      v => v.toString() === videoId.toString()
    );

    if (index > -1) {
      user.savedVideos.splice(index, 1);
    } else {
      user.savedVideos.push(videoId);
    }

    await user.save();

    return res.status(200).json(
      buildResponse({
        message: 'Saved videos updated',
        data: { savedVideos: user.savedVideos }
      })
    );
  } catch (error) {
    return res
      .status(500)
      .json(buildResponse({ success: false, message: error.message || 'Server Error' }));
  }
};

const toggleLikeVideo = async (req, res) => {
  try {
    const { videoId } = req.params;

    if (!mongoose.Types.ObjectId.isValid(videoId)) {
      return res
        .status(400)
        .json(buildResponse({ success: false, message: 'Invalid videoId' }));
    }

    const video = await Video.findById(videoId);
    if (!video) {
      return res
        .status(404)
        .json(buildResponse({ success: false, message: 'Video not found' }));
    }

    const user = await User.findById(req.user.id);
    const index = user.likedVideos.findIndex(
      v => v.toString() === videoId.toString()
    );

    if (index > -1) {
      user.likedVideos.splice(index, 1);
    } else {
      user.likedVideos.push(videoId);
    }

    await user.save();

    return res.status(200).json(
      buildResponse({
        message: 'Liked videos updated',
        data: { likedVideos: user.likedVideos }
      })
    );
  } catch (error) {
    return res
      .status(500)
      .json(buildResponse({ success: false, message: error.message || 'Server Error' }));
  }
};

const getSavedVideos = async (req, res) => {
  try {
    const user = await User.findById(req.user.id).populate('savedVideos');
    return res
      .status(200)
      .json(
        buildResponse({ message: 'Saved videos fetched', data: { videos: user.savedVideos } })
      );
  } catch (error) {
    return res
      .status(500)
      .json(buildResponse({ success: false, message: error.message || 'Server Error' }));
  }
};

const updateProfile = async (req, res) => {
  try {
    const { name, semester, stream, avatar } = req.body;

    const user = await User.findById(req.user.id);
    if (!user) {
      return res
        .status(404)
        .json(buildResponse({ success: false, message: 'User not found' }));
    }

    if (name !== undefined) user.name = name;
    if (semester !== undefined) user.semester = semester;
    if (stream !== undefined) user.stream = stream;
    if (avatar !== undefined) user.avatar = avatar;

    await user.save();

    return res.status(200).json(
      buildResponse({
        message: 'Profile updated',
        data: {
          id: user._id,
          name: user.name,
          email: user.email,
          semester: user.semester,
          stream: user.stream,
          avatar: user.avatar,
          savedVideos: user.savedVideos,
          likedVideos: user.likedVideos,
          watchedVideos: user.watchedVideos,
          createdAt: user.createdAt
        }
      })
    );
  } catch (error) {
    return res
      .status(500)
      .json(buildResponse({ success: false, message: error.message || 'Server Error' }));
  }
};

const markVideoWatched = async (req, res) => {
  try {
    const { videoId } = req.params;

    if (!mongoose.Types.ObjectId.isValid(videoId)) {
      return res
        .status(400)
        .json(buildResponse({ success: false, message: 'Invalid videoId' }));
    }

    const video = await Video.findById(videoId);
    if (!video) {
      return res
        .status(404)
        .json(buildResponse({ success: false, message: 'Video not found' }));
    }

    const user = await User.findById(req.user.id);
    const exists = user.watchedVideos.some(v => v.toString() === videoId.toString());
    if (!exists) {
      user.watchedVideos.push(videoId);
      await user.save();
    }

    return res.status(200).json(
      buildResponse({
        message: 'Watched video marked',
        data: { watchedVideos: user.watchedVideos }
      })
    );
  } catch (error) {
    return res
      .status(500)
      .json(buildResponse({ success: false, message: error.message || 'Server Error' }));
  }
};

const getProfileStats = async (req, res) => {
  try {
    const user = await User.findById(req.user.id)
      .populate('watchedVideos')
      .populate('savedVideos')
      .populate('likedVideos');

    const stats = {
      totalWatched: user.watchedVideos.length,
      totalSaved: user.savedVideos.length,
      totalLiked: user.likedVideos.length
    };

    const subTopicProgress = {};
    const allVideos = [...user.watchedVideos];
    allVideos.forEach(v => {
      if (!subTopicProgress[v.subTopic]) {
        subTopicProgress[v.subTopic] = { watched: 0, total: 10 };
      }
      subTopicProgress[v.subTopic].watched += 1;
    });

    return res.status(200).json(
      buildResponse({
        message: 'Profile stats fetched',
        data: {
          user: {
            id: user._id,
            name: user.name,
            email: user.email,
            semester: user.semester,
            stream: user.stream,
            avatar: user.avatar,
            savedVideos: user.savedVideos,
            likedVideos: user.likedVideos
          },
          stats,
          subTopicProgress
        }
      })
    );
  } catch (error) {
    return res
      .status(500)
      .json(buildResponse({ success: false, message: error.message || 'Server Error' }));
  }
};

module.exports = {
  toggleSaveVideo,
  toggleLikeVideo,
  getSavedVideos,
  updateProfile,
  markVideoWatched,
  getProfileStats
};

