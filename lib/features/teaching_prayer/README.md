# 🕌 Teaching Prayer Feature

ميزة **تعليم الصلاة** تُقدّم للمستخدم محتوى إرشادياً منظماً لتعلّم الصلاة، مقسماً إلى أقسام وموضوعات تفصيلية مع إمكانية المشاركة.

## 🚀 المميزات الرئيسية
- عرض أقسام تعليمية مرتبة بـ Animated Sliver List.
- توسيع/طي كل قسم لعرض الموضوعات.
- مشاركة أي موضوع كصورة.

## 🏗 الهيكل المعماري

```
teaching_prayer/
├── data/
│   ├── constants/    ← TeachingPrayerKeys
│   ├── datasources/  ← TeachingPrayerLocalDataSource (JSON asset)
│   ├── models/       ← TeachingPrayerSection, TeachingPrayerTopic
│   └── repositories/ ← ITeachingPrayerRepository + TeachingPrayerRepository
├── presentation/
│   ├── controller/ ← TeachingPrayerCubit + TeachingPrayerState (Sealed, part of)
│   ├── views/      ← TeachingPrayerView
│   └── widgets/
│       ├── teaching_section_card.dart
│       ├── teaching_topic_card.dart
│       └── share_card/ ← TeachingTopicShareCard
└── utils/
    └── teaching_content_parser.dart
```

## 📦 الـ State (Sealed Classes — Manual)
```dart
abstract class TeachingPrayerState
  ├── TeachingPrayerInitial
  ├── TeachingPrayerLoading
  ├── TeachingPrayerLoaded { sections: List<TeachingPrayerSection> }
  └── TeachingPrayerError  { message }
```

## ⚙️ الـ DI
| الكلاس | النوع | السبب |
|---|---|---|
| `ITeachingPrayerRepository` | `LazySingleton` | يحمل cache البيانات |
| `TeachingPrayerCubit` | `Factory` + BlocProvider | يُنشأ ويُطلق `loadSections()` في `create` |

## 📝 ملاحظات
- `BlocProvider.create` يستدعي `loadSections()` مباشرةً — وهو النمط الصحيح لتجنب استدعاء `setState` أثناء `build`.
- `TeachingContentParser` في `utils/` مسؤول عن تحويل JSON الخام لـ Models منظمة.
