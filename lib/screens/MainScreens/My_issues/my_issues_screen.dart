import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/bottom_sheets/filter_sheet.dart';
import 'package:plane/bottom_sheets/global_search_sheet.dart';
import 'package:plane/bottom_sheets/views_and_layout_sheet.dart';
import 'package:plane/kanban/custom/board.dart';
import 'package:plane/kanban/models/inputs.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/IssuesTab/create_issue.dart';

import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_app_bar.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:plane/widgets/empty.dart';
import 'package:plane/widgets/loading_widget.dart';

class MyIssuesScreen extends ConsumerStatefulWidget {
  const MyIssuesScreen({super.key});

  @override
  ConsumerState<MyIssuesScreen> createState() => _MyIssuesScreenState();
}

class _MyIssuesScreenState extends ConsumerState<MyIssuesScreen> {
  final PageController controller = PageController(initialPage: 0);
  int selected = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.watch(ProviderList.myIssuesProvider).pageIndex != 0) {
        ref.read(ProviderList.myIssuesProvider).changePage(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var myIssuesProvider = ref.watch(ProviderList.myIssuesProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var workspaceProvider = ref.watch(ProviderList.workspaceProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    return SafeArea(
      child: Scaffold(
          appBar: CustomAppBar(
            text: 'My Issues',
            onPressed: () {},
            leading: false,
            elevation: false,
            centerTitle: false,
            fontType: FontStyle.H4,
            actions: [
              workspaceProvider.role != Role.admin &&
                      workspaceProvider.role != Role.member
                  ? Container()
                  : GestureDetector(
                      onTap: () async {
                        if (ref
                            .watch(ProviderList.projectProvider)
                            .projects
                            .isEmpty) {
                          CustomToast.showToast(
                            context,
                            message:
                                'You dont have any projects yet, try creating one',
                          );
                        } else {
                          ref
                                  .watch(ProviderList.projectProvider)
                                  .currentProject =
                              ref
                                  .watch(ProviderList.projectProvider)
                                  .projects[0];
                          ref.watch(ProviderList.projectProvider).setState();
                          // await ref
                          //     .read(ProviderList.projectProvider)
                          //     .initializeProject(ref: ref);
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateIssue(
                                projectId: ref
                                    .watch(ProviderList.projectProvider)
                                    .projects[0]['id'],
                                fromMyIssues: true,
                              ),
                            ),
                          );
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor: themeProvider
                            .themeManager.primaryBackgroundSelectedColour,
                        radius: 20,
                        child: Icon(
                          size: 20,
                          Icons.add,
                          color: themeProvider.themeManager.secondaryTextColor,
                        ),
                      ),
                    ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      enableDrag: true,
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.9),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )),
                      context: context,
                      builder: (ctx) {
                        return const ViewsAndLayoutSheet(
                          issueCategory: IssueCategory.myIssues,
                        );
                      });
                },
                child: CircleAvatar(
                  backgroundColor: themeProvider
                      .themeManager.primaryBackgroundSelectedColour,
                  radius: 20,
                  child: Icon(
                    size: 20,
                    Icons.view_list_outlined,
                    color: themeProvider.themeManager.secondaryTextColor,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      enableDrag: true,
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.85),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )),
                      context: context,
                      builder: (ctx) {
                        return FilterSheet(
                          issueCategory: IssueCategory.myIssues,
                        );
                      });
                },
                child: Stack(
                  children: [
                    Center(
                      child: CircleAvatar(
                        backgroundColor: themeProvider
                            .themeManager.primaryBackgroundSelectedColour,
                        radius: 20,
                        child: Icon(
                          size: 20,
                          Icons.filter_list_outlined,
                          color: themeProvider.themeManager.secondaryTextColor,
                        ),
                      ),
                    ),

                    // blue dot
                    (myIssuesProvider.issues.filters.priorities.isEmpty &&
                            myIssuesProvider.issues.filters.states.isEmpty &&
                            myIssuesProvider.issues.filters.labels.isEmpty &&
                            myIssuesProvider
                                .issues.filters.targetDate.isEmpty &&
                            myIssuesProvider.issues.filters.startDate.isEmpty)
                        ? Container()
                        : Positioned(
                            top: 4,
                            right: 4,
                            child: Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                color: themeProvider.themeManager.primaryColour,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GlobalSearchSheet(),
                    ),
                  );
                },
                child: CircleAvatar(
                  backgroundColor: themeProvider
                      .themeManager.primaryBackgroundSelectedColour,
                  radius: 20,
                  child: Icon(
                    size: 20,
                    Icons.search,
                    color: themeProvider.themeManager.secondaryTextColor,
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
          body: projectProvider.projects.isEmpty
              ? EmptyPlaceholder.emptyProject(context, ref)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      //bottom border
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color:
                                themeProvider.themeManager.borderSubtle01Color,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                controller.jumpToPage(0);
                              },
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: CustomText(
                                          'Assigned',
                                          color: selected == 0
                                              ? themeProvider
                                                  .themeManager.primaryColour
                                              : themeProvider.themeManager
                                                  .placeholderTextColor,
                                          overrride: true,
                                          type: FontStyle.Medium,
                                        ),
                                      ),
                                    ],
                                  ),
                                  selected == 0
                                      ? Container(
                                          height: 6,
                                          color: themeProvider
                                              .themeManager.primaryColour,
                                        )
                                      : Container(
                                          height: 6,
                                        )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                controller.jumpToPage(1);
                              },
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: CustomText(
                                          'Created',
                                          overrride: true,
                                          color: selected == 1
                                              ? themeProvider
                                                  .themeManager.primaryColour
                                              : themeProvider.themeManager
                                                  .placeholderTextColor,
                                          type: FontStyle.Medium,
                                        ),
                                      ),
                                    ],
                                  ),
                                  selected == 1
                                      ? Container(
                                          height: 6,
                                          color: themeProvider
                                              .themeManager.primaryColour,
                                        )
                                      : Container(
                                          height: 6,
                                        )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                controller.jumpToPage(2);
                              },
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: CustomText(
                                          'Subscribed',
                                          color: selected == 2
                                              ? themeProvider
                                                  .themeManager.primaryColour
                                              : themeProvider.themeManager
                                                  .placeholderTextColor,
                                          overrride: true,
                                          type: FontStyle.Medium,
                                        ),
                                      ),
                                    ],
                                  ),
                                  selected == 2
                                      ? Container(
                                          height: 6,
                                          color: themeProvider
                                              .themeManager.primaryColour,
                                        )
                                      : Container(
                                          height: 6,
                                        ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: PageView(
                        //disable swipe
                        physics: const NeverScrollableScrollPhysics(),
                        controller: controller,
                        onPageChanged: (value) {
                          setState(() {
                            selected = value;
                            myIssuesProvider.changePage(value);
                          });
                        },
                        children: [
                          issues(context, ref),
                          issues(context, ref),
                          issues(context, ref),
                        ],
                      ),
                    ),
                  ],
                )),
    );
  }

  Widget issues(BuildContext context, WidgetRef ref) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var issueProvider = ref.watch(ProviderList.myIssuesProvider);
    var projectProvider = ref.watch(ProviderList.projectProvider);
    // log(issueProvider.issueState.name);
    if (issueProvider.issues.projectView == ProjectView.list) {
      issueProvider.initializeBoard();
    }

    return LoadingWidget(
      loading: issueProvider.myIssuesViewState == StateEnum.loading ||
          issueProvider.myIssuesFilterState == StateEnum.loading,
      widgetClass: Container(
        color: themeProvider.themeManager.secondaryBackgroundDefaultColor,
        padding: issueProvider.issues.projectView == ProjectView.kanban
            ? const EdgeInsets.only(top: 15, left: 0)
            : null,
        child: issueProvider.myIssuesViewState == StateEnum.loading
            ? Container()
            : issueProvider.isISsuesEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      issueProvider.pageIndex == 2
                          ? EmptyPlaceholder.emptySubscribedIssue(ref)
                          : EmptyPlaceholder.emptyIssues(
                              context,
                              ref: ref,
                              type: IssueCategory.myIssues,
                              assignee: issueProvider.pageIndex == 0
                                  ? {
                                      ref
                                          .watch(ProviderList.profileProvider)
                                          .userProfile
                                          .id!: {
                                        'name':
                                            "${ref.watch(ProviderList.profileProvider).userProfile.firstName} ${ref.watch(ProviderList.profileProvider).userProfile.lastName}",
                                        'id': ref
                                            .watch(ProviderList.profileProvider)
                                            .userProfile
                                            .id,
                                      }
                                    }
                                  : null,
                            ),
                    ],
                  )
                : issueProvider.issues.projectView == ProjectView.list
                    ? Container(
                        color: themeProvider
                            .themeManager.secondaryBackgroundDefaultColor,
                        margin: const EdgeInsets.only(top: 5),
                        child: SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: issueProvider.issues.issues
                                  .map((state) => state.items.isEmpty &&
                                          !issueProvider.showEmptyStates
                                      ? Container()
                                      : SizedBox(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    left: 15),
                                                margin: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: Row(
                                                  children: [
                                                    state.leading ??
                                                        Container(),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        left: 10,
                                                      ),
                                                      child: CustomText(
                                                        state.title!,
                                                        type: FontStyle.Large,
                                                        color: themeProvider
                                                            .themeManager
                                                            .primaryTextColor,
                                                        fontWeight: FontWeightt
                                                            .Semibold,
                                                      ),
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      margin:
                                                          const EdgeInsets.only(
                                                        left: 7,
                                                      ),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          color: themeProvider
                                                              .themeManager
                                                              .tertiaryBackgroundDefaultColor),
                                                      height: 25,
                                                      width: 30,
                                                      child: CustomText(
                                                        state.items.length
                                                            .toString(),
                                                        type: FontStyle.Small,
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    IconButton(
                                                        onPressed: () {
                                                          if (issueProvider
                                                                  .issues
                                                                  .groupBY ==
                                                              GroupBY.state) {
                                                            issueProvider
                                                                    .createIssuedata[
                                                                'state'] = state.id;
                                                          } else {
                                                            issueProvider
                                                                        .createIssuedata[
                                                                    'prioriry'] =
                                                                'de3c90cd-25cd-42ec-ac6c-a66caf8029bc';
                                                            // createIssuedata['s'] = element.id;
                                                          }
                                                          projectProvider
                                                                  .currentProject =
                                                              projectProvider
                                                                  .projects[0];
                                                          projectProvider
                                                              .setState();
                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder: (ctx) =>
                                                                      CreateIssue(
                                                                        projectId:
                                                                            projectProvider.projects[0]['id'],
                                                                        fromMyIssues:
                                                                            true,
                                                                      )));
                                                        },
                                                        icon: Icon(
                                                          Icons.add,
                                                          color: themeProvider
                                                              .themeManager
                                                              .tertiaryTextColor,
                                                        )),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: state.items
                                                      .map((e) => e)
                                                      .toList()),
                                              state.items.isEmpty
                                                  ? Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 10),
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      color: themeProvider
                                                          .themeManager
                                                          .primaryBackgroundDefaultColor,
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 15,
                                                              bottom: 15,
                                                              left: 15),
                                                      child: const CustomText(
                                                        'No issues.',
                                                        type: FontStyle.Small,
                                                        maxLines: 10,
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                    )
                                                  : Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 10),
                                                    )
                                            ],
                                          ),
                                        ))
                                  .toList()),
                        ),
                      )
                    : KanbanBoard(
                        issueProvider.initializeBoard(),
                        groupEmptyStates: !issueProvider.showEmptyStates,
                        backgroundColor: themeProvider
                            .themeManager.secondaryBackgroundDefaultColor,
                        isCardsDraggable:
                            issueProvider.checkIsCardsDaraggable(),
                        onItemReorder: (
                            {newCardIndex,
                            newListIndex,
                            oldCardIndex,
                            oldListIndex}) {
                          //  print('newCardIndex: $newCardIndex, newListIndex: $newListIndex, oldCardIndex: $oldCardIndex, oldListIndex: $oldListIndex');
                          issueProvider
                              .reorderIssue(
                            newCardIndex: newCardIndex!,
                            newListIndex: newListIndex!,
                            oldCardIndex: oldCardIndex!,
                            oldListIndex: oldListIndex!,
                          )
                              .then((value) {
                            if (issueProvider.issues.orderBY !=
                                OrderBY.manual) {
                              CustomToast.showToast(context,
                                  message:
                                      'This board is ordered by ${issueProvider.issues.orderBY == OrderBY.lastUpdated ? 'last updated' : 'created at'} ',
                                  toastType: ToastType.warning);
                            }
                          }).catchError((e) {
                            CustomToast.showToast(context,
                                message: 'Failed to update issue',
                                toastType: ToastType.failure);
                          });
                        },
                        cardPlaceHolderColor: themeProvider
                            .themeManager.primaryBackgroundDefaultColor,
                        cardPlaceHolderDecoration: BoxDecoration(
                            color: themeProvider
                                .themeManager.primaryBackgroundDefaultColor,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 2,
                                color: themeProvider
                                    .themeManager.borderSubtle01Color,
                                spreadRadius: 0,
                              )
                            ]),
                        listScrollConfig: ScrollConfig(
                            offset: 65,
                            duration: const Duration(milliseconds: 100),
                            curve: Curves.linear),
                        listTransitionDuration:
                            const Duration(milliseconds: 200),
                        cardTransitionDuration:
                            const Duration(milliseconds: 400),
                      ),
      ),
    );
  }
}
