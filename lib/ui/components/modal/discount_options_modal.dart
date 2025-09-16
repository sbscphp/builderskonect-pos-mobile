import 'package:builders_konnect/core/core.dart';

class DiscountOptionsModal {
  static Widget application({required BuildContext context}) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      height: Sizer.screenHeight * 0.30,
      padding: EdgeInsets.symmetric(
        horizontal: Sizer.width(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YBox(20),
          Row(
            children: [
              Text("Discount Application",
                  style: Theme.of(context).textTheme.text16?.medium),
              Spacer(),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                  color: AppColors.black,
                  size: Sizer.radius(24),
                ),
              )
            ],
          ),
          YBox(16),
          Divider(color: AppColors.neutral4, height: 1),
          YBox(16),
          InkWell(
            onTap: () {
              Navigator.pop(context, "products");
            },
            child: Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Text(
                "Discount per product",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.text14,
              ),
            ),
          ),
          YBox(16),
          InkWell(
            onTap: () {
              Navigator.pop(context, "sales-orders");
            },
            child: Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Text(
                "Discount on total orders",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.text14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget type({required BuildContext context}) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      height: Sizer.screenHeight * 0.30,
      padding: EdgeInsets.symmetric(
        horizontal: Sizer.width(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YBox(20),
          Row(
            children: [
              Text("Discount Type",
                  style: Theme.of(context).textTheme.text16?.medium),
              Spacer(),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                  color: AppColors.black,
                  size: Sizer.radius(24),
                ),
              )
            ],
          ),
          YBox(16),
          Divider(color: AppColors.neutral4, height: 1),
          YBox(16),
          InkWell(
            onTap: () {
              Navigator.pop(context, "amount");
            },
            child: Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Text(
                "Amount off",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.text14,
              ),
            ),
          ),
          YBox(16),
          InkWell(
            onTap: () {
              Navigator.pop(context, "percentage");
            },
            child: Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Text(
                "Percentage off",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.text14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
