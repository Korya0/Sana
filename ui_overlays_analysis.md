# تحليل شامل لواجهات التفاعل المنبثقة (UI Overlays)

> **تاريخ الإنشاء:** 13 يوليو 2026  
> **النطاق:** جميع ملفات `lib/`  
> **الهدف:** جرد وتوثيق 100% من استخدامات الـ Toasts و SnackBars و Dialogs و Bottom Sheets

---

## 📋 ملخص التنفيذ

| النوع | العدد الإجمالي | ملفات الاستخدام |
|-------|:--------------:|-----------------|
| **Toasts** | 20+ استدعاء | 13 ملفاً |
| **SnackBars** | 2 استدعاء | 2 ملفاً |
| **Dialogs** | 11 استدعاء | 9 ملفات + 4 مكوّنات أساسية |
| **Bottom Sheets** | 10+ استدعاء | 8 ملفات + مكوّن أساسي |

---

# 1️⃣ Toasts (الإشعارات المنبثقة)

**المكتبة المستخدمة:** `toastification` عبر الغلاف المخصص `AppToast`  
**الأنواع:** `AppToastType.success` ✅, `AppToastType.error` ❌, `AppToastType.warning` ⚠️, `AppToastType.info` ℹ️  
**الوظيفة الأساسية:** `AppToast.show(context, message, {type, position, seconds})`

---

### 1.1 `app_clipboard.dart` — `AppClipboard.copy`
| الحقل | القيمة |
|-------|--------|
| **المسار** | `lib/core/services/sharing/presentation/utils/app_clipboard.dart` |
| **الرسالة** | `AppStrings.copiedToClipboard` (عند النجاح) / `AppStrings.copyError` (عند الفشل) |
| **الهدف** | يعرض إشعار نجاح بعد نسخ النص إلى الحافظة، أو إشعار خطأ إذا فشلت عملية النسخ |

---

### 1.2 `app_share.dart` — `AppShare.shareWidgetAsImage`
| الحقل | القيمة |
|-------|--------|
| **المسار** | `lib/core/services/sharing/presentation/utils/app_share.dart` |
| **الرسالة** | `AppStrings.sharingError` أو رسالة الفشل من `Failure` |
| **الهدف** | يعرض إشعارات خطأ في 4 مسارات مختلفة: (1) فشل التقاط الويدجت كصورة، (2) فشل المشاركة من الخدمة، (3) فشل عام من الخدمة، (4) استثناء غير متوقع. يعرض `AppToastType.error` في جميع الحالات |

---

### 1.3 `favorite_toast.dart` — `FavoriteToast.showFavoriteToast`
| الحقل | القيمة |
|-------|--------|
| **المسار** | `lib/core/common/overlays/toast/favorite_toast.dart` |
| **الرسالة** | `AppStrings.addedToFavorites` أو `AppStrings.removedFromFavorites` |
| **الهدف** | (مكوّن أصلي) يعرض إشعار نجاح عند إضافة عنصر للمفضلة (`AppToastType.success`) أو إشعار معلومات عند إزالته (`AppToastType.info`). يُستخدم عبر التطبيق بالكامل عند تبديل حالة المفضلة |

---

### 1.4 `admin_feedback_actions.dart` — `AdminFeedbackActions._copyFeedbackToClipboard`
| الحقل | القيمة |
|-------|--------|
| **المسار** | `lib/features/developer_dashboard/presentation/widgets/admin_feedback_actions.dart` |
| **الرسالة** | `'تم النسخ بنجاح'` |
| **الهدف** | يعرض إشعار نجاح للمسؤول بعد نسخ نص الملاحظة (Feedback) إلى الحافظة من لوحة التحكم |

---

