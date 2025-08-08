// ignore_for_file: use_build_context_synchronously

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class ViewStoreScreen extends ConsumerStatefulWidget {
  const ViewStoreScreen({super.key, required this.store});

  final StoreModel store;

  @override
  ConsumerState<ViewStoreScreen> createState() => _ViewStoreScreenState();
}

class _ViewStoreScreenState extends ConsumerState<ViewStoreScreen> {
  StoreModel? storeDetails;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      storeDetails = widget.store;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: CustomAppbar(
        title: "View Store",
      ),
      body: ListView(
        padding: EdgeInsets.only(
          left: Sizer.width(16),
          right: Sizer.width(16),
          bottom: Sizer.height(50),
        ),
        children: [
          YBox(16),
          Container(
            padding: EdgeInsets.all(Sizer.radius(16)),
            decoration: BoxDecoration(
              color: colorScheme.white,
              borderRadius: BorderRadius.circular(Sizer.radius(4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FilterHeader(
                  title: "Store Details",
                  subTitle: "See details of the selected subscription",
                  svgIcon: AppSvgs.circleMenu,
                  onFilter: () {
                    showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(100, 100, 0, 0),
                      items: [
                        (storeDetails?.status == "active")
                            ? PopupMenuItem(
                                value: 'deactivate',
                                child: Text('Deactivate Store',
                                    style: textTheme.text14?.copyWith(
                                      color: AppColors.red2D,
                                    )),
                              )
                            : PopupMenuItem(
                                value: 'activate',
                                child: Text('Activate Store',
                                    style: textTheme.text14),
                              ),
                      ],
                    ).then((value) {
                      // Handle the selected option
                      if (value != null) {
                        // Implement the action for the selected option
                        printty('Selected: $value');
                        switch (value) {
                          case 'deactivate':
                            final loadingProvider =
                                StateProvider<bool>((ref) => false);
                            ModalWrapper.bottomSheet(
                              context: context,
                              widget: Consumer(builder: (context, ref, child) {
                                final isLoading = ref.watch(loadingProvider);
                                return ConfirmationModal(
                                  modalConfirmationArg: ModalConfirmationArg(
                                    iconPath: AppSvgs.infoCircleRed,
                                    title: "Deactivate Store",
                                    description:
                                        "Are you sure you want to deactivate this store? Products in deactivated stores can not be sold?",
                                    solidBtnText: "Yes, deactivate",
                                    isLoading: isLoading,
                                    onSolidBtnOnTap: () async {
                                      // Set loading to true
                                      ref.read(loadingProvider.notifier).state =
                                          true;
                                      try {
                                        final res = await ref
                                            .read(storeVmodel)
                                            .updateStore(
                                              storeId: storeDetails?.id ?? "",
                                              isActive: false,
                                            );
                                        handleApiResponse(
                                            response: res,
                                            onSuccess: () async {
                                              Navigator.pop(context);
                                              await _getStoreDetails(
                                                  storeDetails?.id ?? "");
                                            });
                                      } finally {
                                        // Check if the widget is still mounted before using ref
                                        if (context.mounted) {
                                          ref
                                              .read(loadingProvider.notifier)
                                              .state = false;
                                        }
                                      }
                                    },
                                    onOutlineBtnOnTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                );
                              }),
                            );
                            break;
                          case 'activate':
                            _activateStore();
                            break;

                          default:
                            break;
                        }
                      }
                    });
                  },
                ),
                YBox(24),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(Sizer.radius(16)),
                  decoration: BoxDecoration(
                    color: AppColors.neutral3,
                    borderRadius: BorderRadius.circular(Sizer.radius(4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileColText(
                        title: "Store ID",
                        subTitle: storeDetails?.storeId ?? "N/A",
                      ),
                      YBox(16),
                      ProfileColText(
                        title: "Date Created",
                        subTitle: AppUtils.formatDateTime(
                            storeDetails?.dateCreated?.toLocal() ??
                                DateTime.now()),
                      ),
                      YBox(16),
                      Text(
                        "Status",
                        style: textTheme.text12?.copyWith(
                          color: AppColors.grey175,
                        ),
                      ),
                      YBox(4),
                      OrderStatus(
                        status: storeDetails?.status ?? "N/A",
                      ),
                      YBox(16),
                      ProfileColText(
                        title: "Address",
                        subTitle: storeDetails?.address ?? "N/A",
                      ),
                      YBox(16),
                      ProfileColText(
                        title: "Total Staff",
                        subTitle: storeDetails?.totalStaff?.toString() ?? "N/A",
                      ),
                      YBox(16),
                      ProfileColText(
                        title: "Total Registered Customers",
                        subTitle:
                            storeDetails?.totalCustomers?.toString() ?? "N/A",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _activateStore() async {
    final res = await ref.read(storeVmodel).updateStore(
          storeId: storeDetails?.id ?? "",
          isActive: true,
        );

    handleApiResponse(
        response: res,
        onSuccess: () async {
          await _getStoreDetails(storeDetails?.id ?? "");
          ref.read(storeVmodel).getStoreOverview();
        });
  }

  _getStoreDetails(String storeId) async {
    final res =
        await ref.read(storeVmodel).viewStoreDetails(storeDetails?.id ?? "");

    if (res.success) {
      storeDetails = res.data;
      setState(() {});
    }
  }
}
