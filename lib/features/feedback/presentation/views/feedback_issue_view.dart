import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/common/widgets/app_buttons.dart';
import 'package:sana/core/common/widgets/app_toast.dart';
import 'package:sana/core/common/widgets/custom_arrow_back_button.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/feedback/presentation/controller/Feedback_state.dart';
import 'package:sana/features/feedback/presentation/controller/feedback_cubit.dart';
import 'package:sana/features/feedback/presentation/widgets/feedback_text_field.dart';
import 'package:solar_icons/solar_icons.dart';

class FeedbackIssueView extends StatelessWidget {
  const FeedbackIssueView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<FeedbackCubit>(),
      child: const _FeedbackIssueContent(),
    );
  }
}

class _FeedbackIssueContent extends StatefulWidget {
  const _FeedbackIssueContent();

  @override
  State<_FeedbackIssueContent> createState() => _FeedbackIssueContentState();
}

class _FeedbackIssueContentState extends State<_FeedbackIssueContent> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _issueController;
  late final TextEditingController _contactController;

  @override
  void initState() {
    super.initState();
    _issueController = TextEditingController();
    _contactController = TextEditingController();
  }

  @override
  void dispose() {
    _issueController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    await context.read<FeedbackCubit>().sendFeedback(
      issueDescription: _issueController.text,
      contactInfo: _contactController.text.trim().isEmpty
          ? null
          : _contactController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedbackCubit, FeedbackState>(
      listener: (context, state) {
        if (state is FeedbackSuccess) {
          context.pop();
          AppToast.show(
            context,
            state.message,
          );
        } else if (state is FeedbackFailure) {
          AppToast.show(context, state.error);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: AppColors.scaffoldBackground,
          elevation: 0,
          leading: const CustomArrowBackButton(),
          title: Text(
            'اقتراح أو شكوى',
            style: AppTextStyles.font18W700White(context),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
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
                        child: const Icon(
                          SolarIconsBold.lightbulb,
                          color: AppColors.gold,
                          size: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'ساعدنا في التحسين',
                      style: AppTextStyles.font18W700White(context),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildLabel(
                  context,
                  'تفاصيل',
                ),
                const SizedBox(height: 12),
                FeedbackTextField(
                  controller: _issueController,
                  hint: 'اكتب وصفاً تفصيلياً ...',
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'الرجاء كتابة التفاصيل';
                    }
                    if (value.trim().length < 10) {
                      return 'الرجاء كتابة 10 أحرف على الأقل';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                _buildLabel(context, 'وسيلة تواصل (اختياري)'),
                const SizedBox(height: 12),
                FeedbackTextField(
                  controller: _contactController,
                  hint: 'بريد إلكتروني أو رقم هاتف',
                ),
                const SizedBox(height: 40),
                BlocBuilder<FeedbackCubit, FeedbackState>(
                  builder: (context, state) => AppPrimaryButton(
                    text: 'إرسال',
                    icon: SolarIconsBold.sendSquare,
                    onPressed: () => unawaited(_handleSubmit()),
                    isLoading: state is FeedbackSending,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text) =>
      Text(text, style: AppTextStyles.font16W600White(context));
}
