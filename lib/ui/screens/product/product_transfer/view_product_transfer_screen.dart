import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class ViewProductTransferScreen extends ConsumerStatefulWidget {
  final String productId;
  const ViewProductTransferScreen({super.key, required this.productId});

  @override
  ConsumerState<ViewProductTransferScreen> createState() =>
      _ViewProductTransferScreenState();
}

class _ViewProductTransferScreenState
    extends ConsumerState<ViewProductTransferScreen> {
  int indexStack = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchTransferProduct();
    });
  }

  fetchTransferProduct() async {
    ref.read(productTransferVm).viewTransferProduct(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(productTransferVm);
    return Scaffold(
      appBar: CustomAppbar(
        title: "View Stock Transfer",
      ),
      body: SizedBox(
        height: Sizer.screenHeight,
        width: Sizer.screenWidth,
        child: BusyOverlay(
          show: vm.busy(viewState),
          child: ListView(
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
                    text: "Request Details",
                    isSelected: indexStack == 0,
                    onTap: () {
                      indexStack = 0;
                      setState(() {});
                      // notyVm.getNotifications();
                    },
                  ),
                  XBox(6),
                  NotificationTab(
                    text: "Product List",
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
                  RequestDetailsTab(),
                  ProductListTab(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
