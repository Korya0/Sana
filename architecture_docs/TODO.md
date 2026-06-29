# Future Tasks

- [ ] Create a global custom `AppBottomSheet` component for the entire app.
  - Create a new utility class (e.g., in `lib/core/common/overlays/`) inspired by `fitness_app`'s `AppBottomSheet`.
  - **Drag Handle:** Add a top divider/handle using `Container(width: 40, height: 4, decoration: ...)`.
  - **Safe Area & Keyboard:** Wrap the content inside `SafeArea` and `Padding` handling `viewInsets.bottom` for keyboard support.
  - **Shape:** Use top rounded corners: `BorderRadius.vertical(top: Radius.circular(24))`.
  - **Layout:** Place the content in a `Column(mainAxisSize: MainAxisSize.min)` with standard top and bottom gaps.
  - **Refactor:** Migrate all existing bottom sheets in the app (such as `hijri_adjustment_bottom_sheet.dart`) to use this new unified `AppBottomSheet.show(...)`.
  - *Reference code for the target bottom sheet implementation (from fitness_app)*:
    <details>
    <summary>Click to view reference code</summary>
    
    ```dart
    import 'package:flutter/material.dart';

    class AppBottomSheet {
      AppBottomSheet._();

      static Future<T?> show<T>({
        required BuildContext context,
        required Widget child,
      }) {
        return showModalBottomSheet<T>(
          context: context,
          isScrollControlled: true,
          // TODO: Use correct background color for muslim_app
          backgroundColor: Theme.of(context).scaffoldBackgroundColor, 
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          builder: (context) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 16,
                  right: 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        // TODO: Use muslim_app text secondary color
                        color: Colors.grey.withValues(alpha: 0.8), 
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    const SizedBox(height: 25),
                    child,
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            );
          },
        );
      }
    }
    ```
    </details>
- [ ] Move `adminSecretPin` to Firebase Remote Config for better Configuration & Environment Separation.
  ```dart
  // TODO(sana): Move this to Firebase Remote Config for better Configuration & Environment Separation
  static const String adminSecretPin = '31903556'
  ```

- [ ] Refactor `app_buttons.dart` (`lib/core/common/buttons/app_buttons.dart`).
  - Merge the multiple button classes into a single `StatefulWidget` class with multiple named constructors (e.g., `.primary`, `.secondary`).
  - Stop using native `Material` or `Cupertino` buttons (`ElevatedButton`, `CupertinoButton`, etc.).
  - Build the button from scratch using `Container` and `GestureDetector`.
  - Implement touch feedback manually using `Listener` and `AnimatedOpacity` to reduce opacity when pressed.
  - Apply the exact same animation/touch effect used in the fitness app.
  - **Maintain** the current `Debouncing` feature (preventing multiple clicks).
  - **Maintain** the current `isLoading` support.
  - Make the layout flexible for content: Allow passing `leading` and `trailing` widgets instead of just a single `icon`.
  - *Reference code for the target button implementation (from fitness_app)*:
    <details>
    <summary>Click to view reference code</summary>
    
    ```dart
    // Use this structure but adapt it with the features mentioned above (Debouncing, isLoading, etc.)
    import 'package:flutter/material.dart';

    enum AppButtonType { primary, secondary, outlined }

    class AppButton extends StatefulWidget {
      const AppButton.primary({
        required this.text,
        super.key,
        this.onPressed,
        this.leading,
        this.trailing,
        this.isDisabled = false,
      }) : type = AppButtonType.primary;
      // ... same for secondary, outlined
      
      final String text;
      final VoidCallback? onPressed;
      final AppButtonType type;
      final Widget? leading;
      final Widget? trailing;
      final bool isDisabled;

      @override
      State<AppButton> createState() => _AppButtonState();
    }

    class _AppButtonState extends State<AppButton> {
      bool _isPressed = false;

      @override
      Widget build(BuildContext context) {
        return Listener(
          onPointerDown: (_) => setState(() => _isPressed = true),
          onPointerUp: (_) => setState(() => _isPressed = false),
          onPointerCancel: (_) => setState(() => _isPressed = false),
          child: GestureDetector(
            onTap: widget.onPressed,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 10),
              curve: Curves.easeOut,
              opacity: _isPressed ? 0.6 : 1.0,
              child: Container(
                // ... styling
              ),
            ),
          ),
        );
      }
    }
    ```
    </details>

