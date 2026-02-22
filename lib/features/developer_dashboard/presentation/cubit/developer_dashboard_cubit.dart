import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/features/developer_dashboard/data/services/developer_dashboard_service.dart';
import 'package:sana/features/developer_dashboard/presentation/cubit/developer_dashboard_state.dart';

class DeveloperDashboardCubit extends Cubit<DeveloperDashboardState> {
  DeveloperDashboardCubit(this._service) : super(DeveloperDashboardInitial());

  final DeveloperDashboardService _service;

  Future<void> loadReports() async {
    emit(DeveloperDashboardLoading());
    try {
      final reports = await _service.fetchReports();
      emit(DeveloperDashboardLoaded(reports));
    } on Exception catch (e) {
      emit(DeveloperDashboardError(e.toString()));
    }
  }

  Future<void> deleteReport(String id) async {
    try {
      await _service.deleteReport(id);
      // Reload reports after deletion
      await loadReports();
    } on Exception catch (e) {
      // In a real app, you might want to show a toast message here instead of changing the whole state
      emit(DeveloperDashboardError('حدث خطأ أثناء الحذف: $e'));
    }
  }
}
