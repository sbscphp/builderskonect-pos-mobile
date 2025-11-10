import 'dart:io';

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class DocumentUpload extends ConsumerStatefulWidget {
  const DocumentUpload({
    super.key,
    this.onPrevious,
  });

  final VoidCallback? onPrevious;

  @override
  ConsumerState<DocumentUpload> createState() => _DocumentUploadState();
}

class _DocumentUploadState extends ConsumerState<DocumentUpload> {
  final tinC = TextEditingController();
  final cacC = TextEditingController();

  final tinF = FocusNode();
  final cacF = FocusNode();

  File? _cacFile;
  File? _tinFile;
  File? _proofOfAddressFile;

  String? _cacUrl;
  String? _tinUrl;
  String? _proofOfAddressUrl;

  @override
  void dispose() {
    tinC.dispose();
    cacC.dispose();
    tinF.dispose();
    cacF.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.only(
              top: Sizer.height(30),
              bottom: Sizer.height(60),
            ),
            children: [
              Container(
                padding: EdgeInsets.all(Sizer.radius(8)),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.yellow8F),
                  borderRadius: BorderRadius.circular(Sizer.radius(4)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.yellow3D,
                    ),
                    XBox(8),
                    Expanded(
                      child: Text(
                        "Skip the document upload process if you do not have the documents",
                        style: textTheme.text12?.copyWith(
                          color: AppColors.neutral8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              YBox(24),
              CustomTextField(
                controller: cacC,
                focusNode: cacF,
                isRequired: false,
                labelText: 'CAC Number',
                hintText: 'Enter CAC number',
                showLabelHeader: true,
              ),
              YBox(20),
              UploadWidget(
                documentName: _cacFile?.path.split('/').last,
                isUploading: ref.watch(fileUploadVm).busy("cacUploadState"),
                buttomTextDesc:
                    "Upload a copy of your Corporate Affairs Commission Certificate",
                onUpload: () async {
                  final file = await ImageAndDocUtils.pickDocument();
                  if (file != null) {
                    _cacFile = file;
                    final r = await ref.read(fileUploadVm).uploadFile(
                        file: [file], busyObjectName: "cacUploadState");
                    _cacUrl = r.data?.first.url;
                    setState(() {});
                  }
                },
                onRemove: () {
                  _cacFile = null;
                  _cacUrl = null;
                  setState(() {});
                },
              ),
              YBox(20),
              CustomTextField(
                controller: tinC,
                focusNode: tinF,
                isRequired: false,
                labelText: 'TIN Number',
                hintText: 'Enter TIN number',
                showLabelHeader: true,
                keyboardType: TextInputType.number,
              ),
              YBox(20),
              UploadWidget(
                documentName: _tinFile?.path.split('/').last,
                buttomTextDesc:
                    "Upload a copy of your Tax Identification Certificate",
                isUploading: ref.watch(fileUploadVm).busy("tinUploadState"),
                onUpload: () async {
                  // Reset progress tracking for any previous uploads
                  ref.read(fileUploadVm).resetProgress();

                  final file = await ImageAndDocUtils.pickDocument();
                  if (file != null) {
                    _tinFile = file;
                    final r = await ref.read(fileUploadVm).uploadFile(
                        file: [file], busyObjectName: "tinUploadState");
                    _tinUrl = r.data?.first.url;
                  }
                },
                onRemove: () {
                  _tinFile = null;
                  _tinUrl = null;
                  setState(() {});
                },
              ),
              YBox(20),
              UploadWidget(
                labelText: 'Proof of Address',
                documentName: _proofOfAddressFile?.path.split('/').last,
                isUploading:
                    ref.watch(fileUploadVm).busy("proofOfAddressUploadState"),
                onUpload: () async {
                  final file = await ImageAndDocUtils.pickDocument();
                  if (file != null) {
                    _proofOfAddressFile = file;
                    final r = await ref.read(fileUploadVm).uploadFile(
                        file: [file],
                        busyObjectName: "proofOfAddressUploadState");
                    _proofOfAddressUrl = r.data?.first.url;
                    setState(() {});
                  }
                },
                onRemove: () {
                  _proofOfAddressFile = null;
                  _proofOfAddressUrl = null;
                  setState(() {});
                },
                buttomTextDesc:
                    "Upload a copy of your utility bill for proof of address",
              ),
              YBox(40),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: submitForm,
                    child: Text(
                      "Skip",
                      style: textTheme.text16?.copyWith(
                        color: colorScheme.primaryColor,
                      ),
                    )),
              )
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: CustomBtn.solid(
                isOutline: true,
                outlineColor: AppColors.neutral5,
                textStyle: textTheme.text16,
                text: "Previous",
                onTap: widget.onPrevious ?? () {},
              ),
            ),
            XBox(20),
            Expanded(
              child: CustomBtn.solid(
                text: "Next",
                onTap: submitForm,
              ),
            ),
          ],
        ),
        YBox(10),
      ],
    );
  }

  submitForm() async {
    final result = await ModalWrapper.bottomSheet(
      context: context,
      widget: ConfirmationModal(
        modalConfirmationArg: ModalConfirmationArg(
          iconPath: AppSvgs.infoCircle,
          title: "Submit Registration Form",
          description:
              "Are you sure you want to submit this form? Kindly check that all information is correctly filled.",
          solidBtnText: "Yes Submit",
          onSolidBtnOnTap: () {
            Navigator.pop(context, true);
          },
          onOutlineBtnOnTap: () {
            Navigator.pop(context, false);
          },
        ),
      ),
    );

    printty("result $result");

    if (result is bool && result) {
      _completeRegistration();
    }
  }

  void _completeRegistration() async {
    final onboardVm = ref.read(onboardVmodel);

    // Create media list and filter out null/empty values
    List<Media> mediaList = [];

    // CAC media
    if (_cacUrl != null && _cacUrl!.isNotEmpty) {
      mediaList.add(Media(
        name: "cac",
        url: _cacUrl,
        metadata: Iddata(identificationNumber: cacC.text.trim()),
      ));
    }

    // TIN media
    if (_tinUrl != null && _tinUrl!.isNotEmpty) {
      mediaList.add(Media(
        name: "tin",
        url: _tinUrl,
        metadata: Iddata(identificationNumber: tinC.text.trim()),
      ));
    }

    // Proof of Address media
    if (_proofOfAddressUrl != null && _proofOfAddressUrl!.isNotEmpty) {
      mediaList.add(Media(
        name: "proof_of_address",
        url: _proofOfAddressUrl,
      ));
    }

    final res = await onboardVm.completeOnboarding(
      onboardParams: OnboardParams(
        media: mediaList.isNotEmpty ? mediaList : null,
      ),
    );

    handleApiResponse(
      response: res,
      showSuccessToast: false,
      onSuccess: () {
        ModalWrapper.bottomSheet(
          context: context,
          canDismiss: false,
          widget: ConfirmationModal(
            modalConfirmationArg: ModalConfirmationArg(
              iconPath: AppSvgs.checkIcon,
              title: "Registration Form Submitted",
              description: res.data['message'],
              solidBtnText: "Okay",
              onSolidBtnOnTap: () {
                final ctx = NavKey.appNavKey.currentContext!;
                Navigator.pop(ctx);
                Navigator.pushNamedAndRemoveUntil(
                  ctx,
                  RoutePath.introScreen,
                  (r) => false,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
