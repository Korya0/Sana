import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:sana/core/common/widgets/app_buttons.dart';
import 'package:sana/core/common/widgets/app_toast.dart';
import 'package:sana/core/common/widgets/custom_arrow_back_button.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/report/presentation/controller/report_cubit.dart';
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
      create: (context) => sl<ReportCubit>(),
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
  late final TextEditingController _contactController;
  String _selectedCategory = 'مشكلة تقنية';

  final List<String> _categories = [
    'مشكلة تقنية',
    'اقتراح ميزة',
    'تصحيح بيانات',
    'أخرى',
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.isSuggestion ? 'اقتراح ميزة' : 'مشكلة تقنية';
    var initialText = '';
    if (widget.errorDetails != null && !widget.isSuggestion) {
      initialText = 'حدث خطأ تقني غير متوقع، أرجو إصلاحه.';
    }
    _issueController = TextEditingController(text: initialText);
    _contactController = TextEditingController();
  }

  @override
  void dispose() {
    _issueController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final fullMessage = '[$_selectedCategory] ${_issueController.text}';

    await context.read<ReportCubit>().sendReport(
      issueDescription: fullMessage,
      errorDetails: widget.errorDetails,
      contactInfo: _contactController.text.isEmpty
          ? null
          : _contactController.text,
      isSuggestion: widget.isSuggestion || _selectedCategory == 'اقتراح ميزة',
    );
  }

  void _showSuccessDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: AppColors.secondaryBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/json/success_check.json',
                width: 150,
                height: 150,
                repeat: false,
              ),
              const SizedBox(height: 16),
              Text(
                'تم الإرسال بنجاح',
                style: AppTextStyles.font18W700White(context),
              ),
              const SizedBox(height: 8),
              Text(
                'شكراً لمساهمتك في تحسين تطبيق سنا، جزاك الله خيراً.',
                textAlign: TextAlign.center,
                style: AppTextStyles.font14W400Grey(context),
              ),
              const SizedBox(height: 24),
              AppPrimaryButton(
                text: 'إغلاق',
                onPressed: () {
                  context.pop(); // Close Dialog
                  context.pop(); // Go back to previous screen
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isSuggestion ? 'اقتراح ميزة' : 'الإبلاغ عن مشكلة';

    return BlocListener<ReportCubit, ReportState>(
      listener: (context, state) {
        if (state is ReportSuccess) {
          _showSuccessDialog();
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
                _buildHeader(),
                const SizedBox(height: 32),
                _buildLabel('نوع البلاغ'),
                const SizedBox(height: 12),
                _buildCategoryDropdown(),
                const SizedBox(height: 24),
                _buildLabel(
                  widget.isSuggestion ? 'تفاصيل الاقتراح' : 'وصف المشكلة',
                ),
                const SizedBox(height: 12),
                _buildDescriptionInput(),
                const SizedBox(height: 24),
                _buildLabel('وسيلة تواصل (اختياري)'),
                const SizedBox(height: 12),
                _buildContactInput(),
                const SizedBox(height: 40),
                _buildSubmitButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final icon = widget.isSuggestion
        ? SolarIconsBold.lightbulb
        : SolarIconsBold.dangerTriangle;
    final headerText = widget.isSuggestion
        ? 'شاركنا أفكارك'
        : 'ساعدنا في التحسين';
    final descriptionText = widget.isSuggestion
        ? 'لديك فكرة رائعة؟ أخبرنا بها لتحسين التطبيق'
        : 'أخبرنا عن المشكلة التي واجهتك وسنعمل على حلها';

    return Column(
      children: [
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
        Text(headerText, style: AppTextStyles.font18W700White(context)),
        const SizedBox(height: 8),
        Text(
          descriptionText,
          style: AppTextStyles.font14W400Grey(context),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: AppTextStyles.font16W600White(context));
  }

  Widget _buildCategoryDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          isExpanded: true,
          dropdownColor: AppColors.secondaryBackground,
          icon: const Icon(
            SolarIconsBold.altArrowDown,
            color: AppColors.gold,
            size: 20,
          ),
          items: _categories.map((String category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(
                category,
                style: AppTextStyles.font16W500Grey(
                  context,
                ).copyWith(color: AppColors.white),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() => _selectedCategory = newValue);
            }
          },
        ),
      ),
    );
  }

  Widget _buildDescriptionInput() {
    return TextFormField(
      controller: _issueController,
      maxLines: 5,
      cursorColor: AppColors.gold,
      style: AppTextStyles.font16W500Grey(
        context,
      ).copyWith(color: AppColors.white),
      decoration: _inputDecoration(
        widget.isSuggestion
            ? 'اشرح فكرتك بالتفصيل...'
            : 'اكتب وصفاً تفصيلياً للمشكلة...',
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty)
          return 'الرجاء كتابة التفاصيل';
        if (widget.errorDetails == null && value.trim().length < 10)
          return 'الرجاء كتابة 10 أحرف على الأقل';
        return null;
      },
    );
  }

  Widget _buildContactInput() {
    return TextFormField(
      controller: _contactController,
      cursorColor: AppColors.gold,
      style: AppTextStyles.font16W500Grey(
        context,
      ).copyWith(color: AppColors.white),
      decoration: _inputDecoration('بريد إلكتروني أو رقم هاتف...'),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.font14W400Grey(context),
      filled: true,
      fillColor: AppColors.secondaryBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.gold.withValues(alpha: 0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.gold.withValues(alpha: 0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.gold, width: 2),
      ),
      contentPadding: const EdgeInsets.all(16),
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<ReportCubit, ReportState>(
      builder: (context, state) {
        return AppPrimaryButton(
          text: widget.isSuggestion ? 'إرسال الاقتراح' : 'إرسال البلاغ',
          icon: SolarIconsBold.sendSquare,
          onPressed: () => unawaited(_handleSubmit(context)),
          isLoading: state is ReportSending,
        );
      },
    );
  }
}
