import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  int indexStack = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationVmodel).getNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final notyVm = ref.watch(notificationVmodel);
    return Scaffold(
      appBar: CustomAppbar(
        title: "Notifications",
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: Sizer.width(16),
              right: Sizer.width(16),
              top: Sizer.height(20),
              bottom: Sizer.height(10),
            ),
            child: Row(
              children: [
                NotificationTab(
                  text: "All",
                  isSelected: indexStack == 0,
                  onTap: () {
                    indexStack = 0;
                    setState(() {});
                    notyVm.getNotifications();
                  },
                ),
                XBox(6),
                NotificationTab(
                  text: "Unread",
                  isSelected: indexStack == 1,
                  onTap: () {
                    indexStack = 1;
                    setState(() {});
                    notyVm.getNotifications(unread: true);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: indexStack,
              children: [
                LoadableContentBuilder(
                    isBusy: notyVm.isBusy,
                    isError: notyVm.hasError,
                    items: notyVm.allNotifications,
                    loadingBuilder: (p0) {
                      return SizerLoader(
                        height: double.infinity,
                      );
                    },
                    emptyBuilder: (context) {
                      return SizedBox(
                        height: Sizer.height(600),
                        child: EmptyListState(
                          text: "No Data",
                        ),
                      );
                    },
                    contentBuilder: (context) {
                      return ListView.separated(
                        shrinkWrap: true,
                        itemCount: notyVm.allNotifications.length,
                        padding: EdgeInsets.only(
                          left: Sizer.width(16),
                          right: Sizer.width(16),
                          top: Sizer.height(10),
                          bottom: Sizer.height(100),
                        ),
                        separatorBuilder: (_, __) => YBox(16),
                        itemBuilder: (_, i) {
                          final noty = notyVm.allNotifications[i];
                          return NotificationCard(
                            title: noty.subject ?? '',
                            message: noty.message ?? '',
                            time: AppUtils.getRelativeTime(
                                noty.createdAt ?? DateTime.now()),
                            onTap: () {},
                          );
                        },
                      );
                    }),
                LoadableContentBuilder(
                    isBusy: notyVm.isBusy,
                    isError: notyVm.hasError,
                    items: notyVm.unreadNotifications,
                    loadingBuilder: (p0) {
                      return SizerLoader(
                        height: double.infinity,
                      );
                    },
                    emptyBuilder: (context) {
                      return SizedBox(
                        height: Sizer.height(600),
                        child: EmptyListState(
                          text: "No Data",
                        ),
                      );
                    },
                    contentBuilder: (context) {
                      return ListView.separated(
                        shrinkWrap: true,
                        itemCount: notyVm.unreadNotifications.length,
                        padding: EdgeInsets.only(
                          left: Sizer.width(16),
                          right: Sizer.width(16),
                          top: Sizer.height(10),
                          bottom: Sizer.height(100),
                        ),
                        separatorBuilder: (_, __) => YBox(16),
                        itemBuilder: (_, i) {
                          final noty = notyVm.unreadNotifications[i];
                          return NotificationCard(
                            title: noty.subject ?? '',
                            message: noty.message ?? '',
                            time: AppUtils.getRelativeTime(
                                noty.createdAt ?? DateTime.now()),
                            onTap: () {},
                          );
                        },
                      );
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
