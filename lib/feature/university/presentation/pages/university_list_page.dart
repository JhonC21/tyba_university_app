import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tyba_university_app/core/const/const.dart';
import 'package:tyba_university_app/feature/university/domain/entitie/university.dart';
import 'package:tyba_university_app/feature/university/presentation/bloc/university_bloc.dart';
import 'package:tyba_university_app/feature/university/presentation/widgets/university_detail_page.dart';
import 'package:tyba_university_app/injection_container.dart';
import 'package:tyba_university_app/shared/utils/responsive.dart';

class UniversityListPage extends StatelessWidget {
  const UniversityListPage({super.key});

  static const String path = '/universities';
  static const String routeName = 'universities';

  @override
  Widget build(BuildContext context) {
    // Responsive entity for responsive design
    final Responsive responsive = Responsive(context);
    final scrollController = ScrollController();

    return BlocProvider(
      create: (context) =>
          sl<UniversityBloc>()..add(const UniversityEvent.initialize()),
      child: BlocBuilder<UniversityBloc, UniversityState>(
        builder: (context, state) {
          return state.map(
            loading: (value) =>
                const Center(child: CircularProgressIndicator()),
            failed: (value) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: responsive.dp(20)),
                  ElevatedButton(
                    onPressed: () => context.read<UniversityBloc>().add(
                          const UniversityEvent.initialize(),
                        ),
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            ),
            loaded: (value) {
              return Scaffold(
                body: Padding(
                  padding: EdgeInsets.only(
                      top: responsive.dp(8),
                      left: responsive.dp(1),
                      right: responsive.dp(1)),
                  child: Column(
                    children: [
                      Text(
                          'Universities list - length: ${value.universities.length}',
                          style: TextStyle(fontSize: responsive.fp(25))),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: responsive.dp(5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Change view mode: '),
                            Switch(
                              value: value.listMode == ListMode.gridView,
                              onChanged: (value) {
                                context.read<UniversityBloc>().add(
                                    const UniversityEvent.changeViewMode());
                              },
                            ),
                            Text(value.listMode == ListMode.gridView
                                ? Const.gridView
                                : Const.listView),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: responsive.dp(50),
                          child: NotificationListener<ScrollNotification>(
                            onNotification: (notification) {
                              if (notification is ScrollEndNotification &&
                                  scrollController.position.pixels ==
                                      scrollController
                                          .position.maxScrollExtent &&
                                  !value.isLoadingMore &&
                                  !value.hasReachedMax) {
                                context
                                    .read<UniversityBloc>()
                                    .add(const UniversityEvent.loadMore());
                              }
                              return false;
                            },
                            child: Column(
                              children: [
                                Expanded(
                                  child: value.listMode == ListMode.gridView
                                      ? Column(
                                          children: [
                                            Expanded(
                                              child: GridView.builder(
                                                controller: scrollController,
                                                padding: EdgeInsets.all(
                                                    responsive.dp(1)),
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  childAspectRatio: 1.5,
                                                ),
                                                itemCount:
                                                    value.universities.length,
                                                itemBuilder: (context, index) {
                                                  return Card(
                                                    child: InkWell(
                                                      onTap: () =>
                                                          _navigateToDetail(
                                                              context,
                                                              value.universities[
                                                                  index]),
                                                      child: Center(
                                                        child: Text(
                                                          value
                                                              .universities[
                                                                  index]
                                                              .name,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            if (value.isLoadingMore)
                                              SizedBox(
                                                height: responsive.dp(20),
                                                child: const Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                              ),
                                          ],
                                        )
                                      : ListView.builder(
                                          controller: scrollController,
                                          padding:
                                              EdgeInsets.all(responsive.dp(1)),
                                          itemCount: value.universities.length +
                                              (value.isLoadingMore ? 1 : 0),
                                          itemBuilder: (context, index) {
                                            if (index >=
                                                value.universities.length) {
                                              return Center(
                                                  child: Padding(
                                                padding: EdgeInsets.all(
                                                    responsive.dp(4)),
                                                child:
                                                    const CircularProgressIndicator(),
                                              ));
                                            }
                                            return Card(
                                              child: ListTile(
                                                title: Text(value
                                                    .universities[index].name),
                                                onTap: () => _navigateToDetail(
                                                    context,
                                                    value.universities[index]),
                                              ),
                                            );
                                          },
                                        ),
                                ),
                                if (value.hasReachedMax &&
                                    value.universities.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.all(responsive.dp(2)),
                                    child: const Text(
                                        'You have reached the end of the list'),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _navigateToDetail(BuildContext context, University university) {
    final bloc = context.read<UniversityBloc>();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: bloc,
          child: UniversityDetailPage(university: university),
        ),
      ),
    );
  }
}
