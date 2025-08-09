// ignore_for_file: use_build_context_synchronously

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class ViewProductDetailsScreen extends ConsumerStatefulWidget {
  const ViewProductDetailsScreen({super.key});

  @override
  ConsumerState<ViewProductDetailsScreen> createState() =>
      _ViewProductScreenState();
}

class _ViewProductScreenState extends ConsumerState<ViewProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: CustomAppbar(
          title: "Add Product",
          trailingWidget: InkWell(
            onTap: () {
              showMenu(
                context: context,
                position: RelativeRect.fromLTRB(100, 100, 0, 0),
                items: [
                  PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit Product', style: textTheme.text14),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete Product',
                        style: textTheme.text14?.copyWith(
                          color: AppColors.red2D,
                        )),
                  ),
                ],
              ).then((value) {
                if (value != null) {
                  printty('edit: $value');
                  switch (value) {
                    case 'change_password':
                      // Navigator.pushNamed(
                      //     context, RoutePath.changePasswordScreen);
                      break;
                    case 'delete':
                      final loadingProvider =
                          StateProvider<bool>((ref) => false);
                      ModalWrapper.bottomSheet(
                        context: context,
                        widget: Consumer(builder: (context, ref, child) {
                          final isLoading = ref.watch(loadingProvider);
                          return ConfirmationModal(
                            modalConfirmationArg: ModalConfirmationArg(
                              iconPath: AppSvgs.infoCircleRed,
                              title: "Log out",
                              description:
                                  "Are you sure you want to log out of this account? Your last changes will be saved.",
                              solidBtnText: "Yes, Logout",
                              isLoading: isLoading,
                              onSolidBtnOnTap: () async {
                                // Set loading to true
                                ref.read(loadingProvider.notifier).state = true;
                                try {
                                  await ref.read(authVmodel).logout();
                                } finally {
                                  // Check if the widget is still mounted before using ref
                                  if (context.mounted) {
                                    ref.read(loadingProvider.notifier).state =
                                        false;
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
                    default:
                      break;
                  }
                }
              });
            },
            child: Icon(
              Icons.more_vert,
              color: colorScheme.black85,
            ),
          ),
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Sizer.radius(4)),
                    child: MyCachedNetworkImage(
                      height: Sizer.height(270),
                      width: Sizer.screenWidth,
                      imageUrl: AppUtils.dummyImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                  YBox(24),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...List.generate(8, (i) {
                          return Padding(
                            padding: EdgeInsets.only(
                              right: Sizer.width(16),
                            ),
                            child: MyCachedNetworkImage(
                              height: Sizer.height(56),
                              width: Sizer.width(56),
                              imageUrl: AppUtils.dummyImage,
                              fit: BoxFit.cover,
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                  YBox(24),
                  Text(
                    "Presco Bathroom Wall Tiles",
                    style: textTheme.text16?.medium,
                  ),
                  Text(
                    "Product Code (SKU): 2187sfre",
                    style: textTheme.text14?.copyWith(
                      color: colorScheme.black45,
                    ),
                  ),
                  YBox(16),
                  Text(
                    "N 25,000/pieces",
                    style: textTheme.text16?.medium,
                  ),
                  YBox(16),
                  RichText(
                    text: TextSpan(
                      style: textTheme.text14,
                      children: const [
                        TextSpan(
                          text: "Size: ",
                        ),
                        TextSpan(
                          text: "50kg:",
                        ),
                      ],
                    ),
                  ),
                  YBox(24),
                  RichText(
                    text: TextSpan(
                      style: textTheme.text14,
                      children: const [
                        TextSpan(
                          text: "Category: ",
                        ),
                        TextSpan(
                          text: "50kg:",
                        ),
                      ],
                    ),
                  ),
                  YBox(24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tags:",
                        style: textTheme.text14,
                      ),
                      XBox(8),
                      Expanded(
                        child: Wrap(
                          spacing: Sizer.width(10),
                          runSpacing: Sizer.height(10),
                          children: List.generate(
                            5,
                            (index) => Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: Sizer.width(8),
                                vertical: Sizer.height(4),
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.dayBreakBlue,
                                border: Border.all(
                                  color: AppColors.dayBreakBlue3,
                                ),
                                borderRadius:
                                    BorderRadius.circular(Sizer.radius(2)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Wall Tiles $index",
                                    style: textTheme.text12?.copyWith(
                                      color: colorScheme.primaryColor,
                                    ),
                                  ),
                                  XBox(6),
                                  Icon(
                                    Icons.close,
                                    size: Sizer.radius(14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  YBox(24),
                  Text(
                    "Transform your living space with our Glossy White Ceramic Wall Tile, perfect for kitchens, bathrooms, and living room walls. With a smooth glossy finish, it adds elegance and brightness to any interior.",
                    style: textTheme.text14?.copyWith(
                      color: colorScheme.black45,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