### 1.5 `developer_dashboard_view.dart` — `DeveloperDashboardView.build`
| الحقل | القيمة |
|-------|--------|
| **المسار** | `lib/features/developer_dashboard/presentation/views/developer_dashboard_view.dart` |
| **الرسالة** | `state.actionMessage!` (رسالة ديناميكية من حالة الـ Dashboard) |
| **الهدف** | يستمع إلى تغييرات حالة `DashboardCubit`. يعرض إشعار خطأ (إذا `state.isError`) أو إشعار نجاح بعد تنفيذ إجراءات الإدارة مثل حذف الملاحظات |

---

### 1.6 `daily_content_card.dart` — `DailyContentCard.build (onCopyPressed)`
| الحقل | القيمة |
|-------|--------|
| **المسار** | `lib/features/daily_content/presentation/widgets/card/daily_content_card.dart` |
| **الرسالة** | `'تم النسخ بنجاح'` |
| **الهدف** | يعرض إشعار نجاح عند نسخ محتوى الحديث اليومي أو السنة اليومية إلى الحافظة |

---

### 1.7 `daily_content_base_card.dart` — `DailyContentBaseCard.build (onFavoriteToggle)`
| الحقل | القيمة |
|-------|--------|
| **المسار** | `lib/core/common/widgets/daily_content_base_card.dart` |
| **الرسالة** | ديناميكية من `FavoriteToast.showFavoriteToast` (إضافة/إزالة مفضلة) |
| **الهدف** | يعرض إشعار عند تبديل حالة المفضلة (يُستخدم لعدة أنواع من البطاقات: أحاديث، سنن، أسماء الله الحسنى) |

---

### 1.8 `daily_content_favorite_card.dart` — `DailyContentFavoriteCard.build (onDelete)`
| الحقل | القيمة |
|-------|--------|
| **المسار** | `lib/features/daily_content/presentation/widgets/card/daily_content_favorite_card.dart` |
| **الرسالة** | ديناميكية من `FavoriteToast.showFavoriteToast(context, isAdded: false)` |
| **الهدف** | يعرض إشعار عند حذف عنصر من قائمة المفضلة (إزالة من المفضلة) |

---

### 1.9 `azkar_list_view.dart` — `AzkarListView.build (BlocListener)`
| الحقل | القيمة |
|-------|--------|
| **المسار** | `lib/features/azkar/presentation/views/azkar_list_view.dart` |
| **الرسالة** | `state.message` (رسالة خطأ إعدادات القراءة) / `AppStrings.azkarCompletedMessage` |
| **الهدف** | (1) يستمع لأخطاء `ReadingSettingsCubit` ويعرضها. (2) يعرض إشعار نجاح عند إكمال جميع الأذكار، ثم يعود تلقائياً للصفحة السابقة |

---

### 1.10 `secret_pin_dialog.dart` — `SecretPinDialog._verifyPin`
| الحقل | القيمة |
|-------|--------|
| **المسار** | `lib/core/common/widgets/secret_pin_dialog.dart` |
| **الرسالة** | `AppStrings.invalidPin` (`'الرمز غير صحيح'`) |
| **الهدف** | يعرض إشعار خطأ من نوع `AppToastType.error` عند إدخال رمز PIN خاطئ للوصول للوحة تحكم المطور |

---

### 1.11 `interval_counter_widget.dart` — `IntervalCounterWidget.build`
| الحقل | القيمة |
|-------|--------|
| **المسار** | `lib/features/salat_ala_nabi/presentation/widgets/interval_counter_widget.dart` |
| **الرسالة** | (1) `AppStrings.minIntervalError` عند محاولة تقليل الفاصل لأقل من 15 دقيقة. (2) `AppStrings.maxIntervalError` عند محاولة زيادة الفاصل لأكثر من 120 دقيقة |
| **الهدف** | يعرض إشعار تحذير للمستخدم عند بلوغ الحد الأدنى/الأقصى لفاصل التذكير |

---

### 1.12 `salat_ala_nabi_view.dart` — `SalatAlaNabiView` (عدة مواقع)
| الحقل | القيمة |
|-------|--------|
| **المسار** | `lib/features/salat_ala_nabi/presentation/views/salat_ala_nabi_view.dart` |
| **الرسالة** | (1) `AppStrings.changesSavedSuccess` عند حفظ التغييرات بنجاح. (2) `AppStrings.ourFault` عند فشل الحفظ |
| **الهدف** | يعرض إشعارات نجاح أو فشل بعد حفظ إعدادات التذكير بالصلاة على النبي |

