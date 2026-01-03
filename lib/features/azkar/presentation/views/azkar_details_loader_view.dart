import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sana/core/di/service_locator.dart';
import 'package:sana/features/azkar/presentation/cubit/azkar_category_loader_cubit.dart';
import 'package:sana/features/azkar/presentation/views/azkar_list_view.dart';

class AzkarDetailsLoaderView extends StatelessWidget {
  final String categoryId;

  const AzkarDetailsLoaderView({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<AzkarCategoryLoaderCubit>()..loadCategory(categoryId),
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
              body: Center(child: Text(state.message)),
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
