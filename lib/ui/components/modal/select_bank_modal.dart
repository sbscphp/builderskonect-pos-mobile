import 'dart:async';

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class SelectBankModal extends ConsumerStatefulWidget {
  const SelectBankModal({
    super.key,
    this.selectedBank,
  });

  final BankModel? selectedBank;

  @override
  ConsumerState<SelectBankModal> createState() => _SelectBankModalState();
}

class _SelectBankModalState extends ConsumerState<SelectBankModal> {
  final searchC = TextEditingController();
  final searchF = FocusNode();

  Timer? _debounce;
  BankModel? pickedBank;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchBanks();
      if (widget.selectedBank != null) {
        pickedBank = widget.selectedBank;
        setState(() {});
      }
    });
  }

  _fetchBanks([String? query]) async {
    final r = await ref.read(bankVmodel).getBanks(query);
    if (r.success) {
      setState(() {});
    }
  }

  // Search Bank with debounce
  void _searchBanks(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(bankVmodel).getBanks(query);
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
    // final colorScheme = Theme.of(context).colorScheme;
    final bankVm = ref.watch(bankVmodel);
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
              Text("Select Bank", style: textTheme.text16?.medium),
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
            hintText: "Search Bank Name",
            borderRadius: 8,
            showLabelHeader: false,
            onChanged: (p0) {
              _searchBanks(p0.trim());
            },
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
              isBusy: bankVm.isBusy,
              items: bankVm.bankList,
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
                    "No banks found",
                    style: textTheme.text14?.medium.copyWith(
                      color: AppColors.gray500,
                    ),
                  ),
                );
              },
              contentBuilder: (context) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await _fetchBanks();
                  },
                  child: ListView.separated(
                    padding: EdgeInsets.only(
                      top: Sizer.height(10),
                      bottom: Sizer.height(80),
                    ),
                    shrinkWrap: true,
                    itemCount: bankVm.bankList.length,
                    separatorBuilder: (_, __) => YBox(12),
                    itemBuilder: (_, i) => InkWell(
                      onTap: () {
                        pickedBank = bankVm.bankList[i];
                        setState(() {});
                        Navigator.pop(context, bankVm.bankList[i]);
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset(AppSvgs.logomark),
                          XBox(10),
                          Expanded(
                            child: Text(
                              bankVm.bankList[i].name ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.text14,
                            ),
                          ),
                          if (pickedBank?.id == bankVm.bankList[i].id)
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
          )
        ],
      ),
    );
  }
}
