import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class CustomersManagementScreen extends ConsumerStatefulWidget {
  const CustomersManagementScreen({super.key});

  @override
  ConsumerState<CustomersManagementScreen> createState() =>
      _CustomersManagementScreenState();
}

class _CustomersManagementScreenState
    extends ConsumerState<CustomersManagementScreen>
    with TickerProviderStateMixin {
  int currentIndex = 0;
  late AnimationController _tabController;
  late Animation<double> _fadeAnimation;
  final searchC = TextEditingController();

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // ref.read(storeVmodel).getStoreOverview();
    });
  }

  void _onTabChanged(int index) {
    if (currentIndex != index) {
      setState(() {
        currentIndex = index;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    searchC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final storeVm = ref.watch(storeVmodel);
    return Scaffold(
      appBar: CustomAppbar(
        title: "Customers Management",
        trailingWidget: InkWell(
          child: SvgPicture.asset(AppSvgs.menu),
        ),
      ),
      body: Column(
        children: [
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: Sizer.width(16)),
                  color: colorScheme.white,
                  child: Row(
                    children: [
                      ProfileTab(
                        title: "All Customers",
                        isSelected: currentIndex == 0,
                        onTap: () => _onTabChanged(0),
                      ),
                      XBox(30),
                      ProfileTab(
                        title: "Online",
                        isSelected: currentIndex == 1,
                        onTap: () => _onTabChanged(1),
                      ),
                      XBox(30),
                      ProfileTab(
                        title: "Walk-in",
                        isSelected: currentIndex == 2,
                        onTap: () => _onTabChanged(2),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: LoadableContentBuilder(
              isBusy: storeVm.busy(getState),
              isError: storeVm.error(getState),
              loadingBuilder: (p0) {
                return SizerLoader(
                  height: double.infinity,
                );
              },
              errorBuilder: (context) {
                return ErrorState(
                  onPressed: () {
                    // ref.read(storeVmodel).getStoreOverview();
                  },
                );
              },
              contentBuilder: (context) {
                return ListView(
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
                            title: "Customer Overview",
                            subTitle: "Manage online and walk-in customers",
                            svgIcon: AppSvgs.circleAdd,
                            trailingWidget: NewButtonWidget(
                              onTap: () {
                                // Navigator.pushNamed(
                                //     context, RoutePath.newStoreScreen);
                              },
                            ),
                          ),
                          YBox(16),
                          Container(
                            width: double.infinity,
                            height: Sizer.height(140),
                            padding: EdgeInsets.all(Sizer.radius(16)),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.blueDD9),
                              borderRadius:
                                  BorderRadius.circular(Sizer.radius(4)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ProductColText(
                                  title: "TOTAL CUSTOMERS",
                                  value: storeVm.stats?.total.toString() ?? '0',
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ProductColText(
                                      textColor: colorScheme.black85,
                                      title: "Online Customers",
                                      value: storeVm.stats?.active.toString() ??
                                          '0',
                                      valueTextSize: 12,
                                      valueColor: AppColors.primaryBlue,
                                    ),
                                    ProductColText(
                                      textColor: colorScheme.black85,
                                      title: "Walk-in Customers",
                                      value:
                                          storeVm.stats?.inactive.toString() ??
                                              '0',
                                      valueTextSize: 12,
                                      valueColor: AppColors.purple6,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          YBox(40),
                          FilterHeader(
                            title: "All Customers",
                            subTitle:
                                "See all customers that hav returns your business",
                            onFilter: () async {},
                          ),
                          YBox(16),
                          CustomTextField(
                            controller: searchC,
                            isRequired: false,
                            showLabelHeader: false,
                            hintText: "Search by customer ID, name etc",
                            onChanged: (value) {
                              setState(() {});
                            },
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (searchC.text.isNotEmpty)
                                  InkWell(
                                    onTap: () {},
                                    child: Padding(
                                      padding: EdgeInsets.all(Sizer.width(10)),
                                      child: Icon(
                                        Icons.close,
                                        size: Sizer.width(20),
                                        color: AppColors.gray500,
                                      ),
                                    ),
                                  ),
                                InkWell(
                                  onTap: () {},
                                  child: Container(
                                    padding: EdgeInsets.all(Sizer.width(10)),
                                    decoration: BoxDecoration(
                                        border: Border(
                                      left: BorderSide(
                                        color: AppColors.neutral5,
                                      ),
                                    )),
                                    child: SvgPicture.asset(AppSvgs.search),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Builder(builder: (context) {
                            if (10 == 0) {
                              return SizedBox(
                                height: Sizer.height(300),
                                child: EmptyListState(
                                  text: "No Data",
                                ),
                              );
                            }
                            return Column(
                              children: [
                                YBox(10),
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.only(
                                    top: Sizer.height(14),
                                    bottom: Sizer.height(50),
                                  ),
                                  itemCount: 10,
                                  separatorBuilder: (_, __) => HDivider(),
                                  itemBuilder: (ctx, i) {
                                    return CustomerListTile(
                                      customerId: " #2826492",
                                      title: "Adeboyega Boyega",
                                      subTitle: "John Doe",
                                      date: DateTime.now(),
                                      onTap: () {},
                                    );
                                  },
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
