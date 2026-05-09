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
     - `CLIENT_ORIGIN` (e.g. `http://localhost:3000` or your emulator host)
3. Run backend:
   - Development: `npm run dev`
   - Production: `npm start`
4. MongoDB Atlas:
   - Create a cluster and database `studybyte`.
   - Whitelist your IP and create a database user.
5. Cloudinary:
   - Create a free account at `https://cloudinary.com`.
   - Get cloud name, API key, and API secret from the dashboard and place in `.env`.
   - Upload short-form DSA videos for:
     - Arrays (10 videos)
     - Stack (10 videos)
   - Copy the streaming-optimized URLs.
   - Create `Video` documents in MongoDB with:
     - `title`, `topic: "DSA"`, `subTopic: "Arrays" | "Stack"`, `videoUrl`, `thumbnailUrl`, `orderNumber` (1-10).
   - Create `Quiz` documents with:
     - `subTopic`, `afterVideoNumber` (5 or 9), `question`, `options` (4), `correctAnswerIndex`, `explanation`.
     - Quizzes appear after the 5th and 9th video in each subtopic.

## Frontend (Flutter)

1. Requirements:
   - Flutter SDK 3.x+
   - Android Studio / Xcode for emulators.
2. Install dependencies:
   - `cd frontend`
   - `flutter pub get`
3. Configure backend URL:
   - Open `lib/core/network/api_client.dart`.
   - Set `baseUrl` to your backend address (for Android emulator use `http://10.0.2.2:5000`).
4. Run app:
   - `flutter run` (choose your device/emulator).
5. Login persistence:
   - JWT stored securely via `flutter_secure_storage`.

## Auth Flow

- `POST /api/auth/signup` (name, email, password).
- `POST /api/auth/login` (email, password).
- On success, JWT is returned and stored by the Flutter client.
- Protected routes include Authorization header: `Bearer <token>`.

## Core APIs

- `GET /api/videos/:subTopic`
  - `subTopic` = `arrays` or `stack`.
  - Returns mixed timeline of videos and quizzes (after 5th and 10th videos).
- `POST /api/user/save/:videoId` (toggle save).
- `POST /api/user/like/:videoId` (toggle like).
- `POST /api/user/watched/:videoId` (mark watched).
- `GET /api/user/saved` (saved videos).
- `GET /api/user/stats` (profile stats and per-subtopic progress).
- `PUT /api/user/updateProfile` (update name, semester, stream, avatar).

## Notes

- Light and dark themes are configured in `lib/core/theme`.
- Video reels implemented with `video_player` and vertical `PageView`.
- This project is structured as a production-ready MVP suitable for hackathon demos.

