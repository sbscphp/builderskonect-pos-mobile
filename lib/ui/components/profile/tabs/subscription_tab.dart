import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class SubscriptionTab extends ConsumerStatefulWidget {
  const SubscriptionTab({super.key});

  @override
  ConsumerState<SubscriptionTab> createState() => _SubscriptionTabState();
}

class _SubscriptionTabState extends ConsumerState<SubscriptionTab> {
  final searchC = TextEditingController();
  final searchF = FocusNode();

  @override
  void dispose() {
    searchC.dispose();
    searchF.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: Sizer.width(16)),
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
                title: "Subscription Plans",
                subTitle: "This shows the vendors billing history overtime",
                onFilter: () {},
              ),
              YBox(16),
              CustomTextField(
                controller: searchC,
                focusNode: searchF,
                isRequired: false,
                showLabelHeader: false,
                hintText: "Search with order no.",
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
                  return CustomColWidget(
                    firstColText: "Basic (Monthly)",
                    secondColText: "N 3000",
                    status: "Expired",
                    date: DateTime.now(),
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
