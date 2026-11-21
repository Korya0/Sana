import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/error/result.dart';
import 'package:sana/core/router/app_routes.dart';
import 'package:sana/core/theme/app_theme.dart';
import 'package:sana/features/azkar/domain/entities/azkar_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/custom_category_entity.dart';
import 'package:sana/features/azkar/domain/entities/zikr_entity.dart';
import 'package:sana/features/azkar/domain/repositories/azkar_repository.dart';
import 'package:sana/features/azkar/domain/repositories/custom_category_repository.dart';
import 'package:sana/features/azkar/domain/use_cases/get_azkar_categories_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_custom_categories_use_case.dart';
import 'package:sana/features/azkar/domain/use_cases/get_zikrs_by_category_use_case.dart';
import 'package:sana/features/azkar/presentation/cubits/categories/azkar_categories_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_tasbeeh_home/azkar/azkar_section_widget.dart';

void main() {
  testWidgets('section header does not duplicate the manage entry', (
    tester,
  ) async {
    final repository = _Repository();
    final cubit = _cubit(repository);
    await cubit.loadCategories();
    final visited = <String>[];

    await _pump(tester, cubit, visited);

    expect(find.text(AppStrings.azkarHeader), findsOneWidget);
    expect(find.text(AppStrings.manageCustomAzkar), findsNothing);
  });

  testWidgets('create action opens the form and reloads on save', (
    tester,
  ) async {
    final repository = _Repository();
    final cubit = _cubit(repository);
    await cubit.loadCategories();
    final visited = <String>[];

    await _pump(tester, cubit, visited);
    expect(repository.categoryCalls, 1);

    await tester.tap(find.text(AppStrings.addCustomAzkar));
    await tester.pumpAndSettle();

    expect(visited, contains(AppRoutes.customAzkarFormView));
    expect(repository.categoryCalls, 2);
  });
}

Future<void> _pump(
  WidgetTester tester,
  AzkarCategoriesCubit cubit,
  List<String> visited,
) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => BlocProvider.value(
          value: cubit,
          child: const Scaffold(
            body: CustomScrollView(slivers: [AzkarSectionWidget()]),
          ),
        ),
      ),
      GoRoute(
        path: '/manage',
        name: AppRoutes.customAzkarView,
        builder: (context, state) {
          visited.add(AppRoutes.customAzkarView);
          return const Scaffold(body: Text('manage-screen'));
        },
      ),
      GoRoute(
        path: '/form',
        name: AppRoutes.customAzkarFormView,
        builder: (context, state) {
          visited.add(AppRoutes.customAzkarFormView);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              context.pop(
                const CustomCategoryEntity(id: 'x', name: 'x', azkar: []),
              );
            }
          });
          return const Scaffold(body: Text('form-screen'));
        },
      ),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    MaterialApp.router(
      theme: AppTheme.light,
      routerConfig: router,
      builder: (context, child) {
        AppSize.init(context);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
    ),
  );
  await tester.pumpAndSettle();
}

AzkarCategoriesCubit _cubit(_Repository repository) => AzkarCategoriesCubit(
  GetAzkarCategoriesUseCase(repository),
  GetCustomCategoriesUseCase(const _CustomRepository()),
  GetZikrsByCategoryUseCase(repository),
);

class _Repository implements AzkarRepository {
  int categoryCalls = 0;

  @override
  Future<Result<List<AzkarCategoryEntity>>> getCategories() async {
    categoryCalls++;
    return const Result.success([]);
  }

  @override
  Future<Result<List<ZikrEntity>>> getZikrsByCategory(
    String categoryKey,
  ) async => const Result.success([]);
}

class _CustomRepository implements CustomCategoryRepository {
  const _CustomRepository();

  @override
  Future<Result<void>> deleteCustomCategory(String id) async =>
      const Result.success(null);

  @override
  Future<Result<CustomCategoryEntity?>> getCustomCategoryById(
    String id,
  ) async => const Result.success(null);

  @override
  Future<Result<List<CustomCategoryEntity>>> getCustomCategories() async =>
      const Result.success([]);

  @override
  Future<Result<void>> saveCustomCategory(
    CustomCategoryEntity category,
  ) async => const Result.success(null);
}
