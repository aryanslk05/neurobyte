const mongoose = require('mongoose');

const userSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true
    },
    email: {
      type: String,
      required: true,
      unique: true,
      lowercase: true,
      trim: true
    },
    password: {
      type: String,
      required: true,
      minlength: 6
    },
    semester: {
      type: String,
      default: ''
    },
    stream: {
      type: String,
      default: ''
    },
    avatar: {
      type: String,
      default: '📚'
    },
    savedVideos: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Video'
      }
    ],
    likedVideos: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Video'
      }
    ],
    watchedVideos: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Video'
      }
    ]
  },
  { timestamps: { createdAt: 'createdAt', updatedAt: 'updatedAt' } }
);

module.exports = mongoose.model('User', userSchema);

