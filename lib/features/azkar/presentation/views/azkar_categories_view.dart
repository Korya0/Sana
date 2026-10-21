import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/constants/app_sizes.dart';
import 'package:sana/core/di/app_injector.dart';
import 'package:sana/features/azkar/presentation/cubits/categories/azkar_categories_cubit.dart';
import 'package:sana/features/azkar/presentation/widgets/azkar_categories_section.dart';

class AzkarCategoriesView extends StatelessWidget {
  const AzkarCategoriesView({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) {
      final cubit = sl<AzkarCategoriesCubit>();
      unawaited(cubit.loadCategories());
      return cubit;
    },
    child: Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Categories
            SliverPadding(
              padding: EdgeInsets.only(top: AppSize.stp),
              sliver: const AzkarCategoriesSection(),
            ),
          ],
        ),
      ),
    ),
  );
}