---

### 1.13 `hadith_search_share_and_favorite_buttons.dart` — `HadithSearchShareAndFavoriteButtons`
| الحقل | القيمة |
|-------|--------|
| **المسار** | `lib/features/hadith_search/presentation/widgets/hadith_search_share_and_favorite_buttons.dart` |
| **الرسالة** | (1) `AppStrings.copiedSuccessfully` عند نجاح النسخ. (2) `AppStrings.copyFailed` عند فشل النسخ (`AppToastType.error`). (3) ديناميكية من `FavoriteToast` عند تبديل المفضلة |
| **الهدف** | يعرض إشعارات نجاح/فشل لعمليات النسخ، وإشعارات المفضلة للبحث في الأحاديث |

---

### 1.14 `hadith_results_builder.dart` — `HadithSearchResultsBuilder.build`
| الحقل | القيمة |
|-------|--------|
| **المسار** | `lib/features/hadith_search/presentation/widgets/hadith_results_builder.dart` |
| **الرسالة** | `AppStrings.noResults` |
| **الهدف** | يعرض إشعار للمستخدم عند عدم وجود نتائج للبحث مع قائمة فارغة من الأحاديث (نتيجة بحث ناجحة لكنها فارغة) |

---

### 1.15 `daily_asma_ul_husna_card.dart` — `DailyAsmaUlHusnaCard.build (onCopyPressed)`
| الحقل | القيمة |
|-------|--------|
| **المسار** | `lib/features/asma_ul_husna/presentation/widgets/daily_asma_ul_husna_card.dart` |
| **الرسالة** | `'تم النسخ بنجاح'` |
| **الهدف** | يعرض إشعار نجاح عند نسخ اسم من أسماء الله الحسنى إلى الحافظة |

---

### 1.16 `home_features_category_section.dart` — `HomeFeaturesCategorySection._FeaturesLoadedSection.build`
| الحقل | القيمة |
|-------|--------|
| **المسار** | `lib/features/home/presentation/widgets/sections/home_features_category_section.dart` |
| **الرسالة** | (1) `AppStrings.comingSoon` للميزات القادمة. (2) `AppStrings.webFeatureNotSupported(item.title)` مع `AppToastType.warning` للميزات غير المدعومة على الويب |
| **الهدف** | يعرض إشعارات عند النقر على ميزات غير متاحة بعد أو ميزات مقيدة على منصة الويب |

---

### 1.17 `feedback_issue_view.dart` — `FeedbackIssueView._FeedbackIssueContent.build`
| الحقل | القيمة |
|-------|--------|
| **المسار** | `lib/features/feedback/presentation/views/feedback_issue_view.dart` |
| **الرسالة** | `state.message` (عند النجاح) / `state.error` (عند الفشل مع `AppToastType.error`) |
| **الهدف** | يستمع لحالة `FeedbackCubit`. يعرض إشعار نجاح بعد إرسال الملاحظة بنجاح ويعود للصفحة السابقة، أو إشعار خطأ في حال فشل الإرسال |

---

# 2️⃣ SnackBars (الإشعارات السفلية)

**المكتبة:** Flutter SDK (`ScaffoldMessenger.of(context).showSnackBar`)  
**ملاحظة:** التطبيق يستخدم `AppToast` كبديل أساسي، واستخدامات `SnackBar` محدودة جداً

---

### 2.1 `reminder_dialog.dart` — `ReminderDialog._save`
| الحقل | القيمة |
|-------|--------|
| **المسار** | `lib/features/azkar/presentation/widgets/reminder/reminder_dialog.dart` |
| **المحتوى** | `SnackBar(content: Text(validation.errorMessage!))` - رسالة خطأ التحقق من صحة بيانات التذكير |
| **الهدف** | يعرض رسالة خطأ في SnackBar عندما يفشل التحقق من صحة النموذج في حوار التذكير (مثل عدم اختيار أيام التكرار عند اختيار تكرار أسبوعي). هذا هو مسار fallback عندما لا يمرر التحقق |

