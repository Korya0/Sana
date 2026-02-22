import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/theme/fonts/app_text_styles.dart';
import 'package:sana/core/theme/style/app_colors.dart';
import 'package:sana/features/developer_dashboard/data/models/report_model.dart';
import 'package:sana/features/developer_dashboard/presentation/cubit/developer_dashboard_cubit.dart';
import 'package:sana/features/developer_dashboard/presentation/cubit/developer_dashboard_state.dart';

class DeveloperDashboardView extends StatefulWidget {
  const DeveloperDashboardView({super.key});

  @override
  State<DeveloperDashboardView> createState() => _DeveloperDashboardViewState();
}

class _DeveloperDashboardViewState extends State<DeveloperDashboardView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    unawaited(context.read<DeveloperDashboardCubit>().loadReports());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        title: Text(
          'لوحة تحكم المطور',
          style: AppTextStyles.font18W700White(context),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.gold,
          labelColor: AppColors.gold,
          unselectedLabelColor: AppColors.grey,
          tabs: const [
            Tab(text: 'المشاكل'),
            Tab(text: 'الاقتراحات'),
          ],
        ),
      ),
      body: BlocBuilder<DeveloperDashboardCubit, DeveloperDashboardState>(
        builder: (context, state) {
          if (state is DeveloperDashboardLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            );
          } else if (state is DeveloperDashboardError) {
            return Center(
              child: Text(
                'حدث خطأ: ${state.message}',
                style: AppTextStyles.font16W500Grey(context),
              ),
            );
          } else if (state is DeveloperDashboardLoaded) {
            final issues = state.reports.where((r) => !r.isSuggestion).toList();
            final suggestions = state.reports
                .where((r) => r.isSuggestion)
                .toList();

            return TabBarView(
              controller: _tabController,
              children: [
                _buildReportList(issues),
                _buildReportList(suggestions),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildReportList(List<ReportModel> reports) {
    if (reports.isEmpty) {
      return Center(
        child: Text(
          'لا توجد عناصر حالياً',
          style: AppTextStyles.font16W500Grey(context),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: reports.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final report = reports[index];
        return Card(
          color: AppColors.secondaryBackground,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: AppColors.gold.withValues(alpha: 0.1)),
          ),
          child: ExpansionTile(
            iconColor: AppColors.gold,
            collapsedIconColor: AppColors.grey,
            title: Text(
              report.message,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font16W600White(context),
            ),
            subtitle: Text(
              _formatDate(report.timestamp),
              style: AppTextStyles.font12W500Grey(context),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'التفاصيل كاملة:',
                      style: AppTextStyles.font14W600Gold(context),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      report.message,
                      style: AppTextStyles.font14W400WhiteHeight16(context),
                    ),
                    if (report.errorDetails != null &&
                        report.errorDetails != 'لا يوجد') ...[
                      const Divider(color: AppColors.grey, height: 24),
                      Text(
                        'الخطأ التقني:',
                        style: AppTextStyles.font14W600Gold(
                          context,
                        ).copyWith(color: Colors.redAccent),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        report.errorDetails ?? '',
                        style: AppTextStyles.font12W500Grey(context),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                        ),
                        onPressed: () async {
                          await context
                              .read<DeveloperDashboardCubit>()
                              .deleteReport(
                                report.id,
                              );
                        },
                        icon: const Icon(Icons.delete_outline, size: 20),
                        label: const Text('حذف'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
    } on FormatException catch (_) {
      return isoDate;
    }
  }
}
