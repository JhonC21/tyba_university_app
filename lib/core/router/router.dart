import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tyba_university_app/feature/university/domain/entitie/university.dart';
import 'package:tyba_university_app/feature/university/presentation/pages/university_list_page.dart';
import 'package:tyba_university_app/feature/university/presentation/widgets/university_detail_page.dart';
import 'package:tyba_university_app/main.dart';

// Class for manage routes
mixin RouterMixin on State<MyApp> {
  late final GoRouter router;

  @override
  void initState() {
    super.initState();
    router = GoRouter(
      initialLocation: UniversityListPage.path,
      routes: <RouteBase>[
        GoRoute(
          path: UniversityListPage.path,
          name: UniversityListPage.routeName,
          builder: (BuildContext context, GoRouterState state) {
            return const UniversityListPage();
          },
          routes: [
            GoRoute(
              path: 'detail',
              name: UniversityDetailPage.routeName,
              builder: (BuildContext context, GoRouterState state) {
                final university = state.extra as University;
                return UniversityDetailPage(university: university);
              },
            ),
          ],
        ),
      ],
    );
  }
}