---

### 2.2 `daily_content_favorite_card.dart` — `DailyContentFavoriteCard.build (onCopyPressed)`
| الحقل | القيمة |
|-------|--------|
| **المسار** | `lib/features/daily_content/presentation/widgets/card/daily_content_favorite_card.dart` |
| **المحتوى** | `const SnackBar(content: Text(AppStrings.copiedSuccessfully))` |
| **الهدف** | يعرض رسالة نجاح بعد نسخ المحتوى من بطاقة المفضلة (ملاحظة: الملفات الأخرى تستخدم `AppToast.show` بدلاً من ذلك، مما يشير إلى تباين في التنفيذ) |

---

# 3️⃣ Dialogs (مربعات الحوار)

**المكتبة:** Flutter SDK + مكوّنات مخصصة  
**المكوّنات الأساسية:**
- `CustomDialog` (في `custom_dialog.dart`) — واجهة حاوية قابلة للتخصيص
- `showCustomDialog()` — الدالة الأساسية لعرض الحوارات
- `CustomConfirmationDialog` (في `custom_confirmation_dialog.dart`) — حوار تأكيد
- `CustomRichContentDialog` (في `custom_rich_content_dialog.dart`) — حوار محتوى غني
- `CustomInfoDialog` (في `custom_info_dialog.dart`) — حوار معلومات/تعليمات
- `SecretPinDialog` (في `secret_pin_dialog.dart`) — حوار إدخال PIN
- `DailyContentExplanationDialog` (في `daily_content_explanation_dialog.dart`) — حوار شرح المحتوى

---

### 3.1 `SecretPinDialog.show` — حوار إدخال PIN للمسؤول
| الحقل | القيمة |
|-------|--------|
| **المسار** | `lib/core/common/widgets/secret_pin_dialog.dart` |
| **المحتوى** | نافذة حوار مخصصة تحتوي على حقل إدخال رقم PIN (مشفر) للتحقق من هوية المسؤول |
| **السياق** | يتم استدعاؤه من `settings_view.dart` عند النقر المزدوج على النص السفلي في صفحة الإعدادات. بعد التحقق الناجح، ينتقل إلى لوحة تحكم المطور |

---

### 3.2 `DailyContentExplanationDialog.show` — حوار شرح المحتوى
| الحقل | القيمة |
|-------|--------|
| **المسار** | `lib/core/common/overlays/dialog/daily_content_explanation_dialog.dart` |
| **المحتوى** | يعرض نص توضيحي (شرح) مقسم إلى نقاط مع زر "فهمت" للإغلاق. يُستخدم `CustomDialog` كلحاف |
| **السياق** | يُستدعى من `DailyContentBaseCard` و `DailyContentFavoriteCard` عند النقر على زر "شرح" بجانب المحتوى الديني (حديث أو سنة) |

---

### 3.3 `CustomRichContentDialog.show` — حوار المحتوى الغني
| الحقل | القيمة |
|-------|--------|
| **المسار** | `lib/core/common/overlays/dialog/custom_rich_content_dialog.dart` |
| **المحتوى** | يعرض نص مع عنوان ومصدر وأيقونة خلفية، مع أزرار مشاركة ونسخ وزر إغلاق |
| **السياق** | يُستدعى من `DailyContentCard` عند النقر على بطاقة المحتوى اليومي لعرض التفاصيل الكاملة مع إمكانية المشاركة والنسخ |

---

