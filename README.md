# سَـنَـا | Sana

<div align="center">

**تطبيق إسلامي شامل لمساعدة المسلمين في أداء عباداتهم اليومية**

[![Flutter](https://img.shields.io/badge/Flutter-3.38.4-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.10.3-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

[العربية](#العربية) • [English](#english)

</div>

---

## العربية

### 📱 نظرة عامة

**سَـنَـا** هو تطبيق إسلامي شامل مصمم بعناية لمساعدة المسلمين في أداء عباداتهم اليومية. التطبيق يجمع بين التصميم العصري والوظائف الشاملة لتوفير تجربة مستخدم مميزة.

### ✨ الميزات الرئيسية

#### 🕌 أوقات الصلاة
- حساب دقيق لأوقات الصلاة بناءً على موقعك الجغرافي
- دعم طرق حساب متعددة (أم القرى، الهيئة المصرية، إسنا، وغيرها)
- إشعارات تنبيه قبل وقت الصلاة
- عرض الوقت المتبقي للصلاة القادمة
- التقويم الهجري والميلادي

#### 🧭 القبلة
- بوصلة دقيقة لتحديد اتجاه القبلة
- دعم جميع الأجهزة المزودة بمستشعر المغناطيسية
- واجهة سهلة الاستخدام

#### 📿 الأذكار
- مكتبة شاملة من الأذكار اليومية
- أذكار الصباح والمساء
- أذكار النوم والاستيقاظ
- أذكار الصلاة والطعام
- إمكانية إضافة أذكار مخصصة
- عداد تلقائي للتسبيح
- مشاركة الأذكار كصور

#### 🤲 أسماء الله الحسنى
- عرض الأسماء الحسنى الـ99
- شرح معنى كل اسم
- إمكانية المشاركة كصور جميلة

#### 📖 تعليم الصلاة
- دليل شامل لتعليم الصلاة
- شرح مفصل لكل خطوة
- مناسب للمبتدئين

#### 🌙 الصلاة على النبي
- تذكير دوري للصلاة على النبي ﷺ
- إعدادات قابلة للتخصيص
- إشعارات في أوقات محددة

#### 📚 القرآن الكريم (قريباً)
- قراءة القرآن الكريم
- الاستماع للتلاوات
- ميزة الحفظ

### 🎨 التصميم

- واجهة مستخدم عصرية وجذابة
- دعم الوضع الداكن
- تصميم متجاوب يناسب جميع أحجام الشاشات
- خط Cairo للعربية وUthman Taha للقرآن
- رسوم متحركة سلسة

### 🛠️ التقنيات المستخدمة

- **Framework**: Flutter 3.38.4
- **Language**: Dart 3.10.3
- **State Management**: Bloc/Cubit
- **Dependency Injection**: GetIt
- **Local Storage**: SharedPreferences
- **Backend**: Firebase (Analytics, Firestore)
- **Navigation**: GoRouter
- **Notifications**: Flutter Local Notifications + WorkManager

### 📦 المكتبات الرئيسية

```yaml
dependencies:
  flutter_bloc: ^9.1.1
  get_it: ^9.1.0
  go_router: ^17.0.0
  adhan: ^2.0.0+1
  hijri: ^3.0.0
  geolocator: ^14.0.2
  flutter_compass: ^0.8.0
  flutter_local_notifications: ^19.5.0
  workmanager: ^0.9.0+3
  firebase_core: ^4.2.1
  cloud_firestore: ^6.1.0
  quran_library: ^2.3.1
```

### 🚀 البدء

#### المتطلبات
- Flutter SDK 3.38.4 أو أحدث
- Dart SDK 3.10.3 أو أحدث
- Android SDK (للأندرويد)
- Xcode (لـ iOS)

#### التثبيت

1. استنساخ المشروع:
```bash
git clone https://github.com/Korya25/Muslim.git
cd muslim_app
```

2. تثبيت الحزم:
```bash
flutter pub get
```

3. إعداد Firebase:
   - أنشئ مشروع Firebase جديد
   - أضف ملفات التكوين:
     - `google-services.json` للأندرويد
     - `GoogleService-Info.plist` لـ iOS
   - قم بتشغيل:
   ```bash
   flutterfire configure
   ```

4. تشغيل التطبيق:
```bash
flutter run
```

### 📱 بناء التطبيق

#### Android (APK)
```bash
flutter build apk --release
```

#### Android (App Bundle)
```bash
flutter build appbundle --release
```

#### iOS
```bash
flutter build ios --release
```

### 🔐 الخصوصية والأمان

- جميع البيانات الشخصية مخزنة محلياً على الجهاز
- لا نجمع أو نشارك بيانات المستخدمين
- استخدام محدود لـ Firebase Analytics (بيانات مجهولة)
- اقرأ [سياسة الخصوصية](PRIVACY_POLICY.md) للمزيد

### 📄 الترخيص

هذا المشروع مرخص تحت رخصة MIT - انظر ملف [LICENSE](LICENSE) للتفاصيل.

### 🤝 المساهمة

نرحب بالمساهمات! إذا كنت تريد المساهمة:

1. Fork المشروع
2. أنشئ فرع للميزة (`git checkout -b feature/AmazingFeature`)
3. Commit التغييرات (`git commit -m 'Add some AmazingFeature'`)
4. Push للفرع (`git push origin feature/AmazingFeature`)
5. افتح Pull Request

### 📞 التواصل

- **المطور**: Korya25
- **GitHub**: [@Korya25](https://github.com/Korya25)
- **المشروع**: [Muslim App](https://github.com/Korya25/Muslim)

### 🙏 شكر وتقدير

- جميع المساهمين في المشروع
- مجتمع Flutter العربي
- مكتبة Adhan لحساب أوقات الصلاة
- مكتبة Quran Library للقرآن الكريم

---

## English

### 📱 Overview

**Sana** is a comprehensive Islamic application carefully designed to help Muslims perform their daily worship. The app combines modern design with comprehensive functionality to provide a distinguished user experience.

### ✨ Key Features

#### 🕌 Prayer Times
- Accurate prayer time calculation based on your location
- Support for multiple calculation methods (Umm al-Qura, Egyptian Authority, ISNA, etc.)
- Prayer time notifications
- Display time remaining until next prayer
- Hijri and Gregorian calendar

#### 🧭 Qibla
- Accurate compass to determine Qibla direction
- Support for all devices with magnetic sensor
- Easy-to-use interface

#### 📿 Azkar (Remembrances)
- Comprehensive library of daily Azkar
- Morning and evening Azkar
- Sleep and wake-up Azkar
- Prayer and meal Azkar
- Ability to add custom Azkar
- Automatic Tasbih counter
- Share Azkar as images

#### 🤲 99 Names of Allah
- Display of the 99 Beautiful Names
- Explanation of each name's meaning
- Share as beautiful images

#### 📖 Prayer Guide
- Comprehensive guide to learning prayer
- Detailed explanation of each step
- Suitable for beginners

#### 🌙 Salawat on the Prophet
- Periodic reminder for Salawat
- Customizable settings
- Notifications at specific times

#### 📚 Holy Quran (Coming Soon)
- Read the Holy Quran
- Listen to recitations
- Memorization feature

### 🎨 Design

- Modern and attractive UI
- Dark mode support
- Responsive design for all screen sizes
- Cairo font for Arabic and Uthman Taha for Quran
- Smooth animations

### 🛠️ Technologies Used

- **Framework**: Flutter 3.38.4
- **Language**: Dart 3.10.3
- **State Management**: Bloc/Cubit
- **Dependency Injection**: GetIt
- **Local Storage**: SharedPreferences
- **Backend**: Firebase (Analytics, Firestore)
- **Navigation**: GoRouter
- **Notifications**: Flutter Local Notifications + WorkManager

### 🚀 Getting Started

#### Requirements
- Flutter SDK 3.38.4 or newer
- Dart SDK 3.10.3 or newer
- Android SDK (for Android)
- Xcode (for iOS)

#### Installation

1. Clone the project:
```bash
git clone https://github.com/Korya25/Muslim.git
cd muslim_app
```

2. Install packages:
```bash
flutter pub get
```

3. Setup Firebase:
   - Create a new Firebase project
   - Add configuration files:
     - `google-services.json` for Android
     - `GoogleService-Info.plist` for iOS
   - Run:
   ```bash
   flutterfire configure
   ```

4. Run the app:
```bash
flutter run
```

### 📱 Building the App

#### Android (APK)
```bash
flutter build apk --release
```

#### Android (App Bundle)
```bash
flutter build appbundle --release
```

#### iOS
```bash
flutter build ios --release
```

### 🔐 Privacy & Security

- All personal data stored locally on device
- We don't collect or share user data
- Limited use of Firebase Analytics (anonymous data)
- Read [Privacy Policy](PRIVACY_POLICY.md) for more

### 📄 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file for details.

### 🤝 Contributing

Contributions are welcome! If you want to contribute:

1. Fork the project
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### 📞 Contact

- **Developer**: Korya25
- **GitHub**: [@Korya25](https://github.com/Korya25)
- **Project**: [Muslim App](https://github.com/Korya25/Muslim)

### 🙏 Acknowledgments

- All project contributors
- Arabic Flutter community
- Adhan library for prayer time calculations
- Quran Library for Quran features

---

<div align="center">

**جُعِلَ في خدمة الإسلام والمسلمين**  
**Made to serve Islam and Muslims**

⭐ إذا أعجبك المشروع، لا تنسَ إعطائه نجمة  
⭐ If you like the project, don't forget to give it a star

</div>#   S a n a  
 #   S a n a  
 #   S a n a  
 