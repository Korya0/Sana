# 🌟 Splash Feature

ميزة **شاشة التحميل** تُعالج انتقال المستخدم من بداية التطبيق إلى الصفحة الرئيسية، مع ضمان حصول التطبيق على موقع المستخدم قبل الدخول.

## 🚀 المميزات الرئيسية
- عرض شعار التطبيق مع انيميشن Fade-In.
- تفويض التحقق من الموقع لـ `LocationGuard`.
- الانتقال التلقائي للصفحة الرئيسية عند اكتمال التحميل.
- إغلاق التطبيق (`SystemNavigator.pop`) إذا رفض المستخدم الموقع.

## 🏗 الهيكل المعماري

```
splash/
└── presentation/
    ├── routes/  ← SplashRoutes
    ├── views/   ← SplashView + _NavigateToHome (private Widget)
    └── widgets/ ← SplashLogoAndName
```

> **ملاحظة:** لا يوجد Data Layer أو Cubit — الـ Splash تعتمد على `LocationCubit` المُحقون من الخارج.

## 🔄 تدفق العمل

```
SplashView
  → LocationGuard (showCancelButton: false, onClose: SystemNavigator.pop)
    → LocationCubit.checkLocationStatus()
      ├── [موقع مخزن] → Success فوراً + تحديث صامت في الخلفية
      └── [لا موقع]   → enforceLocation() → Dialogs حتى النجاح
    → _NavigateToHome (عند Success)
      → context.goNamed(AppRoutes.home)
```

## 📝 ملاحظات
- `SplashView` لا تحتوي على أي منطق — تُفوّض كل شيء.
- `_NavigateToHome` كـ private StatefulWidget لضمان استدعاء `goNamed` مرة واحدة عبر `initState`.
