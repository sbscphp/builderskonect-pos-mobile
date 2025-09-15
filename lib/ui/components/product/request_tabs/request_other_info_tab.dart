import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class RequestOtherInfoTab extends ConsumerStatefulWidget {
  const RequestOtherInfoTab({
    super.key,
    this.onPrevious,
  });

  final Function()? onPrevious;

  @override
  ConsumerState<RequestOtherInfoTab> createState() =>
      _RequestOtherInfoTabState();
}

class _RequestOtherInfoTabState extends ConsumerState<RequestOtherInfoTab> {
  // final _formKey = GlobalKey<FormState>();
  final productNameC = TextEditingController();
  final brandC = TextEditingController();

  @override
  void dispose() {
    productNameC.dispose();
    brandC.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
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
            borderRadius: BorderRadius.circular(Sizer.radius(6)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FilterHeader(
                title: "Product Details",
                subTitle:
                    "Fill the form below to add required product information.",
              ),
              YBox(16),
              YBox(32),
              CustomBtn.solid(
                text: "Next",
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
