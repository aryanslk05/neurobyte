const mongoose = require('mongoose');

const quizSchema = new mongoose.Schema(
  {
    subTopic: {
      type: String,
      enum: ['Arrays', 'Stack'],
      required: true
    },
    afterVideoNumber: {
      type: Number,
      enum: [5, 9],
      required: true
    },
    question: {
      type: String,
      required: true
    },
    options: {
      type: [String],
      validate: [arr => arr.length === 4, 'Exactly 4 options required']
    },
    correctAnswerIndex: {
      type: Number,
      min: 0,
      max: 3,
      required: true
    },
    explanation: {
      type: String,
      default: ''
    }
  },
  { timestamps: { createdAt: 'createdAt', updatedAt: 'updatedAt' } }
);

quizSchema.index({ subTopic: 1, afterVideoNumber: 1 }, { unique: true });

module.exports = mongoose.model('Quiz', quizSchema);

