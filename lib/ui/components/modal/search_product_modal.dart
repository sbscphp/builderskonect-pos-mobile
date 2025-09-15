import 'dart:async';

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class SearchProductModal extends ConsumerStatefulWidget {
  final List<ProductModel>? initialSelectedProducts;
  const SearchProductModal({super.key, this.initialSelectedProducts});

  @override
  ConsumerState<SearchProductModal> createState() => _SearchProductModalState();
}

class _SearchProductModalState extends ConsumerState<SearchProductModal> {
  final searchC = TextEditingController();
  final searchF = FocusNode();
  Timer? _debounce;
  List<ProductModel> selectedProducts = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchProducts();
      if (widget.initialSelectedProducts != null) {
        selectedProducts = widget.initialSelectedProducts ?? [];
        setState(() {});
      }
    });
  }

  _fetchProducts() async {
    final res = await ref.read(productInventoryVmodel).getInventoryProducts();
    if (res.success) {
      setState(() {});
    }
  }

  // Search Bank with debounce
  void _searchProducts(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(productInventoryVmodel).getInventoryProducts(q: query);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchC.dispose();
    searchF.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final productVm = ref.watch(productInventoryVmodel);

    return Container(
      height: Sizer.screenHeight * 0.8,
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
              Text("Search Product", style: textTheme.text16?.medium),
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
          YBox(24),
          CustomTextField(
            controller: searchC,
            focusNode: searchF,
            hintText: "Search Product Name",
            borderRadius: 8,
            showLabelHeader: false,
            onChanged: (p0) {
              setState(() {});
              _searchProducts(p0.trim());
            },
            suffixIcon: searchC.text.isEmpty
                ? null
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                        onTap: () {
                          searchC.clear();
                          setState(() {});
                          _searchProducts('');
                        },
                        child: Icon(Icons.close, color: AppColors.gray500)),
                  ),
            prefixIcon: Padding(
              padding: EdgeInsets.only(
                left: Sizer.width(16),
              ),
              child: Icon(
                Iconsax.search_normal_1,
                size: Sizer.radius(16),
                color: AppColors.black.withValues(alpha: 0.85),
              ),
            ),
          ),
          YBox(7),
          Expanded(
            child: LoadableContentBuilder(
              isBusy: productVm.busy(getState),
              items: productVm.inventoryProducts,
              loadingBuilder: (context) {
                return ListView.separated(
                  padding: EdgeInsets.only(
                    top: Sizer.height(10),
                    bottom: Sizer.height(80),
                  ),
                  shrinkWrap: true,
                  itemCount: 20,
                  separatorBuilder: (_, __) => YBox(12),
                  itemBuilder: (_, i) {
                    return Skeletonizer(
                      enabled: true,
                      child: Row(
                        children: [
                          Bone.circle(
                            size: Sizer.height(30),
                          ),
                          XBox(10),
                          Text(
                            "AB Microfinance Bank",
                            style: textTheme.text14,
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              emptyBuilder: (context) {
                return Center(
                  child: Text(
                    "No Products found",
                    style: textTheme.text14?.medium.copyWith(
                      color: AppColors.gray500,
                    ),
                  ),
                );
              },
              contentBuilder: (context) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await _fetchProducts();
                  },
                  child: ListView.separated(
                    padding: EdgeInsets.only(
                      top: Sizer.height(10),
                      bottom: Sizer.height(80),
                    ),
                    shrinkWrap: true,
                    itemCount: productVm.inventoryProducts.length,
                    separatorBuilder: (_, __) => YBox(16),
                    itemBuilder: (_, i) => InkWell(
                      onTap: () {
                        // pickedBank = bankVm.bankList[i];
                        selectedProducts
                                .where((product) =>
                                    product.id ==
                                    productVm.inventoryProducts[i].id)
                                .isNotEmpty
                            ? selectedProducts
                                .remove(productVm.inventoryProducts[i])
                            : selectedProducts
                                .add(productVm.inventoryProducts[i]);
                        setState(() {});
                      },
                      child: Row(
                        children: [
                          // SvgPicture.asset(AppSvgs.logomark),
                          XBox(10),
                          Expanded(
                            child: Text(
                              productVm.inventoryProducts[i].name ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.text16,
                            ),
                          ),
                          if (selectedProducts
                              .where((product) =>
                                  product.id ==
                                  productVm.inventoryProducts[i].id)
                              .isNotEmpty)
                            Icon(
                              Icons.check,
                              color: AppColors.primaryBlue,
                              size: Sizer.radius(16),
                            )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          YBox(20),
          Row(
            children: [
              Expanded(
                child: CustomBtn.solid(
                  text: "Close",
                  height: 42,
                  isOutline: true,
                  outlineColor: AppColors.neutral5,
                  textStyle: textTheme.text16,
                  onTap: () {},
                ),
              ),
              XBox(16),
              Expanded(
                child: CustomBtn.solid(
                  text: "Done",
                  height: 42,
                  onTap: () {
                    Navigator.pop(context, {'products': selectedProducts});
                  },
                ),
              ),
            ],
          ),
          YBox(30),
        ],
      ),
    );
  }
}
