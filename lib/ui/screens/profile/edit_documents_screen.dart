// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class EditDocumentsScreen extends ConsumerStatefulWidget {
  const EditDocumentsScreen({super.key, required this.documents});

  final Documents documents;

  @override
  ConsumerState<EditDocumentsScreen> createState() =>
      _EditDocumentsScreenState();
}

class _EditDocumentsScreenState extends ConsumerState<EditDocumentsScreen> {
  final formKey = GlobalKey<FormState>();
  final cacNumberC = TextEditingController();
  final tinNumberC = TextEditingController();

  File? _cacFile;
  File? _tinFile;
  File? _proofOfAddressFile;

  String? _cacUrl;
  String? _tinUrl;
  String? _proofOfAddressUrl;

  // Track originals and change state
  Map<String, dynamic> _originalValues = {};
  bool _hasChanges = false;

  @override
  void initState() {
    // Store original values
    _originalValues = {
      'cacIdentifier': widget.documents.cac?.identifier ?? '',
      'cacUrl': widget.documents.cac?.file,
      'tinIdentifier': widget.documents.tin?.identifier ?? '',
      'tinUrl': widget.documents.tin?.file,
      'proofOfAddressUrl': widget.documents.proofOfAddress,
    };

    cacNumberC.text = _originalValues['cacIdentifier'] ?? '';
    tinNumberC.text = _originalValues['tinIdentifier'] ?? '';

    _cacUrl = _originalValues['cacUrl'];
    _tinUrl = _originalValues['tinUrl'];
    _proofOfAddressUrl = _originalValues['proofOfAddressUrl'];

    super.initState();
    cacNumberC.addListener(_checkForChanges);
    tinNumberC.addListener(_checkForChanges);
  }

  @override
  void dispose() {
    cacNumberC.removeListener(_checkForChanges);
    tinNumberC.removeListener(_checkForChanges);
    cacNumberC.dispose();
    tinNumberC.dispose();

    super.dispose();
  }

