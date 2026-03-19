import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/buttons/app_buttons.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_spacing.dart';
import 'package:sana/features/feedback/presentation/cubit/feedback_cubit.dart';
import 'package:sana/features/feedback/presentation/cubit/feedback_state.dart';
import 'package:sana/features/feedback/presentation/widgets/feedback_text_field.dart';
import 'package:solar_icons/solar_icons.dart';

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({super.key});

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
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
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Detail Section
          _buildLabel(
            context,
            AppStrings.details,
          ),
          FeedbackTextField(
            controller: _issueController,
            hint: AppStrings.writeDetails,
            keyboardType: TextInputType.multiline,

            maxLines: 5,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return AppStrings.writeDetails;
              }
              if (value.trim().length < 10) {
                return AppStrings.writeDetailsLateset10Characters;
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.v24),

          // Contact Section
          _buildLabel(context, AppStrings.letContactInfo),
          FeedbackTextField(
            controller: _contactController,
            hint: AppStrings.emailOrPhone,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: AppSpacing.v40),

          // Submit Button
          BlocBuilder<FeedbackCubit, FeedbackState>(
            builder: (context, state) => AppPrimaryButton(
              text: AppStrings.send,
              icon: SolarIconsBold.sendSquare,
              onPressed: () => unawaited(_handleSubmit()),
              isLoading: state is FeedbackSending,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.v12),
    child: Text(text, style: AppTextStyles.font16W600White(context)),
  );
}
