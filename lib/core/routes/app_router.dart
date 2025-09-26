import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/screens/screens.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case RoutePath.splashScreen:
        return TransitionUtils.buildTransition(
          const SplashScreen(),
          settings,
        );

      case RoutePath.introScreen:
        return TransitionUtils.buildTransition(
          const IntroScreen(),
          settings,
        );

      case RoutePath.bottomNavScreen:
        final dashArgs = args as DashArg?;
        return TransitionUtils.buildTransition(
          BottomNavScreen(args: dashArgs),
          settings,
        );

      // Auth
      case RoutePath.loginScreen:
        return TransitionUtils.buildTransition(
          const LoginScreen(),
          settings,
        );

      case RoutePath.forgotPasswordScreen:
        return TransitionUtils.buildTransition(
          const ForgotPasswordScreen(),
          settings,
        );

      case RoutePath.otpScreen:
        if (args is ForgotArg) {
          return TransitionUtils.buildTransition(
            OtpScreen(args: args),
            settings,
          );
        }
        return errorScreen(settings);

      case RoutePath.vendorRegistrationScreen:
        if (args is String) {
          return TransitionUtils.buildTransition(
            VendorRegistrationScreen(reference: args),
            settings,
          );
        }
        return errorScreen(settings);

      case RoutePath.newPasswordScreen:
        if (args is ForgotArg) {
          return TransitionUtils.buildTransition(
            NewPasswordScreen(args: args),
            settings,
          );
        }
        return errorScreen(settings);

      case RoutePath.selectModuleScreen:
        return TransitionUtils.buildTransition(
          const SelectModuleScreen(),
          settings,
        );

      case RoutePath.notificationScreen:
        return TransitionUtils.buildTransition(
          const NotificationScreen(),
          settings,
        );

      // Profile
      case RoutePath.profileScreen:
        return TransitionUtils.buildTransition(
          const VendorProfileScreen(),
          settings,
        );

      case RoutePath.contactSupportScreen:
        return TransitionUtils.buildTransition(
          const ContactSupportScreen(),
          settings,
        );

      case RoutePath.editBusinessProfileScreen:
        if (args is Business) {
          return TransitionUtils.buildTransition(
            EditBusinessProfileScreen(business: args),
            settings,
          );
        }
        return errorScreen(settings);

      case RoutePath.editFinanceScreen:
        if (args is Finance) {
          return TransitionUtils.buildTransition(
            EditFinanceScreen(finance: args),
            settings,
          );
        }
        return errorScreen(settings);

      case RoutePath.editDocumentsScreen:
        return TransitionUtils.buildTransition(
          const EditDocumentsScreen(),
          settings,
        );

      // Settings
      case RoutePath.settingScreen:
        return TransitionUtils.buildTransition(
          const SettingScreen(),
          settings,
        );

      case RoutePath.changePasswordScreen:
        return TransitionUtils.buildTransition(
          const ChangePasswordScreen(),
          settings,
        );

      // Plans
      case RoutePath.pricingPlansScreen:
        final isUpgrade = args is bool;
        return TransitionUtils.buildTransition(
          PricingPlansScreen(isUpgrade: isUpgrade),
          settings,
        );

      case RoutePath.getStartedScreen:
        if (args is PlanFeatureArg) {
          return TransitionUtils.buildTransition(
            GetStartedScreen(arg: args),
            settings,
          );
        }
        return errorScreen(settings);

      case RoutePath.planLearnMoreScreen:
        if (args is PlanFeatureArg) {
          return TransitionUtils.buildTransition(
            PlanLearnMoreScreen(arg: args),
            settings,
          );
        }
        return errorScreen(settings);

      case RoutePath.subscriptionSuccessScreen:
        if (args is SubscriptionSuccessArg) {
          return TransitionUtils.buildTransition(
            SubscriptionSuccessScreen(arg: args),
            settings,
          );
        }
        return errorScreen(settings);

      case RoutePath.subscriptionDetailsScreen:
        if (args is UserSubcription) {
          return TransitionUtils.buildTransition(
            SubscriptionDetailsScreen(arg: args),
            settings,
          );
        }
        return errorScreen(settings);

      case RoutePath.renewSubscriptionScreen:
        if (args is SubcriptionArg) {
          return TransitionUtils.buildTransition(
            RenewSubscriptionScreen(subcriptionArg: args),
            settings,
          );
        }
        return errorScreen(settings);

      // Product
      case RoutePath.searchAddProductScreen:
        return TransitionUtils.buildTransition(
          const SearchAddProductScreen(),
          settings,
        );

      case RoutePath.addProductScreen:
        // Note: AddProductScreen now uses direct navigation with ProductCatalogueWithStatus
        // This route is kept for backward compatibility but may not be used
        return errorScreen(settings);

      case RoutePath.addProductRequestScreen:
        return TransitionUtils.buildTransition(
          const AddProductRequestScreen(),
          settings,
        );

      case RoutePath.inventoryScreen:
        return TransitionUtils.buildTransition(
          const InventoryScreen(),
          settings,
        );

      case RoutePath.viewUploadScreen:
        return TransitionUtils.buildTransition(
          const ViewUploadScreen(),
          settings,
        );

      case RoutePath.viewProductDetailsScreen:
        if (args is ProductModel) {
          return TransitionUtils.buildTransition(
            ViewProductDetailsScreen(product: args),
            settings,
          );
        }

        return errorScreen(settings);
      case RoutePath.inventoryDetailsScreen:
        if (args is ProductModel) {
          return TransitionUtils.buildTransition(
            InventoryDetailsScreen(product: args),
            settings,
          );
        }
        return errorScreen(settings);

      case RoutePath.productTransferScreen:
        return TransitionUtils.buildTransition(
          const ProductTransferScreen(),
          settings,
        );

      case RoutePath.productTransferRequestScreen:
        return TransitionUtils.buildTransition(
          const ProductTransferRequestScreen(),
          settings,
        );

      case RoutePath.productTransferPreviewScreen:
        return TransitionUtils.buildTransition(
          const ProductTransferPreviewScreen(),
          settings,
        );

      case RoutePath.viewProductTransferScreen:
        if (args is String) {
          return TransitionUtils.buildTransition(
            ViewProductTransferScreen(productId: args),
            settings,
          );
        }
        return errorScreen(settings);

      case RoutePath.editInventoryScreen:
        if (args is ProductModel) {
          return TransitionUtils.buildTransition(
            EditInventoryScreen(product: args),
            settings,
          );
        }
        return errorScreen(settings);

      // Store
      case RoutePath.newStoreScreen:
        return TransitionUtils.buildTransition(
          const NewStoreScreen(),
          settings,
        );

      case RoutePath.viewStoreScreen:
        if (args is StoreModel) {
          return TransitionUtils.buildTransition(
            ViewStoreScreen(store: args),
            settings,
          );
        }
        return errorScreen(settings);

      case RoutePath.storeSalesOverviewScreen:
        if (args is StoreModel) {
          return TransitionUtils.buildTransition(
            StoreSalesOverviewScreen(store: args),
            settings,
          );
        }
        return errorScreen(settings);

      case RoutePath.storeInventoryOverviewScreen:
        if (args is StoreModel) {
          return TransitionUtils.buildTransition(
            StoreInventoryOverviewScreen(store: args),
            settings,
          );
        }
        return errorScreen(settings);

      // sales
      case RoutePath.newSalesScreen:
        return TransitionUtils.buildTransition(
          const NewSalesScreen(),
          settings,
        );

      case RoutePath.pausedSalesScreen:
        return TransitionUtils.buildTransition(
          const PausedSalesScreen(),
          settings,
        );

      case RoutePath.orderAnalyticsScreen:
        return TransitionUtils.buildTransition(
          const OrderAnalyticsScreen(),
          settings,
        );

      case RoutePath.viewSalesOrderScreen:
        final args = settings.arguments as String?;
        if (args != null) {
          return TransitionUtils.buildTransition(
            ViewSalesOrderScreen(id: args),
            settings,
          );
        }
        return errorScreen(settings);

      // Returns
      case RoutePath.returnRefundScreen:
        return TransitionUtils.buildTransition(
          const ReturnRefundScreen(),
          settings,
        );

      case RoutePath.logNewReturnScreen:
        return TransitionUtils.buildTransition(
          const LogNewReturnScreen(),
          settings,
        );

      case RoutePath.viewReturnsScreen:
        if (args is RefundData) {
          return TransitionUtils.buildTransition(
            ViewReturnsScreen(refund: args),
            settings,
          );
        }
        return errorScreen(settings);

      // Staff
      case RoutePath.staffManagementScreen:
        return TransitionUtils.buildTransition(
          const StaffManagementScreen(),
          settings,
        );

      case RoutePath.newStaffScreen:
        return TransitionUtils.buildTransition(
          const NewStaffScreen(),
          settings,
        );

      case RoutePath.newRolesPermissionScreen:
        return TransitionUtils.buildTransition(
          const NewRolesPermissionScreen(),
          settings,
        );

      case RoutePath.staffProfileScreen:
        if (args is String) {
          return TransitionUtils.buildTransition(
            StaffProfileScreen(
              staffId: args,
            ),
            settings,
          );
        }
        return errorScreen(settings);

      case RoutePath.editStaffScreen:
        return TransitionUtils.buildTransition(
          const EditStaffScreen(),
          settings,
        );

      // Customers
      case RoutePath.customersManagementScreen:
        return TransitionUtils.buildTransition(
          const CustomersManagementScreen(),
          settings,
        );

      case RoutePath.newCustomerScreen:
        return TransitionUtils.buildTransition(
          const NewCustomerScreen(),
          settings,
        );

      case RoutePath.viewCustomerScreen:
        if (args is CustomerData) {
          return TransitionUtils.buildTransition(
            ViewCustomerScreen(customer: args),
            settings,
          );
        }
        return errorScreen(settings);

      case RoutePath.reviewsAndFeedbackScreen:
        return TransitionUtils.buildTransition(
          ReviewsAndFeedbackScreen(),
          settings,
        );

      case RoutePath.feedbackReviewDetailsScreen:
        if (args is ProductModel) {
          return TransitionUtils.buildTransition(
            FeedbackReviewDetailsScreen(product: args),
            settings,
          );
        }
        return errorScreen(settings);

      case RoutePath.vendorReviewDetailsScreen:
        if (args is ReviewsModel) {
          return TransitionUtils.buildTransition(
            VendorReviewDetailsScreen(review: args),
            settings,
          );
        }
        return errorScreen(settings);

      // Discount
      case RoutePath.discountManagementScreen:
        return TransitionUtils.buildTransition(
          const DiscountManagementScreen(),
          settings,
        );

      case RoutePath.newDiscountScreen:
        return TransitionUtils.buildTransition(
          const NewDiscountScreen(),
          settings,
        );

      // case RoutePath.newCouponScreen:
      //   return TransitionUtils.buildTransition(
      //     const NewCouponScreen(),
      //     settings,
      //   );

      // POS
      case RoutePath.moreScreen:
        return TransitionUtils.buildTransition(
          const MoreScreen(),
          settings,
        );

      // Webview
      case RoutePath.customWebviewScreen:
        if (args is WebViewArg) {
          return TransitionUtils.buildTransition(
            CustomWebviewScreen(arg: args),
            settings,
          );
        }
        return errorScreen(settings);

      // Documents
      case RoutePath.documentViewerScreen:
        if (args is DocumentViewerArg) {
          return TransitionUtils.buildTransition(
            DocumentViewerScreen(arg: args),
            settings,
          );
        }
        return errorScreen(settings);

      default:
        return errorScreen(settings);
    }
  }

  static errorScreen(RouteSettings settings) {
    return TransitionUtils.buildTransition(
      ScreenNotFound(routeName: settings.name),
      settings,
    );
  }
}
