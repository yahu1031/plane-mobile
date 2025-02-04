import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/widgets/custom_text.dart';

class TypeSheet extends ConsumerStatefulWidget {
  final Enum issueCategory;
  const TypeSheet({super.key, required this.issueCategory});

  @override
  ConsumerState<TypeSheet> createState() => _TypeSheetState();
}

class _TypeSheetState extends ConsumerState<TypeSheet> {
  var selected = 0;
  @override
  void initState() {
    dynamic prov = widget.issueCategory == IssueCategory.myIssues
        ? ref.read(ProviderList.myIssuesProvider)
        : ref.read(ProviderList.issuesProvider);
    selected = prov.issues.projectView == ProjectView.kanban
        ? 0
        : prov.issues.projectView == ProjectView.list
            ? 1
            : prov.issues.projectView == ProjectView.calendar
                ? 2
                : 3;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var prov = ref.watch(ProviderList.issuesProvider);
    var myIssuesProv = ref.watch(ProviderList.myIssuesProvider);
    var themeProvider = ref.watch(ProviderList.themeProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 23, left: 23, right: 23),
      child: Wrap(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Row(
                children: [
                  const CustomText(
                    'Layout',
                    type: FontStyle.H4,
                    fontWeight: FontWeightt.Semibold,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close,
                      size: 27,
                      color: themeProvider.themeManager.placeholderTextColor,
                    ),
                  ),
                ],
              ),
              Container(
                height: 10,
              ),
              // SizedBox(
              //   height: 50,
              //   width: double.infinity,
              //   child: InkWell(
              //     onTap: () {
              //       setState(() {
              //         selected = 1;
              //       });
              //     },
              //     child: Row(
              //       children: [
              //         Radio(
              //             visualDensity: const VisualDensity(
              //               horizontal: VisualDensity.minimumDensity,
              //               vertical: VisualDensity.minimumDensity,
              //             ),
              //             materialTapTargetSize:
              //                 MaterialTapTargetSize.shrinkWrap,
              //             fillColor: selected == 1
              //                 ? null
              //                 : MaterialStateProperty.all<Color>(
              //                     Colors.grey.shade300),
              //             groupValue: selected,
              //             activeColor: primaryColor,
              //             value: 1,
              //             onChanged: (val) {}),
              //         const SizedBox(width: 10),
              //         const CustomText(
              //           'List View',
              //           type: FontStyle.Small,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 1,
              //   width: double.infinity,
              //   child: Container(
              //     color: themeProvider.isDarkThemeEnabled
              //         ? darkThemeBorder
              //         : Colors.grey[300],
              //   ),
              // ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: InkWell(
                  onTap: () {
                    if (widget.issueCategory == IssueCategory.myIssues) {
                      myIssuesProv.issues.projectView = ProjectView.kanban;
                      myIssuesProv.setState();
                      myIssuesProv.updateMyIssueView();
                    } else {
                      prov.issues.projectView = ProjectView.kanban;
                      if (widget.issueCategory == IssueCategory.issues) {
                        prov.tempProjectView = ProjectView.kanban;
                      }
                      // prov.tempProjectView = ProjectView.kanban;
                      prov.setsState();
                      if (widget.issueCategory == IssueCategory.issues) {
                        prov.updateProjectView();
                      }
                    }

                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Radio(
                          visualDensity: const VisualDensity(
                            horizontal: VisualDensity.minimumDensity,
                            vertical: VisualDensity.minimumDensity,
                          ),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          fillColor: selected == 0
                              ? null
                              : MaterialStateProperty.all<Color>(themeProvider
                                  .themeManager.borderSubtle01Color),
                          groupValue: selected,
                          activeColor: themeProvider.themeManager.primaryColour,
                          value: 0,
                          onChanged: (val) {
                            if (widget.issueCategory ==
                                IssueCategory.myIssues) {
                              myIssuesProv.issues.projectView =
                                  ProjectView.kanban;
                              myIssuesProv.setState();
                              myIssuesProv.updateMyIssueView();
                            } else {
                              prov.issues.projectView = ProjectView.kanban;
                              prov.tempProjectView = ProjectView.kanban;
                              prov.setsState();
                              if (widget.issueCategory ==
                                  IssueCategory.issues) {
                                prov.updateProjectView();
                              }
                            }

                            Navigator.pop(context);
                          }),
                      const SizedBox(width: 10),
                      const CustomText(
                        'Board View',
                        type: FontStyle.H6,
                        //color: themeProvider.themeManager.tertiaryTextColor,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 1,
                width: double.infinity,
                child: Container(
                    color: themeProvider.themeManager.borderDisabledColor),
              ),

              SizedBox(
                height: 50,
                width: double.infinity,
                child: InkWell(
                  onTap: () {
                    if (widget.issueCategory == IssueCategory.myIssues) {
                      myIssuesProv.issues.projectView = ProjectView.list;
                      myIssuesProv.setState();
                      myIssuesProv.updateMyIssueView();
                    } else {
                      prov.issues.projectView = ProjectView.list;
                      if (widget.issueCategory == IssueCategory.issues) {
                        prov.tempProjectView = ProjectView.list;
                      }
                      prov.setsState();

                      if (widget.issueCategory == IssueCategory.issues) {
                        prov.updateProjectView();
                      }
                    }

                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Radio(
                          visualDensity: const VisualDensity(
                            horizontal: VisualDensity.minimumDensity,
                            vertical: VisualDensity.minimumDensity,
                          ),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          fillColor: selected == 1
                              ? null
                              : MaterialStateProperty.all<Color>(themeProvider
                                  .themeManager.borderSubtle01Color),
                          groupValue: selected,
                          activeColor: themeProvider.themeManager.primaryColour,
                          value: 1,
                          onChanged: (val) {
                            if (widget.issueCategory ==
                                IssueCategory.myIssues) {
                              myIssuesProv.issues.projectView =
                                  ProjectView.list;
                              myIssuesProv.setState();
                              myIssuesProv.updateMyIssueView();
                            } else {
                              prov.issues.projectView = ProjectView.list;
                              prov.tempProjectView = ProjectView.list;
                              prov.setsState();
                              if (widget.issueCategory ==
                                  IssueCategory.issues) {
                                prov.updateProjectView();
                              }
                            }

                            Navigator.pop(context);
                          }),
                      const SizedBox(width: 10),
                      const CustomText(
                        'List View',
                        type: FontStyle.H6,
                        //color: themeProvider.themeManager.tertiaryTextColor,
                      ),
                    ],
                  ),
                ),
              ),
              widget.issueCategory == IssueCategory.myIssues
                  ? Container()
                  : SizedBox(
                      height: 1,
                      width: double.infinity,
                      child: Container(
                        color: themeProvider.themeManager.borderDisabledColor,
                      ),
                    ),
              widget.issueCategory == IssueCategory.myIssues
                  ? Container()
                  : SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: InkWell(
                        onTap: () {
                          prov.issues.projectView = ProjectView.calendar;

                          if (widget.issueCategory == IssueCategory.issues) {
                            prov.tempProjectView = ProjectView.calendar;
                          }

                          prov.setsState();
                          if (widget.issueCategory == IssueCategory.issues) {
                            prov.updateProjectView();
                          }

                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Radio(
                                visualDensity: const VisualDensity(
                                  horizontal: VisualDensity.minimumDensity,
                                  vertical: VisualDensity.minimumDensity,
                                ),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                fillColor: selected == 2
                                    ? null
                                    : MaterialStateProperty.all<Color>(
                                        themeProvider
                                            .themeManager.borderSubtle01Color),
                                groupValue: selected,
                                activeColor:
                                    themeProvider.themeManager.primaryColour,
                                value: 2,
                                onChanged: (val) {
                                  prov.issues.projectView =
                                      ProjectView.calendar;
                                  prov.tempProjectView = ProjectView.calendar;

                                  prov.setsState();
                                  if (widget.issueCategory ==
                                      IssueCategory.issues) {
                                    prov.updateProjectView();
                                  }

                                  Navigator.pop(context);
                                }),
                            const SizedBox(width: 10),
                            const CustomText(
                              'Calendar View',
                              type: FontStyle.H6,
                              //color:themeProvider.themeManager.tertiaryTextColor,
                            ),
                          ],
                        ),
                      ),
                    ),
              widget.issueCategory == IssueCategory.myIssues
                  ? Container()
                  : SizedBox(
                      height: 1,
                      width: double.infinity,
                      child: Container(
                        color: themeProvider.themeManager.borderDisabledColor,
                      ),
                    ),
              widget.issueCategory == IssueCategory.myIssues
                  ? Container()
                  : SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: InkWell(
                        onTap: () {
                          prov.issues.projectView = ProjectView.spreadsheet;

                          if (widget.issueCategory == IssueCategory.issues) {
                            prov.tempProjectView = ProjectView.spreadsheet;
                          }

                          prov.setsState();
                          if (widget.issueCategory == IssueCategory.issues) {
                            prov.updateProjectView();
                          }

                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Radio(
                                visualDensity: const VisualDensity(
                                  horizontal: VisualDensity.minimumDensity,
                                  vertical: VisualDensity.minimumDensity,
                                ),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                fillColor: selected == 3
                                    ? null
                                    : MaterialStateProperty.all<Color>(
                                        themeProvider
                                            .themeManager.borderSubtle01Color),
                                groupValue: selected,
                                activeColor:
                                    themeProvider.themeManager.primaryColour,
                                value: 3,
                                onChanged: (val) {
                                  prov.issues.projectView =
                                      ProjectView.spreadsheet;
                                  prov.tempProjectView =
                                      ProjectView.spreadsheet;

                                  prov.setsState();
                                  if (widget.issueCategory ==
                                      IssueCategory.issues) {
                                    prov.updateProjectView();
                                  }

                                  Navigator.pop(context);
                                }),
                            const SizedBox(width: 10),
                            const CustomText(
                              'Spreadsheet View',
                              type: FontStyle.H6,
                              //color:themeProvider.themeManager.tertiaryTextColor,
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
          //long blue button to apply filter
          // Container(
          //   margin: const EdgeInsets.only(bottom: 18, top: 20),
          //   child: Button(
          //     text: 'Apply Filter',
          //     ontap: () {
          //       if (widget.issueCategory == IssueCategory.myIssues) {
          //         if (selected == 0) {
          //           myIssuesProv.issues.projectView = ProjectView.kanban;
          //         } else if (selected == 1) {
          //           myIssuesProv.issues.projectView = ProjectView.list;
          //         }
          //         myIssuesProv.setState();
          //         myIssuesProv.updateMyIssueView();
          //       } else {
          //         if (selected == 0) {
          //           prov.issues.projectView = ProjectView.kanban;
          //           prov.tempProjectView = ProjectView.kanban;
          //         } else if (selected == 1) {
          //           prov.issues.projectView = ProjectView.list;
          //           prov.tempProjectView = ProjectView.list;
          //         } else if (selected == 2) {
          //           prov.issues.projectView = ProjectView.calendar;
          //           prov.tempProjectView = ProjectView.calendar;
          //         } else if (selected == 3) {
          //           prov.issues.projectView = ProjectView.spreadsheet;
          //           prov.tempProjectView = ProjectView.spreadsheet;
          //         }
          //         prov.setsState();
          //         if (widget.issueCategory == IssueCategory.issues) {
          //           prov.updateProjectView();
          //         }
          //       }

          //       Navigator.pop(context);
          //     },
          //     textColor: Colors.white,
          //   ),
          // ),
        ],
      ),
    );
  }
}
