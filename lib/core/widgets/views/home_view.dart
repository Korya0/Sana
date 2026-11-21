import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sana/core/constants/app_strings.dart';
import 'package:sana/core/router/app_routes.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.volunteer_activism_outlined),
                title: const Text(AppStrings.zakatTitle),
                subtitle: const Text(AppStrings.zakatSubtitle),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => context.push(AppRoutes.zakatHome),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
