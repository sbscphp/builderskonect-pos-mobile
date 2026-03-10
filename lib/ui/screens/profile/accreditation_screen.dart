import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';
import 'package:flutter/services.dart';

class AccreditationScreen extends ConsumerStatefulWidget {
  const AccreditationScreen({super.key});

  @override
  ConsumerState<AccreditationScreen> createState() =>
      _AccreditationScreenState();
}

class _AccreditationScreenState extends ConsumerState<AccreditationScreen> {
  final searchC = TextEditingController();
  final searchF = FocusNode();

  List<Brand> selectedBrands = [];

  @override
  void dispose() {
    searchC.dispose();
    searchF.dispose();
    // _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final vm = ref.watch(accreditationVm);
    return Scaffold(
      appBar: CustomAppbar(
        title: "Get Accreditation",
      ),
      body: ListView(
        padding: EdgeInsets.only(
          left: Sizer.width(16),
          right: Sizer.width(16),
          bottom: Sizer.height(50),
          top: Sizer.height(10),
        ),
        children: [
          Container(
              padding: EdgeInsets.all(Sizer.radius(16)),
              decoration: BoxDecoration(
                color: colorScheme.white,
                borderRadius: BorderRadius.circular(Sizer.radius(4)),
              ),
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  CustomTextField(
                    controller: searchC,
                    focusNode: searchF,
                    isRequired: false,
                    labelText: 'Search here to add manufacturers',
                    hintText: 'Search',
                    showLabelHeader: true,
                    onTap: () async {
                      final res = await ModalWrapper.bottomSheet(
                        context: context,
                        widget: ManufacturerSelectionModal(),
                      );
                      if (res is List<Brand>) {
                        setState(() {
                          selectedBrands = res;
                        });
                      }
                    },
                    // onChanged: _searchProducts,
                  ),
                  YBox(16.h),
                  Wrap(
                      runSpacing: 6.h,
                      spacing: 8.w,
                      children: List.generate(selectedBrands.length, (index) {
                        final item = selectedBrands[index];
                        return TagWidget(
                          tag: item.name ?? "",
                          showCloseIcon: true,
                          onClose: () {
                            selectedBrands.remove(item);
                            setState(() {});
                          },
                        );
                      }))
                  // YBox(24),
                ],
              )),
          YBox(16.h),
          ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final manufacturer = selectedBrands[index];
                return Container(
                    padding: EdgeInsets.all(Sizer.radius(16)),
                    decoration: BoxDecoration(
                      color: colorScheme.white,
                      borderRadius: BorderRadius.circular(Sizer.radius(4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(manufacturer.name ?? '',
                            style: textTheme.text16?.medium),
                        YBox(12.h),
                        Divider(color: AppColors.neutral4, height: 1),
                        YBox(12.h),
                        CustomTextField(
                          controller: manufacturer.certificateNum,
                          // focusNode: searchF,
                          isRequired: false,
                          labelText: 'Certification Number',
                          hintText: 'Enter certification no',
                          showLabelHeader: true,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(23),
                          ],
                          height: 35.h,
                          // onChanged: _searchProducts,
                        ),
                        YBox(12.h),
                        CustomTextField(
                          controller: manufacturer.expriryDate,
                          // focusNode: searchF,
                          isRequired: false,
                          labelText: 'Expiry Date',
                          hintText: 'Enter expiry date',
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(
                              right: Sizer.radius(10),
                              left: Sizer.radius(4),
                            ),
                            child: SvgPicture.asset(AppSvgs.inputSuffix),
                          ),
                          showLabelHeader: true,
                          readOnly: true,
                          onTap: () async {
                            final result =
                                await showDialog<Map<String, DateTime?>>(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  insetPadding: EdgeInsets.symmetric(
                                      horizontal: Sizer.width(16)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(Sizer.radius(16)),
                                  ),
                                  child: CustomDatePicker(
                                    initialDate: manufacturer.expireyDateTime ??
                                        DateTime.now(),
                                    // endDate: endDate,
                                    minDate: DateTime.now(), // today
                                    maxDate: DateTime.now().add(const Duration(
                                        days: 1000)), // 1 year from now
                                    onDateSelected: (startDate, rangeEndDate) {
                                      Navigator.of(context).pop({
                                        'startDate': startDate,
                                        'endDate': rangeEndDate,
                                      });
                                    },
                                  ),
                                );
                              },
                            );
                            if (result != null) {
                              setState(() {
                                manufacturer.expireyDateTime =
                                    result['startDate'];
                                // Update text controllers
                                printty(manufacturer.expireyDateTime);
                                if (manufacturer.expireyDateTime != null) {
                                  manufacturer.expriryDate.text =
                                      "${manufacturer.expireyDateTime!.day}/${manufacturer.expireyDateTime!.month}/${manufacturer.expireyDateTime!.year}";
                                  //handles previous selection
                                }
                              });
                            }
                          },

                          height: 35.h,
                          // onChanged: _searchProducts,
                        ),
                        YBox(12.h),
                        UploadWidget(
                          labelText: "Attach Document",
                          isUploading:
                              ref.watch(fileUploadVm).busy("accreditation"),
                          onUpload: () async {
                            final file = await ImageAndDocUtils.pickDocument();
                            if (file != null) {
                              final r = await ref.read(fileUploadVm).uploadFile(
                                  file: [file],
                                  busyObjectName: "accreditation");
                              manufacturer.docUrl = r.data?.first.url;
                              setState(() {});
                            }
                          },
                          onRemove: () {
                            manufacturer.docUrl = null;
                            setState(() {});
                          },
                        ),
                        YBox(12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomBtn(
                              width: 125.w,
                              onlineColor: Colors.white,
                              outlineColor: AppColors.grey,
                              height: 40,
                              onTap: () {
                                selectedBrands.remove(manufacturer);
                                setState(() {});
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    AppSvgs.trash,
                                    height: Sizer.height(14),
                                  ),
                                  XBox(8),
                                  Text(
                                    "Remove",
                                    style: textTheme.text14?.copyWith(
                                      color: AppColors.red22,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ));
              },
              separatorBuilder: (__, _) => YBox(16.h),
              itemCount: selectedBrands.length),
          CustomBtn.solid(
              isLoading: vm.busy(createAccreditationState),
              onTap: () async {
                if (selectedBrands.isNotEmpty) {
                  final response = await vm.createAccreditation(selectedBrands);
                  //todo::: handle cleaning, dispose and mem leaks here!!!

                  handleApiResponse(
                    response: response,
                    onSuccess: () {
                      ModalWrapper.bottomSheet(
                        context: NavKey.appNavKey.currentContext!,
                        canDismiss: false,
                        isScrollControlled: false,
                        widget: ConfirmationModal(
                          modalConfirmationArg: ModalConfirmationArg(
                            iconPath: AppSvgs.checkIcon,
                            title: "Accredited vendors created successfully",
                            description:
                                "Accreditation for selected Vendor(s) have been initiated and will be communicated to manufacturers",
                            solidBtnText: "Great",
                            onSolidBtnOnTap: () {
                              // Get navigation context safely
                              final navCtx = NavKey.appNavKey.currentContext;
                              if (navCtx == null) return;

                              Navigator.pop(navCtx);
                              Navigator.pop(navCtx);
                            },
                          ),
                        ),
                      );
                    },
                  );
                }
              },
              text: "Submit"),
          YBox(16.h),
        ],
      ),
    );
  }
}