### 3.4 `CustomConfirmationDialog.show` — (أ) حوار تأكيد الخروج من الأذكار
| الحقل | القيمة |
|-------|--------|
| **المسار** | `lib/features/azkar/presentation/views/azkar_list_view.dart` |
| **المحتوى** | `title: AppStrings.azkarExitDialogTitle`, `message: AppStrings.azkarExitDialogMessage`, `confirmText: AppStrings.azkarExitDialogConfirmText` |
| **السياق** | يظهر عندما يحاول المستخدم الخروج من شاشة الأذكار قبل إكمال جميع الأذكار، ليسأله إن كان متأكداً من رغبته في الخروج |

---

### 3.5 `CustomConfirmationDialog.show` — (ب) حوار تأكيد الحفظ في SalatAlaNabi
| الحقل | القيمة |
|-------|--------|
| **المسار** | `lib/features/salat_ala_nabi/presentation/views/salat_ala_nabi_view.dart` |
| **المحتوى** | `title: AppStrings.saveChangesQuestion`, `message: AppStrings.unsavedChangesMessage` |
| **السياق** | يظهر عندما يحاول المستخدم الخروج من شاشة تذكير الصلاة على النبي ولديه تغييرات غير محفوظة. يقدم خيارين: حفظ التغييرات أو تجاهلها |

---

### 3.6 `CustomConfirmationDialog.show` — (ج) حوار تأكيد حذف الملاحظات
| الحقل | القيمة |
|-------|--------|
| **المسار** | `lib/features/developer_dashboard/presentation/widgets/admin_feedback_actions.dart` |
| **المحتوى** | `title: AppStrings.deleteConfirmation`, `message: AppStrings.deleteFeedbackConfirmationMessage`, `confirmText: AppStrings.delete`, `isDestructive: true` |
| **السياق** | يظهر للمسؤول في لوحة التحكم عند النقر على زر حذف ملاحظة، لتأكيد عملية الحذف (باستخدام نمط تدميري أحمر) |

---

### 3.7 `showCustomInfoDialog` — (أ) حوار معلومات التذكير بالصلاة على النبي
| الحقل | القيمة |
|-------|--------|
| **المسار** | `lib/features/salat_ala_nabi/presentation/views/salat_ala_nabi_view.dart` (دالة `showSalawatHelpDialog`) |
| **المحتوى** | يظهر ملاحظات مهمة عن التذكير بالصلاة على النبي وتعليمات لضمان استمرارية الخدمة |
| **السياق** | يُستدعى عند النقر على زر المصباح (LightbulbButton) في شاشة تذكير الصلاة على النبي |

---

### 3.8 `showCustomInfoDialog` — (ب) حوار إرشادات البوصلة (Qibla)
| الحقل | القيمة |
|-------|--------|
| **المسار** | `lib/features/qibla/presentation/widgets/qibla_help_dialog.dart` |
| **المحتوى** | يعرض إرشادات استخدام بوصلة القبلة وتحذير من عدم وجود حساس بوصلة في بعض الأجهزة |
| **السياق** | يُستدعى من شاشة القبلة لعرض تعليمات استخدام البوصلة ونصائح للحصول على أفضل دقة |

---

### 3.9 `showCustomInfoDialog` — (ج) حوار التحقق الشهري من التاريخ الهجري
| الحقل | القيمة |
|-------|--------|
| **المسار** | `lib/features/app_date/presentation/widgets/hijri_and_gregorian_date_widget.dart` (دالة `showHijriVerificationDialog`) |
| **المحتوى** | يعرض التاريخ الهجري الحالي ويسأل المستخدم عن صحته، مع شرح إمكانية تعديله |
| **السياق** | يظهر شهرياً بشكل تلقائي بعد الإنشاء الأولي للصفحة الرئيسية، للتحقق من صحة التاريخ الهجري المعروض |

---

### 3.10 `ReminderDialog` — حوار إضافة/تعديل التذكير
| الحقل | القيمة |
|-------|--------|
| **المسار** | `lib/features/azkar/presentation/widgets/reminder/reminder_section.dart` (استدعاء `showDialog<ReminderEntity>`) |
| **المحتوى** | حوار مخصص لإضافة تذكير جديد أو تعديل تذكير موجود، يحتوي على اختيار الوقت ونوع التكرار |
| **السياق** | يُستدعى من قسم التذكيرات في إعدادات القراءة عند النقر على زر الإضافة أو النقر على تذكير موجود للتعديل. يطلب الإذن أولاً قبل الفتح |

