// ignore_for_file: use_build_context_synchronously

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class NewStoreScreen extends ConsumerStatefulWidget {
  const NewStoreScreen({super.key});

  @override
  ConsumerState<NewStoreScreen> createState() => _NewStoreScreenState();
}

class _NewStoreScreenState extends ConsumerState<NewStoreScreen> {
  final _formKey = GlobalKey<FormState>();
  final storeNameC = TextEditingController();
  final storeAddressC = TextEditingController();
  final stateC = TextEditingController();
  final cityC = TextEditingController();

  StateModel? selectedState;
  CityModel? selectedCity;
  // GoogleAddressModel? selectedAddress;

  @override
  void dispose() {
    storeNameC.dispose();
    storeAddressC.dispose();
    stateC.dispose();
    cityC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return BusyOverlay(
      show: ref.watch(storeVmodel).busy(createState),
      child: Scaffold(
          appBar: CustomAppbar(
            title: "New Store",
          ),
          body: Container(
            padding: EdgeInsets.all(Sizer.radius(16)),
            margin: EdgeInsets.only(
              left: Sizer.radius(16),
              right: Sizer.radius(16),
              top: Sizer.radius(16),
            ),
            decoration: BoxDecoration(
              color: colorScheme.white,
              borderRadius: BorderRadius.circular(Sizer.radius(4)),
            ),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Text("Add New Store", style: textTheme.text16?.medium),
                  Text(
                    "Fill the form below to add a new store",
                    style: textTheme.text12?.copyWith(
                      color: colorScheme.black45,
                    ),
                  ),
                  YBox(16),
                  CustomTextField(
                    controller: storeNameC,
                    isRequired: false,
                    labelText: 'Store Name',
                    hintText: 'Enter store name',
                    showLabelHeader: true,
                    validator: Validators.required(),
                  ),
                  YBox(16),
                  CustomTextField(
                    controller: storeAddressC,
                    isRequired: false,
                    labelText: 'Store Address',
                    optionalText: "(optional)",
                    hintText: 'Enter store address',
                    showLabelHeader: true,
                    validator: Validators.required(),
                    // readOnly: true,
                    // onTsp: () async {
                    //   final res = await ModalWrapper.bottomSheet(
                    //     context: context,
                    //     widget: GoogleAddressModal(),
                    //   );
                    //   if (res is StateModel) {
                    //     stateC.text = res.name ?? "";
                    //     selectedState = res;
                    //   }
                    // },
                  ),
                  YBox(16),
                  CustomTextField(
                    controller: stateC,
                    isRequired: false,
                    labelText: 'State',
                    optionalText: "(optional)",
                    hintText: 'Select state',
                    showLabelHeader: true,
                    readOnly: true,
                    validator: Validators.required(),
                    onTsp: () async {
                      final res = await ModalWrapper.bottomSheet(
                        context: context,
                        widget: StateModal(),
                      );
                      if (res is StateModel) {
                        stateC.text = res.name ?? "";
                        selectedState = res;
                      }
                    },
                  ),
                  YBox(16),
                  CustomTextField(
                    controller: cityC,
                    isRequired: false,
                    labelText: 'City/Region',
                    optionalText: "(optional)",
                    hintText: 'Enter city/region',
                    showLabelHeader: true,
                    readOnly: true,
                    validator: Validators.required(),
                    onTsp: () async {
                      if (selectedState == null) {
                        FlushBarToast.fLSnackBar(
                          snackBarType: SnackBarType.warning,
                          message: "Please select state first",
                        );
                        return;
                      }
                      final res = await ModalWrapper.bottomSheet(
                        context: context,
                        widget: CityModal(stateId: selectedState?.id ?? 0),
                      );
                      if (res is CityModel) {
                        cityC.text = res.name ?? "";
                        selectedCity = res;
                      }
                    },
                  ),
                  YBox(20),
                  CustomBtn.solid(
                    text: "Save",
                    onTap: () async {
                      if (_formKey.currentState?.validate() == true) {
                        final res = await ref.read(storeVmodel).addNewStore(
                              storeName: storeNameC.text,
                              storeAddress: storeAddressC.text,
                              stateId: selectedState?.id ?? 0,
                              cityId: selectedCity?.id ?? 0,
                            );

                        handleApiResponse(
                          response: res,
                          onSuccess: () {
                            Navigator.pop(context);
                            ref.read(storeVmodel).getStoreOverview();
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
