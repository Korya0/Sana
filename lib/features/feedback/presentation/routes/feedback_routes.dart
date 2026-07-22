import 'package:go_router/go_router.dart';
import 'package:sana/core/routing/app_routes.dart';
import 'package:sana/core/routing/app_transitions.dart';
import 'package:sana/features/feedback/presentation/views/feedback_issue_view.dart';

final List<RouteBase> feedbackRoutes = [
  GoRoute(
    path: AppRoutes.feedback,
    name: AppRoutes.feedback,
    pageBuilder: (context, state) => AppTransitions.slideFromRight(
      context: context,
      state: state,
      child: const FeedbackIssueView(),
    ),
  ),
];
