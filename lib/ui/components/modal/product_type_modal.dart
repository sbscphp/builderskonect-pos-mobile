import 'dart:async';
import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class ProductType extends ConsumerStatefulWidget {
  const ProductType({super.key, this.isCategory = true, required this.catId});

  final bool isCategory;
  final String catId;

  @override
  ConsumerState<ProductType> createState() => _ProductTypeState();
}

class _ProductTypeState extends ConsumerState<ProductType> {
  final searchC = TextEditingController();
  final searchF = FocusNode();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoryVmodel).getCategoryType(widget.catId);
    });
  }

  void _performSearch(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      ref.read(categoryVmodel).getCategoryType(widget.catId, q: query.trim().isEmpty ? null : query.trim());
    });
  }

  void _clearSearch() {
    searchC.clear();
    ref.read(categoryVmodel).getCategoryType(widget.catId);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    searchC.dispose();
    searchF.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // final colorScheme = Theme.of(context).colorScheme;
    final categoryVm = ref.watch(categoryVmodel);
    return Container(
      height: Sizer.screenHeight * 0.6,
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
              Text(
                "Product Type",
                style: textTheme.text16?.medium,
              ),
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
          CustomTextField(
            controller: searchC,
            isRequired: false,
            showLabelHeader: false,
            hintText: "Search with product type name.",
            onChanged: (value) {
              _performSearch(value);
              setState(() {});
            },
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (searchC.text.isNotEmpty)
                  InkWell(
                    onTap: () {
                      _clearSearch();
                      setState(() {});
                    },
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
                  onTap: () {
                    _performSearch(searchC.text);
                  },
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
          YBox(16),
          Expanded(
            child: LoadableContentBuilder(
              isBusy: categoryVm.busy(catTypeState),
              items: categoryVm.categoryTypes,
              loadingBuilder: (context) {
                return ListView.separated(
                  padding: EdgeInsets.only(
                    top: Sizer.height(10),
                    bottom: Sizer.height(80),
                  ),
                  shrinkWrap: true,
                  itemCount: 20,
                  separatorBuilder: (_, __) => YBox(24),
                  itemBuilder: (_, i) {
                    return Skeletonizer(
                      enabled: true,
                      child: Text(
                        "AB Microfinance Bank",
                        style: textTheme.text14,
                      ),
                    );
                  },
                );
              },
              emptyBuilder: (context) {
                return Center(
                  child: Text(
                    "No data found",
                    style: textTheme.text14?.medium.copyWith(
                      color: AppColors.gray500,
                    ),
                  ),
                );
              },
              contentBuilder: (context) {
                return RefreshIndicator(
                  onRefresh: () async {
                    // _initSetup();
                  },
                  child: ListView.separated(
                    padding: EdgeInsets.only(
                      top: Sizer.height(10),
                      bottom: Sizer.height(80),
                    ),
                    shrinkWrap: true,
                    itemCount: categoryVm.categoryTypes.length,
                    separatorBuilder: (_, __) => YBox(24),
                    itemBuilder: (_, i) {
                      final item = categoryVm.categoryTypes[i];
                      return InkWell(
                        onTap: () {
                          Navigator.pop(context, item);
                        },
                        child: Text(
                          item.name ?? "N/A",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.text14,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
