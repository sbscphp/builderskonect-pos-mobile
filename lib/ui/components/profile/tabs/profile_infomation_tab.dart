import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class ProfileInformationTab extends StatelessWidget {
  const ProfileInformationTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return ListView(
      children: [
        YBox(16),
        Container(
          margin: EdgeInsets.symmetric(horizontal: Sizer.width(16)),
          padding: EdgeInsets.symmetric(
            horizontal: Sizer.width(16),
            vertical: Sizer.height(16),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Sizer.radius(4)),
            color: colorScheme.white,
          ),
          child: Row(
            children: [
              CustomCircleAvatar(
                size: 60,
                avatarUrl: "",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, RoutePath.profileScreen);
                },
              ),
              XBox(16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Builder’s Hub Constructions',
                      style: textTheme.text16?.medium),
                  YBox(2),
                  Row(
                    children: [
                      SvgPicture.asset(AppSvgs.mail),
                      XBox(8),
                      Text(
                        "buildershub@gmail.com",
                        style: textTheme.text16?.copyWith(
                          color: AppColors.neutral9,
                        ),
                      ),
                    ],
                  ),
                  YBox(2),
                  Row(
                    children: [
                      SvgPicture.asset(AppSvgs.phone),
                      XBox(8),
                      Text(
                        "(+234) 80 2424 24212",
                        style: textTheme.text16?.copyWith(
                          color: AppColors.neutral9,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
        YBox(16),
        Container(
          margin: EdgeInsets.symmetric(horizontal: Sizer.width(16)),
          padding: EdgeInsets.symmetric(
            horizontal: Sizer.width(16),
            vertical: Sizer.height(16),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Sizer.radius(4)),
            color: colorScheme.white,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Business Profile",
                    style: textTheme.text16?.medium,
                  ),
                  XBox(8),
                  SvgPicture.asset(AppSvgs.profileEdit),
                ],
              ),
              YBox(16),
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
                      title: "Business name",
                      subTitle: "Builder’s Hub Construction",
                    ),
                    YBox(16),
                    ProfileColText(
                      title: "Business email",
                      subTitle: "buildershub@gmail.com",
                    ),
                    YBox(16),
                    ProfileColText(
                      title: "Business category",
                      subTitle: "Construction",
                    ),
                    YBox(16),
                    ProfileColText(
                      title: "Business type",
                      subTitle: "Full time",
                    ),
                    YBox(16),
                    ProfileColText(
                      title: "Business phone number",
                      subTitle: "+234 80 2424 24212",
                    ),
                    YBox(16),
                    ProfileColText(
                      title: "Vendor ID",
                      subTitle: "123456",
                      onCopy: () {},
                    ),
                    YBox(16),
                    ProfileColText(
                      title: "Business address",
                      subTitle: "123 Main St, Anytown, USA",
                    ),
                    YBox(16),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
