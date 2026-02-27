import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/widgets/app_buttons.dart';
import 'package:sana/core/common/widgets/app_toast.dart';
import 'package:sana/core/common/widgets/custom_arrow_back_button.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/report/presentation/controller/report_cubit.dart';
import 'package:sana/features/report/presentation/widgets/report_header.dart';
import 'package:sana/features/report/presentation/widgets/report_text_field.dart';
import 'package:sana/features/report/presentation/widgets/success_report_dialog.dart';
import 'package:solar_icons/solar_icons.dart';

class ReportIssueView extends StatelessWidget {
  const ReportIssueView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ReportCubit>(),
      child: const _ReportIssueContent(),
    );
  }
}

class _ReportIssueContent extends StatefulWidget {
  const _ReportIssueContent();

  @override
  State<_ReportIssueContent> createState() => _ReportIssueContentState();
}

class _ReportIssueContentState extends State<_ReportIssueContent> {
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

    await context.read<ReportCubit>().sendReport(
      issueDescription: _issueController.text,
      contactInfo: _contactController.text.trim().isEmpty
          ? null
          : _contactController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReportCubit, ReportState>(
      listener: (context, state) {
        if (state is ReportSuccess) {
          SuccessReportDialog.show(context);
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
          title: Text(
            'أقتراح ميزة او بلاغ عن مشكلة',
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
                const ReportHeader(),
                const SizedBox(height: 24),
                _buildLabel(
                  context,
                  'تفاصيل',
                ),
                const SizedBox(height: 12),
                ReportTextField(
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
                ReportTextField(
                  controller: _contactController,
                  hint: 'بريد إلكتروني أو رقم هاتف...',
                ),
                const SizedBox(height: 40),
                BlocBuilder<ReportCubit, ReportState>(
                  builder: (context, state) => AppPrimaryButton(
                    text: 'إرسال',
                    icon: SolarIconsBold.sendSquare,
                    onPressed: () => unawaited(_handleSubmit()),
                    isLoading: state is ReportSending,
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
