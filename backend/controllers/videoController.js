const Video = require('../models/Video');
const Quiz = require('../models/Quiz');
const { buildResponse } = require('../utils/apiResponse');

const getVideosBySubTopic = async (req, res) => {
  try {
    const { subTopic } = req.params;

    const normalized = subTopic.toLowerCase();
    const allowed = ['arrays', 'stack'];
    if (!allowed.includes(normalized)) {
      return res
        .status(400)
        .json(buildResponse({ success: false, message: 'Invalid subTopic' }));
    }

    const subTopicLabel = normalized === 'arrays' ? 'Arrays' : 'Stack';

    const videos = await Video.find({ subTopic: subTopicLabel })
      .sort({ orderNumber: 1 })
      .limit(10)
      .lean();

    const quizzes = await Quiz.find({ subTopic: subTopicLabel }).lean();

    const quizMap = {};
    quizzes.forEach(q => {
      quizMap[q.afterVideoNumber] = q;
    });

    const timeline = [];
    videos.forEach(video => {
      timeline.push({ type: 'video', video });
      if (quizMap[video.orderNumber]) {
        timeline.push({ type: 'quiz', quiz: quizMap[video.orderNumber] });
      }
    });

    return res
      .status(200)
      .json(buildResponse({ message: 'Videos fetched', data: { timeline } }));
  } catch (error) {
    return res
      .status(500)
      .json(buildResponse({ success: false, message: error.message || 'Server Error' }));
  }
};

module.exports = { getVideosBySubTopic };

