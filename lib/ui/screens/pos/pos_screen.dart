import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class PosScreen extends ConsumerWidget {
  const PosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: CustomAppbar(
        title: "Dashboard",
        trailingWidget: InkWell(
          onTap: () {
            Navigator.pushNamed(context, RoutePath.notificationScreen);
          },
          child: SvgPicture.asset(
            AppSvgs.notification,
            height: Sizer.height(32),
          ),
        ),
        leadingWidget: Container(
          height: Sizer.height(40),
          width: Sizer.width(40),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Sizer.radius(40)),
              border: Border.all(
                color: AppColors.primaryBlue,
                width: 2,
              )),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Sizer.radius(40)),
            child: ref.watch(authVmodel).user?.avatar != null
                ? MyCachedNetworkImage(
                    imageUrl: ref.watch(authVmodel).user!.avatar,
                    fit: BoxFit.cover,
                  )
                : Icon(
                    Iconsax.user,
                    size: Sizer.width(20),
                  ),
          ),
        ),
      ),
      body: Column(
        children: [
          Text("Pos Screen"),
        ],
      ),
    );
  }
}