---

### 3.11 `showCustomDialog` — حوار رفض الإذن للتذكير
| الحقل | القيمة |
|-------|--------|
| **المسار** | `lib/features/azkar/presentation/widgets/reminder/reminder_section.dart` (دالة `_showPermissionDeniedDialog`) |
| **المحتوى** | يعرض رسالة تفيد بعدم منح الإذن مع خيارين: إلغاء أو فتح إعدادات التطبيق |
| **السياق** | يظهر عندما يرفض المستخدم منح إذن الإشعارات للتذكير أو عندما يكون الإذن مرفوضاً بشكل دائم |

---

# 4️⃣ Bottom Sheets (الأوراق السفلية)

**المكوّن الأساسي:** `showCustomBottomSheet` في `show_custom_bottom_sheet.dart`  
**التقنية:** تستخدم `showModalBottomSheet` من Flutter SDK  
**الغلاف:** `CustomBottomSheet` في `custom_bottom_sheet_widget.dart`

---

### 4.1 `showCustomBottomSheet` — (1) تفاصيل موضوع تعليم الصلاة
| الحقل | القيمة |
|-------|--------|
| **المسار** | `lib/features/teaching_prayer/presentation/widgets/teaching_section_card.dart` |
| **المحتوى** | يعرض `TeachingTopicDetailsBottomSheet` الذي يحتوي على نقاط شرح مفصلة لموضوع تعليمي مع تمييز الكلمات المهمة |
| **السياق** | يظهر عند النقر على أحد مواضيع قسم تعليم الصلاة |

---

### 4.2 `showCustomBottomSheet` — (2) اختيار وضع السمة (Theme)
| الحقل | القيمة |
|-------|--------|
| **المسار** | `lib/features/settings/presentation/views/settings_view.dart` |
| **المحتوى** | يعرض 3 خيارات (نظامي، فاتح، داكن) باستخدام `RadioListTile<ThemeMode>` |
| **السياق** | يظهر عند النقر على خيار "وضع السمة" في صفحة الإعدادات |

---

### 4.3 `showCustomBottomSheet` — (3) تعديل التاريخ الهجري
| الحقل | القيمة |
|-------|--------|
| **المسار** | `lib/features/app_date/presentation/widgets/hijri_and_gregorian_date_widget.dart` |
| **المحتوى** | يعرض `HijriAdjustmentBottomSheet` مع أزرار لضبط التاريخ الهجري (1-، 0، 1+) وزر للعودة للوضع الطبيعي |
| **السياق** | يظهر عند النقر على التاريخ الهجري/الميلاديّ في شاشة الرئيسية |

---

### 4.4 `showCustomBottomSheet` — (4) إعدادات القراءة (الأذكار)
| الحقل | القيمة |
|-------|--------|
| **المسار** | `lib/features/azkar/presentation/views/azkar_list_view.dart` |
| **المحتوى** | يعرض `ReadingSettingsBottomSheet` الذي يحتوي على تحكم بحجم الخط وقسم التذكيرات |
| **السياق** | يظهر عند النقر على أيقونة الإعدادات (tuning) في شاشة عرض الأذكار |

---

### 4.5 `showCustomBottomSheet` — (5) تفاصيل سنة الصلاة
| الحقل | القيمة |
|-------|--------|
| **المسار** | `lib/features/prayer/presentation/widgets/prayer_card_content.dart` |
| **المحتوى** | يعرض `PrayerSunnahBottomSheet` مع نص الحديث النبوي عن سنة الصلاة وعدد الركعات، مع أزرار مشاركة ونسخ |
| **السياق** | يظهر عند النقر على بطاقة وقت الصلاة في شاشة مواقيت الصلاة |

---

