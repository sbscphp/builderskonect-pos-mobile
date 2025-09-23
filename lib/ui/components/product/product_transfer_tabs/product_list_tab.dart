import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class ProductListTab extends ConsumerStatefulWidget {
  const ProductListTab({super.key});

  @override
  ConsumerState<ProductListTab> createState() => _ProductListTabState();
}

class _ProductListTabState extends ConsumerState<ProductListTab> {
  @override
  Widget build(BuildContext context) {
    return _handleBuild();
  }

  Widget _handleBuild() {
    final vm = ref.watch(productTransferVm);
    switch (vm.transferProduct?.status) {
      case "request sent":
        return RequestSent(); //done
      case "action taken":
        return ActionTaken();
      case "pending":
        return Pending();
      default:
        return RequestSent(); //done
    }
  }
}

//widgets
class RequestSent extends ConsumerWidget {
  const RequestSent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final vm = ref.watch(productTransferVm);

    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Container(
          padding: EdgeInsets.all(Sizer.radius(16)),
          height: Sizer.screenHeight,
          decoration: BoxDecoration(
            color: colorScheme.white,
            borderRadius: BorderRadius.circular(Sizer.radius(4)),
          ),
          child: Column(
            children: [
              FilterHeader(title: "Product List"),
              YBox(16),
              ListView.separated(
                shrinkWrap: true,
                itemCount: vm.lineItems.length,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (_, __) => HDivider(),
                itemBuilder: (ctx, i) {
                  final product = vm.lineItems[i];
                  final ctr = TextEditingController(
                      text: product.quantity?.toString() ?? '0');
                  return TransferProductWidget(
                    productTitle: product.name ?? '---',
                    subTitle: '---',
                    productImage: product.primaryMediaUrl ?? '',
                    sku: product.sku ?? '---',
                    onChanged: (val) {},
                    controller: ctr,
                    enabled: false,
                    showStock: false,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Pending extends ConsumerWidget {
  const Pending({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final vm = ref.watch(productTransferVm);
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Container(
          padding: EdgeInsets.all(Sizer.radius(16)),
          height: Sizer.screenHeight,
          decoration: BoxDecoration(
            color: colorScheme.white,
            borderRadius: BorderRadius.circular(Sizer.radius(4)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      ModalWrapper.bottomSheet(
                        context: context,
                        widget: TakeTransferActionModal(),
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                          color: AppColors.primaryBlue,
                          borderRadius: BorderRadius.circular(6.r)),
                      child: Text(
                        "Take Action",
                        style: textTheme.text12
                            ?.copyWith(color: colorScheme.white),
                      ),
                    ),
                  )
                ],
              ),
              YBox(16),
              ListView.separated(
                shrinkWrap: true,
                itemCount: vm.lineItems.length,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                separatorBuilder: (_, __) => HDivider(),
                itemBuilder: (ctx, i) {
                  final product = vm.lineItems[i];

                  return ApproveRejectProductItem(
                    productTitle: product.name ?? '---',
                    subTitle: '---',
                    productImage: product.primaryMediaUrl ?? '',
                    status: product.status ?? '---',
                    qty: product.quantity?.toString() ?? '0',
                    sku: product.sku ?? '',
                    onTap: () {
                      if (vm.selectedActionProducts.contains(product)) {
                        vm.selectedActionProducts.remove(product);
                      } else {
                        vm.selectedActionProducts.add(product);
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ActionTaken extends ConsumerStatefulWidget {
  const ActionTaken({super.key});

  @override
  ConsumerState<ActionTaken> createState() => _ActionTakenState();
}

class _ActionTakenState extends ConsumerState<ActionTaken>
    with TickerProviderStateMixin {
  late Animation<double> _fadeAnimation;
  late AnimationController _tabController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _tabController,
      curve: Curves.easeInOut,
    ));
    _tabController.forward();
  }

  void _onTabChanged(int index) {
    if (currentIndex != index) {
      setState(() {
        currentIndex = index;
      });
    }
  }

  Widget _buildTabContent() {
    switch (currentIndex) {
      case 0:
        return approved();
      case 1:
        return rejected();
      default:
        return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final vm = ref.watch(productTransferVm);

    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Container(
          padding:
              EdgeInsets.only(left: Sizer.radius(16), right: Sizer.radius(16)),
          height: Sizer.screenHeight,
          decoration: BoxDecoration(
            color: colorScheme.white,
            borderRadius: BorderRadius.circular(Sizer.radius(4)),
          ),
          child: Column(
            children: [
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: Row(
                      children: [
                        ProfileTab(
                          title: "Approved",
                          isSelected: currentIndex == 0,
                          onTap: () => _onTabChanged(0),
                        ),
                        XBox(30),
                        ProfileTab(
                          title: "Rejected",
                          isSelected: currentIndex == 1,
                          onTap: () => _onTabChanged(1),
                        ),
                      ],
                    ),
                  );
                },
              ),
              if (currentIndex == 0 && (vm.lineItems.first.canReceive ?? false))
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        ModalWrapper.bottomSheet(
                          context: context,
                          widget: ConfirmationModal(
                            modalConfirmationArg: ModalConfirmationArg(
                              iconPath: AppSvgs.infoCircle,
                              title: "Receive Transfer",
                              description:
                                  "Are you sure you want to receive this stock transfer request? This action will mark the transfer request as received and adjust the stock levels. Do you want to proceed?",
                              solidBtnText: "Yes, receive",
                              // isLoading: vm.busy(createState),
                              onSolidBtnOnTap: () async {
                                Navigator.pop(context);
                                final response =
                                    await vm.updateTransferProduct("received");
                                handleApiResponse(
                                  response: response,
                                  onSuccess: () {
                                    ModalWrapper.bottomSheet(
                                      context: NavKey.appNavKey.currentContext!,
                                      canDismiss: false,
                                      widget: ConfirmationModal(
                                        modalConfirmationArg:
                                            ModalConfirmationArg(
                                          iconPath: AppSvgs.checkIcon,
                                          title: "Transfer Approved.",
                                          description:
                                              "The requesting store will be notified of this transfer approval.",
                                          solidBtnText: "Okay, good",
                                          onSolidBtnOnTap: () {
                                            // Get navigation context safely
                                            final navCtx =
                                                NavKey.appNavKey.currentContext;
                                            if (navCtx == null) return;

                                            Navigator.pop(navCtx);
                                            Navigator.pop(navCtx);
                                            Navigator.pop(navCtx);
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              onOutlineBtnOnTap: () {
                                Navigator.pop(
                                    NavKey.appNavKey.currentContext!, false);
                              },
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                            color: AppColors.primaryBlue,
                            borderRadius: BorderRadius.circular(6.r)),
                        child: Text(
                          "Mark as Received",
                          style: textTheme.text12
                              ?.copyWith(color: colorScheme.white),
                        ),
                      ),
                    )
                  ],
                ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.1, 0.0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeInOut,
                      )),
                      child: child,
                    ),
                  );
                },
                child: Container(
                  key: ValueKey<int>(currentIndex),
                  child: _buildTabContent(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget approved() {
    final vm = ref.watch(productTransferVm);

    if (vm.approvedItems.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 100.0),
        child: EmptyListState(text: "No Product"),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      itemCount: vm.approvedItems.length,
      padding: EdgeInsets.only(top: 12),
      physics: NeverScrollableScrollPhysics(),
      separatorBuilder: (_, __) => HDivider(),
      itemBuilder: (ctx, i) {
        final product = vm.approvedItems[i];

        return ApproveRejectProductItem(
          productTitle: product.name ?? '---',
          subTitle: '---',
          productImage: product.primaryMediaUrl ?? '',
          status: product.status ?? '---',
          qty: product.quantity?.toString() ?? '',
          onTap: () {
            if (vm.selectedActionProducts.contains(product)) {
              vm.selectedActionProducts.remove(product);
            } else {
              vm.selectedActionProducts.add(product);
            }
            setState(() {});
          },
        );
      },
    );
  }

  Widget rejected() {
    final vm = ref.watch(productTransferVm);
    if (vm.rejectedItems.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 100.0),
        child: EmptyListState(text: "No Product"),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      itemCount: vm.rejectedItems.length,
      padding: EdgeInsets.only(top: 12),
      physics: NeverScrollableScrollPhysics(),
      separatorBuilder: (_, __) => HDivider(),
      itemBuilder: (ctx, i) {
        final product = vm.rejectedItems[i];

        return ApproveRejectProductItem(
          productTitle: product.name ?? '---',
          subTitle: '---',
          productImage: product.primaryMediaUrl ?? '',
          status: product.status ?? '---',
          qty: product.quantity?.toString() ?? '',
        );
      },
    );
  }
}
