import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';
import 'package:builders_konnect/ui/screens/screens.dart';

class StaffManagementScreen extends ConsumerStatefulWidget {
  const StaffManagementScreen({super.key});

  @override
  ConsumerState<StaffManagementScreen> createState() =>
      _StaffManagementScreenState();
}

class _StaffManagementScreenState extends ConsumerState<StaffManagementScreen> {
  final searchC = TextEditingController();
  final _scrollController = ScrollController();
  int indexStack = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchStaffDashboardData();
      _scrollListener();
    });
  }

  @override
  void dispose() {
    searchC.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  _scrollListener() {
    final vm = ref.watch(staffVm);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!vm.busy(paginateState) && vm.pageNumber <= (vm.lastPage ?? 1)) {
          vm.getDashboardStats(busyObjectName: paginateState);
        }
      }
    });
  }

  _fetchStaffDashboardData() async {
    ref.read(staffVm).getDashboardStats(busyObjectName: firstState);
    ref.read(roleVm).getAvailableRoles();
    ref.read(roleVm).fetchRoles();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // final colorScheme = Theme.of(context).colorScheme;
    final staffViewModel = ref.watch(staffVm);
    return Scaffold(
      appBar: CustomAppbar(title: "Staff Management"),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (indexStack == 0) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NewStaffScreen()));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewRolesPermissionScreen()));
          }
        },
        tooltip: indexStack == 0 ? "Add Staff" : "Add Role and Permission",
        child: Icon(Icons.add),
      ),
      body: !staffViewModel.hasAccessToStaff
          ? RequestAccessWidget(
              isLoading: staffViewModel.busy(RowParams.staff),
              onRequestAccess: () async {
                final res = await staffViewModel
                    .requestApplicationAccess(RowParams.staff);
                handleApiResponse(response: res);
              },
            )
          : LoadableContentBuilder(
              isBusy: staffViewModel.busy(getState),
              isError: staffViewModel.error(getState),
              loadingBuilder: (p0) {
                return SizerLoader(
                  height: double.infinity,
                );
              },
              emptyBuilder: (context) {
                return Center(
                  child: Text(
                    "No Data",
                    style: textTheme.text14?.medium.copyWith(
                      color: AppColors.gray500,
                    ),
                  ),
                );
              },
              contentBuilder: (context) {
                return SizedBox(
                  height: Sizer.screenHeight,
                  width: Sizer.screenWidth,
                  child: BusyOverlay(
                    show: staffViewModel.busy(firstState),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        _fetchStaffDashboardData();
                      },
                      child: ListView(
                        controller: _scrollController,
                        padding: EdgeInsets.only(
                          left: Sizer.width(16),
                          right: Sizer.width(16),
                          bottom: Sizer.height(50),
                        ),
                        children: [
                          YBox(16),
                          Row(
                            children: [
                              NotificationTab(
                                text: "Staff",
                                isSelected: indexStack == 0,
                                onTap: () {
                                  indexStack = 0;
                                  setState(() {});
                                  // notyVm.getNotifications();
                                },
                              ),
                              XBox(6),
                              NotificationTab(
                                text: "Roles and Permissions",
                                isSelected: indexStack == 1,
                                onTap: () {
                                  indexStack = 1;
                                  setState(() {});
                                  // notyVm.getNotifications(unread: true);
                                },
                              ),
                            ],
                          ),
                          YBox(16),
                          IndexedStack(
                            index: indexStack,
                            children: [
                              StaffTab(),
                              RolePermissionTab(),
                            ],
                          ),
                          if (staffViewModel.busy(paginateState))
                            SpinKitLoader(
                              size: 16,
                              color: AppColors.neutral5,
                            ),
                          if (staffViewModel.error(paginateState))
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: ErrorState(
                                onPressed: () {
                                  staffViewModel.getDashboardStats(
                                      busyObjectName: paginateState);
                                },
                                isPaginationType: true,
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