- [ ] Create `app_text_button.dart` in `lib/core/common/buttons/`.
  - Copy the implementation of the text button from `fitness_app` but update colors and typography to match `muslim_app`.
  - *Code to copy and adapt*:
    <details>
    <summary>Click to view reference code</summary>
    
    ```dart
    import 'package:flutter/material.dart';

    class AppTextButton extends StatefulWidget {
      const AppTextButton({
        required this.text,
        required this.onPressed,
        this.textStyle,
        this.leading,
        this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        super.key,
      });

      final String text;
      final VoidCallback onPressed;
      final TextStyle? textStyle;
      final Widget? leading;
      final EdgeInsetsGeometry padding;

      @override
      State<AppTextButton> createState() => _AppTextButtonState();
    }

    class _AppTextButtonState extends State<AppTextButton> {
      bool _isPressed = false;

      @override
      Widget build(BuildContext context) {
        // TODO: Update colors and text styles to match muslim_app
        final style = widget.textStyle ?? const TextStyle(color: Colors.blue);

        Widget content = Text(widget.text, style: style);

        if (widget.leading != null) {
          content = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.leading!,
              const SizedBox(width: 4), // Replaced AppGap.w(4)
              content,
            ],
          );
        }

        return Listener(
          onPointerDown: (_) => setState(() => _isPressed = true),
          onPointerUp: (_) => setState(() => _isPressed = false),
          onPointerCancel: (_) => setState(() => _isPressed = false),
          behavior: HitTestBehavior.opaque,
          child: GestureDetector(
            onTap: widget.onPressed,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: widget.padding,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 50),
                curve: Curves.easeInOut,
                opacity: _isPressed ? 0.3 : 1.0,
                child: content,
              ),
            ),
          ),
        );
      }
    ```
    </details>

- [ ] Create `custom_simple_alert_dialog.dart` in `lib/core/common/overlays/dialog/`.
  - Create a simple Dialog component inspired by `app_dialog.dart` in `fitness_app`.
  - It should display a centered `message` and a single full-width primary button to dismiss.
  - Build it using `showCustomDialog` from `muslim_app` to inherit the glassmorphism and theme styles.
  - *Reference code for the target dialog implementation*:
    <details>
    <summary>Click to view reference code</summary>
    
    ```dart
    import 'package:flutter/material.dart';
    import 'package:go_router/go_router.dart';
    import 'package:sana/core/common/buttons/app_buttons.dart';
    import 'package:sana/core/common/overlays/dialog/custom_dialog.dart';
    import 'package:sana/core/theme/fonts/app_text_styles.dart';
    import 'package:sana/core/theme/app_spacing.dart';
    import 'package:sana/core/utils/utils.dart';
    import 'package:sana/core/constants/constants.dart';

    Future<T?> showCustomSimpleAlertDialog<T>({
      required BuildContext context,
      required String message,
      String buttonText = 'موافق',
    }) {
      return showCustomDialog<T>(
        context: context,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.v16, horizontal: AppSpacing.v16),
        child: Builder(
          builder: (innerContext) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTextStyles.font16W700(innerContext).copyWith(
                  color: innerContext.color.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.v24),
              SizedBox(
                width: double.infinity,
                child: AppPrimaryButton(
                  text: buttonText,
                  onPressed: () => innerContext.pop(),
                ),
              ),
            ],
          ),
        ),
      );
    }
    ```
    </details>

- [ ] Firebase Analytics: Track Custom Event for Azkar Completion (`complete_azkar`).
- [ ] Firebase Analytics: Track User Property for Theme Preference (`preferred_theme`).
- [ ] Firebase Analytics: Track User Property for Location/Country (`location_country`).
- [ ] Firebase Crashlytics: Bind Analytics to Crashlytics to track user actions before crashes.
- [ ] Firebase Analytics: Track Reading Time (Time Tracking) for Quran and Azkar.
- [ ] Firebase Analytics: Track Custom Event for Qibla Calibration Needed (`qibla_calibration_needed`).
- [ ] Firebase Analytics: Track Custom Event for Completing Prayer Tutorial (`finish_prayer_tutorial`).
- [ ] Firebase Analytics: Track Custom Event for Sharing Daily Content (`share_daily_content`).
- [ ] Firebase Analytics: Track Custom Event for Successful Feedback Submission (`submit_feedback`).
- [ ] Firebase Analytics: Track Custom Event for Opening Store Rating (`open_store_rating`).
- [ ] App Update: Add `WidgetsBindingObserver` to check for updates when the app returns from the background (App Resumed), not just on Cold Start.
