const bcrypt = require('bcryptjs');
const User = require('../models/User');
const generateToken = require('../utils/generateToken');
const { buildResponse } = require('../utils/apiResponse');

const signup = async (req, res) => {
  try {
    const { name, email, password, semester, stream, avatar } = req.body;

    if (!name || !email || !password) {
      return res
        .status(400)
        .json(buildResponse({ success: false, message: 'Name, email and password are required' }));
    }

    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res
        .status(409)
        .json(buildResponse({ success: false, message: 'User already exists with this email' }));
    }

    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    const user = await User.create({
      name,
      email,
      password: hashedPassword,
      semester,
      stream,
      avatar
    });

    const token = generateToken(user._id);

    return res.status(201).json(
      buildResponse({
        message: 'Signup successful',
        data: {
          token,
          user: {
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
        }
      })
    );
  } catch (error) {
    return res
      .status(500)
      .json(buildResponse({ success: false, message: error.message || 'Server Error' }));
  }
};

const login = async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res
        .status(400)
        .json(buildResponse({ success: false, message: 'Email and password are required' }));
    }

    const user = await User.findOne({ email });
    if (!user) {
      return res
        .status(401)
        .json(buildResponse({ success: false, message: 'Invalid credentials' }));
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res
        .status(401)
        .json(buildResponse({ success: false, message: 'Invalid credentials' }));
    }

    const token = generateToken(user._id);

    return res.status(200).json(
      buildResponse({
        message: 'Login successful',
        data: {
          token,
          user: {
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
        }
      })
    );
  } catch (error) {
    return res
      .status(500)
      .json(buildResponse({ success: false, message: error.message || 'Server Error' }));
  }
};

const logout = async (req, res) => {
  return res
    .status(200)
    .json(buildResponse({ message: 'Logged out successfully', data: null }));
};

module.exports = { signup, login, logout };

