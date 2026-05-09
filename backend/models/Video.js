const mongoose = require('mongoose');

const videoSchema = new mongoose.Schema(
  {
    title: {
      type: String,
      required: true,
      trim: true
    },
    topic: {
      type: String,
      enum: ['DSA'],
      default: 'DSA'
    },
    subTopic: {
      type: String,
      enum: ['Arrays', 'Stack'],
      required: true
    },
    videoUrl: {
      type: String,
      required: true
    },
    thumbnailUrl: {
      type: String,
      required: true
    },
    orderNumber: {
      type: Number,
      required: true,
      min: 1,
      max: 10
    }
  },
  { timestamps: { createdAt: 'createdAt', updatedAt: 'updatedAt' } }
);

videoSchema.index({ subTopic: 1, orderNumber: 1 }, { unique: true });

module.exports = mongoose.model('Video', videoSchema);

