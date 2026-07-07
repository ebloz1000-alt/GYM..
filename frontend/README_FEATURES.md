# GymFlow Pro - Premium Gym Booking Web App

A modern, responsive gym booking and fitness tracking web application built with Flutter, combining features from leading fitness platforms.

## 🌟 Features Inspired By

### **Nike Training Club** → Visual Design & Onboarding
- Beautiful, minimalist UI with premium animations
- Smooth workout transitions and professional design
- Intuitive onboarding experience

### **Strava** → Community & Challenges
- Social leaderboard system
- Community challenges with rewards
- Member engagement and streaks
- Progress tracking with badges

### **Fitbod** → AI Workout Recommendations
- Personalized AI-powered workout plans
- Smart exercise recommendations based on form
- Adaptive training intensity
- Workout history analysis

### **MyFitnessPal** → Nutrition Tracking
- Daily calorie and macro tracking
- Meal logging with detailed breakdowns
- Nutritional insights and analysis
- Daily summaries and progress tracking

### **WhatsApp/Telegram** → Member-to-Member & Trainer Chat
- Real-time messaging between members
- Trainer consultation chat
- Group conversations
- Online status indicators

### **Zoom** → Virtual Training Classes
- Live fitness class streaming
- Upcoming class schedule
- Real-time participant tracking
- Class reservations

### **Apple Fitness+** → Premium Animations & Workout Experience
- Premium workout library
- High-quality video content
- Exclusive advanced exercises
- Professional trainer library

## 📱 Responsive Design

### Breakpoints
- **Mobile**: < 600px (bottom navigation)
- **Tablet**: 600px - 900px (side drawer)
- **Desktop**: ≥ 900px (sidebar navigation)

### Features
- Adaptive layouts for all screen sizes
- Touch-friendly interfaces on mobile
- Full-featured desktop experience
- Optimized grid layouts

## 🎨 Dark Mode & Light Mode

### Light Mode
- **Primary Color**: Vibrant Teal (#00BFB3) - Nike-inspired
- Clean, bright interface perfect for daytime use
- High contrast for accessibility

### Dark Mode
- **Primary Color**: Bright Cyan (#4FD8E8)
- Easy on the eyes for evening use
- Reduced brightness for nighttime workouts

### Brand Colors
- **Fitbod Purple**: #7C3AED - For AI features
- **Strava Pink**: #FF6B6B - For community features
- **Apple Gold**: #FFD700 - For premium features

## 📊 Core Modules

### 1. **Dashboard (Home)**
- Welcome greeting with personalized stats
- Today's recommended workout
- Quick stats: Streak, Workouts, Calories, Level
- Quick action buttons
- Real-time progress tracking

### 2. **Workouts**
- Browse premium workout library
- Difficulty levels: Beginner, Intermediate, Advanced
- Time-based filtering
- Calorie burn estimates
- One-click workout launch

### 3. **Community**
- Live leaderboard with top performers
- Monthly challenges with rewards
- Progress bars and participation tracking
- Badge system
- Social engagement metrics

### 4. **AI Recommendations**
- Personalized workout suggestions
- AI confidence scores
- Form improvement tracking
- Pattern-based recommendations
- Tailored training intensity

### 5. **Nutrition Tracking**
- Daily calorie counter
- Macro tracking (Protein, Carbs, Fat)
- Meal logging with visual breakdowns
- Daily summaries
- Nutritional insights

### 6. **Virtual Classes**
- Live class listings
- Upcoming class schedule
- Instructor information
- Participant counts
- Real-time class reservations

### 7. **Chat System**
- Direct messaging with trainers
- Member-to-member chat
- Group conversations
- Online status indicators
- Message history

### 8. **Premium Membership**
- Subscription plans (Monthly, 3-Month, Yearly)
- 40% yearly savings
- 7-day free trial
- Premium features showcase
- Exclusive workout library

## 🛠️ Technology Stack

- **Framework**: Flutter 3.12+
- **UI**: Material 3 Design
- **State Management**: ChangeNotifier
- **Architecture**: Feature-based modular structure

## 📁 Project Structure

```
lib/
├── core/
│   ├── routes/
│   │   └── app_router.dart
│   ├── theme/
│   │   └── app_theme.dart
│   ├── utils/
│   │   └── responsive_helper.dart
│   ├── constants/
│   └── widgets/
├── features/
│   ├── dashboard/
│   │   └── dashboard_page.dart
│   ├── workouts/
│   │   └── workouts_page.dart
│   ├── community/
│   │   └── community_page.dart
│   ├── ai_recommendations/
│   │   └── ai_page.dart
│   ├── nutrition/
│   │   └── nutrition_page.dart
│   ├── chat/
│   │   └── chat_page.dart
│   ├── virtual_classes/
│   │   └── virtual_classes_page.dart
│   ├── premium/
│   │   └── premium_page.dart
│   └── [other existing features]
├── providers_or_bloc/
│   └── app_state.dart
├── models/
│   └── app_models.dart
└── main.dart
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.12 or higher
- Dart 3.1 or higher

### Installation

```bash
# Clone the repository
cd frontend

# Get dependencies
flutter pub get

# Run the app
flutter run -d chrome  # For web
```

## 🎯 Theme System

The app features Material 3 theming with:
- Dynamic color schemes
- Smooth transitions between light/dark modes
- Consistent padding and spacing
- Rounded corners (12-16px for modern look)
- Elevated card designs for depth

## ♿ Accessibility

- High contrast colors for readability
- Large touch targets (minimum 48x48 dp)
- Clear typography hierarchy
- Semantic labels for all interactive elements
- Color-blind friendly palette

## 📈 Future Enhancements

- Wearable device integration (Apple Watch, Fitbit)
- Social media sharing integration
- Advanced analytics dashboard
- Payment gateway integration
- Email notifications
- Video streaming for classes
- Offline mode support
- Multi-language support

## 📄 License

This project is part of the GYM Booking System. All rights reserved.

## 🤝 Contributing

For contributions, please follow the project's code structure and design guidelines.

## 📞 Support

For issues or questions, please refer to the help section within the app or contact support.

---

**GymFlow Pro** - Your Ultimate Fitness Companion 💪
