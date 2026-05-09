# StudyByte - Short-form DSA Microlearning App

## Backend (Node.js + Express)

1. Install dependencies:
   - `cd backend`
   - `npm install`

2. Environment variables:
   - Copy `.env.example` to `.env` in the `backend` folder.
   - Fill in:
     - `MONGO_URI`
     - `JWT_SECRET`
     - `JWT_EXPIRES_IN`
     - `CLOUDINARY_CLOUD_NAME`
     - `CLOUDINARY_API_KEY`
     - `CLOUDINARY_API_SECRET`
     - `CLIENT_ORIGIN`

3. Run backend:
   - Development: `npm run dev`
   - Production: `npm start`

4. MongoDB Atlas:
   - Create a cluster and database `studybyte`
   - Whitelist your IP and create a database user

5. Cloudinary:
   - Upload short-form DSA videos
   - Store video URLs in MongoDB

---

## Frontend (Flutter)

1. Requirements:
   - Flutter SDK 3.x+
   - Android Studio / VS Code

2. Install dependencies:
   - `cd frontend`
   - `flutter pub get`

3. Configure backend URL:
   - Open `lib/core/network/api_client.dart`
   - Set `baseUrl`

4. Run app:
   - `flutter run`

---

## Features

- AI-powered educational reel system
- DSA microlearning
- Interactive quizzes
- Save & like videos
- JWT authentication
- Dark/light theme
- Progress tracking
- Adaptive learning structure
- Future NeuroBoard integrations

---

## Tech Stack

### Backend
- Node.js
- Express.js
- MongoDB
- JWT Authentication
- Cloudinary

### Frontend
- Flutter
- Provider State Management
- Video Player
- Secure Storage

---

## Vision

StudyByte aims to make technical education engaging through short-form AI-powered educational content combined with adaptive learning systems and future NeuroBoard ecosystem integrations.