### 4.6 `showCustomBottomSheet` — (6) اختيار المذهب الفقهي
| الحقل | القيمة |
|-------|--------|
| **المسار** | `lib/features/prayer/presentation/widgets/prayer_settings/madhab_widget.dart` |
| **المحتوى** | يعرض قائمة بجميع المذاهب الفقهية (`MadhabEntity.values`) مع إشارة اختيار للمذهب المحدد حالياً |
| **السياق** | يظهر عند النقر على خيار المذهب في إعدادات الصلاة |

---

### 4.7 `showCustomBottomSheet` — (7) اختيار طريقة الحساب
| الحقل | القيمة |
|-------|--------|
| **المسار** | `lib/features/prayer/presentation/widgets/prayer_settings/calculation_method_widget.dart` |
| **المحتوى** | يعرض قائمة بطرق حساب مواقيت الصلاة (`CalculationMethodEntity`) مع إشارة للمحدد حالياً |
| **السياق** | يظهر عند النقر على خيار طريقة الحساب في إعدادات الصلاة |

---

### 4.8 `showCustomBottomSheet` — (8) بوابة إدارة الموقع الجغرافي (Location Guard)
| الحقل | القيمة |
|-------|--------|
| **المسار** | `lib/core/services/location_manager/presentation/widgets/location_guard.dart` |
| **المحتوى** | يعرض سلسلة من البوتوم شيتس حسب حالة الموقع: (1) اختيار طريقة تحديد الموقع، (2) طلب تفعيل خدمة الموقع، (3) طلب إذن الموقع، (4) الإذن مرفوض بشكل دائم، (5) خطأ في الموقع. كل منها يحتوي على أزرار مناسبة (تفعيل، اختيار دولة، تخطي) |
| **السياق** | يُستخدم كحارس (Guard) في العديد من الشاشات التي تحتاج الموقع الجغرافي (القبلة، مواقيت الصلاة). يظهر تلقائياً عند تهيئة الشاشة إذا لم يكن الموقع محدداً مسبقاً. يتضمن خيار اختيار الدولة يدوياً من قائمة الدول العربية |

---

### 4.9 `showCustomBottomSheet` — (9) اختيار الدولة
| الحقل | القيمة |
|-------|--------|
| **المسار** | `lib/core/services/location_manager/presentation/widgets/location_guard.dart` (دالة `_showCountryPicker`) |
| **المحتوى** | يعرض `LocationCountryPicker` مع قائمة بالدول العربية للاختيار اليدوي |
| **السياق** | يُستدعى كبديل من بوتوم شيت الموقع عندما يختار المستخدم "اختيار دولة" بدلاً من تفعيل GPS |

---

# 🔍 ملاحظات واستنتاجات

### الأنماط الملاحظة
1. **توحيد الـ Toasts:** التطبيق يستخدم `AppToast.show` بشكل موحد لجميع الإشعارات المنبثقة، مما يوفر تحكماً مركزياً بالشكل والسلوك (مثل الـ debouncing).
2. **SnackBar استخدام محدود:** وجود حالتين فقط لاستخدام `SnackBar` يشير إلى أن التطبيق انتقل من SnackBar إلى `AppToast` ولكن بعض الأماكن القديمة لم تُحدّث بعد.
3. **Bottom Sheet موحد:** جميع البوتوم شيتس تمر عبر `showCustomBottomSheet` مما يوفر واجهة موحدة.
4. **تدرج الحوارات:** هناك تدرج من `showDialog` (Flutter SDK) ← `showCustomDialog` (مخصص) ← حوارات متخصصة (`CustomConfirmationDialog`, `CustomInfoDialog`).
5. **إدارة الموقع الأكثر استخداماً:** الـ Location Guard هو أكثر مكان استخداماً للبوتوم شيتس (7 استدعاءات مختلفة ضمن ملف واحد).
6. **المكتبات:** `toastification` للـ Toasts، Flutter SDK للـ SnackBars والـ Dialogs والـ Bottom Sheets.