  void _checkForChanges() {
    final currentValues = {
      'cacIdentifier': cacNumberC.text.trim(),
      'cacUrl': _cacUrl,
      'tinIdentifier': tinNumberC.text.trim(),
      'tinUrl': _tinUrl,
      'proofOfAddressUrl': _proofOfAddressUrl,
    };
    bool changed = false;
    for (final k in _originalValues.keys) {
      if (_originalValues[k] != currentValues[k]) {
        changed = true;
        break;
      }
    }
    if (_hasChanges != changed) {
      setState(() {
        _hasChanges = changed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final profileVm = ref.watch(vendorProfileVmodel);
    return BusyOverlay(
      show: profileVm.busy(updateState),
      child: Scaffold(
          appBar: CustomAppbar(
            title: "Edit Request",
          ),
          body: Form(
            key: formKey,
            child: ListView(
              padding: EdgeInsets.only(
                left: Sizer.width(16),
                right: Sizer.width(16),
                bottom: Sizer.height(50),
              ),
              children: [
                YBox(16),
                Container(
                  padding: EdgeInsets.all(Sizer.radius(16)),
                  decoration: BoxDecoration(
                    color: colorScheme.white,
                    borderRadius: BorderRadius.circular(Sizer.radius(4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Document Uploads", style: textTheme.text16?.medium),
                      Text(
                        "Edit information and submit for approval",
                        style: textTheme.text12?.copyWith(
                          color: colorScheme.black45,
                        ),
                      ),
                      YBox(16),
                      CustomTextField(
                        controller: cacNumberC,
                        labelText: 'CAC Number',
                        showLabelHeader: true,
                      ),
                      YBox(10),
                      UploadWidget(
                        labelText: 'Certificate:',
                        documentName: _cacUrl ?? _cacFile?.path.split('/').last,
                        isUploading:
                            ref.watch(fileUploadVm).busy("cacUploadState"),
                      onUpload: () async {
                        final file = await ImageAndDocUtils.pickDocument();
                        if (file != null) {
                          _cacFile = file;
                          final r = await ref.read(fileUploadVm).uploadFile(
                              file: [file], busyObjectName: "cacUploadState");
                          _cacUrl = r.data?.first.url;
                          setState(() {});
                          _checkForChanges();
                        }
                      },
                      onRemove: () {
                        _cacFile = null;
                        _cacUrl = null;
                        setState(() {});
                        _checkForChanges();
                      },
                    ),
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Text(
                      //       "Certificate: ",
                      //       style: textTheme.text14
                      //           ?.copyWith(fontWeight: FontWeight.w500),
                      //     ),
                      //     YBox(4),
                      //     Container(
                      //       padding: EdgeInsets.symmetric(
                      //         horizontal: Sizer.width(16),
                      //         vertical: Sizer.height(10),
                      //       ),
                      //       decoration: BoxDecoration(
                      //         border: Border.all(color: AppColors.neutral5),
                      //         borderRadius:
                      //             BorderRadius.circular(Sizer.radius(2)),
                      //       ),
                      //       child: Row(
                      //         children: [
                      //           SvgPicture.asset(
                      //             AppSvgs.iconAttachment,
                      //             height: Sizer.height(14),
                      //           ),
                      //           SizedBox(width: 8),
                      //           Expanded(
                      //             child: Text(
                      //               AppUtils.getDisplayFileName(
                      //                   widget.documents.cac?.file),
                      //               maxLines: 1,
                      //               overflow: TextOverflow.ellipsis,
                      //               style: textTheme.text14?.copyWith(
                      //                 color: colorScheme.primaryColor,
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      YBox(16),
                      CustomTextField(
                        controller: tinNumberC,
                        labelText: 'TIN Number',
                        showLabelHeader: true,
                      ),
                      YBox(10),
                      UploadWidget(
                        labelText: 'Certificate:',
                        documentName: _tinUrl ?? _tinFile?.path.split('/').last,
                        isUploading:
                            ref.watch(fileUploadVm).busy("tinUploadState"),
                      onUpload: () async {
                        final file = await ImageAndDocUtils.pickDocument();
                        if (file != null) {
                          _tinFile = file;
                          final r = await ref.read(fileUploadVm).uploadFile(
                              file: [file], busyObjectName: "tinUploadState");
                          _tinUrl = r.data?.first.url;
                          setState(() {});
                          _checkForChanges();
                        }
                      },
                      onRemove: () {
                        _tinFile = null;
                        _tinUrl = null;
                        setState(() {});
                        _checkForChanges();
                      },
                    ),
                      YBox(20),
                      UploadWidget(
                        labelText: 'Proof of Address:',
                        documentName: _proofOfAddressUrl ??
                            _proofOfAddressFile?.path.split('/').last,
                        isUploading: ref
                            .watch(fileUploadVm)
                            .busy("proofOfAddressUploadState"),
                      onUpload: () async {
                        final file = await ImageAndDocUtils.pickDocument();
                        if (file != null) {
                          _proofOfAddressFile = file;
                          final r = await ref.read(fileUploadVm).uploadFile(
                              file: [file],
                              busyObjectName: "proofOfAddressUploadState");
                          _proofOfAddressUrl = r.data?.first.url;
                          setState(() {});
                          _checkForChanges();
                        }
                      },
                      onRemove: () {
                        _proofOfAddressFile = null;
                        _proofOfAddressUrl = null;
                        setState(() {});
                        _checkForChanges();
                      },
                    ),
                      YBox(30),
                      CustomBtn.solid(
                        text: "Submit",
                        online: _hasChanges,
                        onTap: () {
                          if (_hasChanges &&
                              formKey.currentState?.validate() == true) {
                            _submitForm();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  _submitForm() async {
    final vendorRef = ref.read(vendorProfileVmodel);

    // Build media list only for changed entries
    final List<Media> mediaList = [];

    final cacChanged =
        (_originalValues['cacIdentifier'] != cacNumberC.text.trim()) ||
            (_originalValues['cacUrl'] != _cacUrl);
    if (cacChanged) {
      mediaList.add(Media(
        name: "cac",
        url: _cacUrl ?? "",
        metadata: Iddata(identificationNumber: cacNumberC.text.trim()),
      ));
    }

    final tinChanged =
        (_originalValues['tinIdentifier'] != tinNumberC.text.trim()) ||
            (_originalValues['tinUrl'] != _tinUrl);
    if (tinChanged) {
      mediaList.add(Media(
        name: "tin",
        url: _tinUrl ?? "",
        metadata: Iddata(identificationNumber: tinNumberC.text.trim()),
      ));
    }

    final poaChanged =
        (_originalValues['proofOfAddressUrl'] != _proofOfAddressUrl);
    if (poaChanged) {
      mediaList.add(Media(
        name: "proof_of_address",
        url: _proofOfAddressUrl ?? "",
      ));
    }

    final res = await vendorRef.updateVendorProfile(
      VendorProfileParams(
        media: mediaList.isNotEmpty ? mediaList : null,
      ),
    );

    handleApiResponse(
      response: res,
      onSuccess: () {
        Navigator.pop(context);
        ref.read(vendorProfileVmodel).getVendorProfile();
      },
    );
  }
}
