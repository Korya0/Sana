import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/common/widgets/app_error_view.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/features/azkar/presentation/controller/azkar_category_loader_cubit.dart';
import 'package:sana/features/azkar/presentation/views/azkar_list_view.dart';

class AzkarDetailsLoaderView extends StatelessWidget {
  const AzkarDetailsLoaderView({required this.categoryId, super.key});
  final String categoryId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = sl<AzkarCategoryLoaderCubit>();
        unawaited(cubit.loadCategory(categoryId));
        return cubit;
      },
      child: BlocBuilder<AzkarCategoryLoaderCubit, AzkarCategoryLoaderState>(
        builder: (context, state) {
          if (state is AzkarCategoryLoaderLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (state is AzkarCategoryLoaderError) {
            return Scaffold(
              appBar: AppBar(), // Provide a way to go back
              body: AppErrorView(
                message: state.message,
                onRetry: () => context
                    .read<AzkarCategoryLoaderCubit>()
                    .loadCategory(categoryId),
              ),
            );
          }

          if (state is AzkarCategoryLoaderLoaded) {
            return AzkarListView(category: state.category);
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
