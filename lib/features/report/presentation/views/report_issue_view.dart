import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/widgets/app_buttons.dart';
import 'package:sana/core/common/widgets/app_toast.dart';
import 'package:sana/core/common/widgets/custom_arrow_back_button.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/report/presentation/controller/report_cubit.dart';
import 'package:sana/features/report/presentation/controller/report_state.dart';
import 'package:solar_icons/solar_icons.dart';

class ReportIssueView extends StatelessWidget {
  const ReportIssueView({
    super.key,
    this.errorDetails,
    this.isSuggestion = false,
  });
  final String? errorDetails;
  final bool isSuggestion;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReportCubit(),
      child: _ReportIssueContent(
        errorDetails: errorDetails,
        isSuggestion: isSuggestion,
      ),
    );
  }
}

class _ReportIssueContent extends StatefulWidget {
  const _ReportIssueContent({required this.isSuggestion, this.errorDetails});
  final String? errorDetails;
  final bool isSuggestion;

  @override
  State<_ReportIssueContent> createState() => _ReportIssueContentState();
}

class _ReportIssueContentState extends State<_ReportIssueContent> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _issueController;

  @override
  void initState() {
    super.initState();
    var initialText = '';
    if (widget.errorDetails != null && !widget.isSuggestion) {
      initialText = 'حدث خطأ تقني غير متوقع، أرجو إصلاحه.';
    }
    _issueController = TextEditingController(text: initialText);
  }

  @override
  void dispose() {
    _issueController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    await context.read<ReportCubit>().sendReport(
      issueDescription: _issueController.text,
      errorDetails: widget.errorDetails,
      isSuggestion: widget.isSuggestion,
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isSuggestion ? 'اقتراح ميزة' : 'الإبلاغ عن مشكلة';
    final headerText = widget.isSuggestion
        ? 'شاركنا أفكارك'
        : 'ساعدنا في التحسين';
    final descriptionText = widget.isSuggestion
        ? 'لديك فكرة رائعة؟ أخبرنا بها لنضيفها في التحديثات القادمة'
        : 'أخبرنا عن المشكلة التي واجهتك وسنعمل على حلها';
    final inputLabel = widget.isSuggestion ? 'تفاصيل الاقتراح' : 'وصف المشكلة';
    final hintText = widget.isSuggestion
        ? 'اشرح فكرتك بالتفصيل...'
        : 'اكتب وصفاً تفصيلياً للمشكلة...';
    final icon = widget.isSuggestion
        ? SolarIconsBold.lightbulb
        : SolarIconsBold.dangerTriangle;
    final buttonText = widget.isSuggestion ? 'إرسال الاقتراح' : 'إرسال البلاغ';

    return BlocListener<ReportCubit, ReportState>(
      listener: (context, state) {
        if (state is ReportSuccess) {
          context.pop();
          AppToast.show(context, state.message);
        } else if (state is ReportFailure) {
          AppToast.show(context, 'فشل الإرسال، يرجى التحقق من اتصال الإنترنت');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: AppColors.scaffoldBackground,
          elevation: 0,
          leading: const CustomArrowBackButton(),
          title: Text(title, style: AppTextStyles.font18W700White(context)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Icon
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.gold.withValues(alpha: 0.1),
                      border: Border.all(
                        color: AppColors.gold.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: Icon(icon, color: AppColors.gold, size: 40),
                  ),
                ),

                const SizedBox(height: 24),

                // Title
                Center(
                  child: Text(
                    headerText,
                    style: AppTextStyles.font18W700White(context),
                  ),
                ),

                const SizedBox(height: 8),

                // Description
                Center(
                  child: Text(
                    descriptionText,
                    style: AppTextStyles.font16W500Grey(context),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 32),

                // Input Label
                Text(inputLabel, style: AppTextStyles.font16W600White(context)),

                const SizedBox(height: 12),

                // Input
                TextFormField(
                  cursorColor: AppColors.gold,

                  controller: _issueController,
                  maxLines: 8,
                  style: AppTextStyles.font16W500Grey(
                    context,
                  ).copyWith(color: AppColors.white),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: AppTextStyles.font16W500Grey(context),
                    filled: true,
                    fillColor: AppColors.secondaryBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.gold.withValues(alpha: 0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppColors.gold.withValues(alpha: 0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.gold,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'الرجاء كتابة التفاصيل';
                    }
                    // If it's a technical error report (not a suggestion) and we have error info,
                    // we don't need to be strict about length.
                    if (widget.errorDetails == null &&
                        value.trim().length < 10) {
                      return 'الرجاء كتابة تفاصيل أكثر (10 أحرف على الأقل)';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Send Button
                BlocBuilder<ReportCubit, ReportState>(
                  builder: (context, state) {
                    return AppPrimaryButton(
                      text: buttonText,
                      icon: SolarIconsBold.sendSquare,
                      onPressed: () => unawaited(_handleSubmit(context)),
                      isLoading: state is ReportSending,
                    );
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
