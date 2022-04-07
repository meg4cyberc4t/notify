import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:notify/src/models/notify_folder_quick.dart';
import 'package:notify/src/settings/api_service/api_service.dart';
import 'package:notify/src/settings/api_service/middleware/api_service_exception.dart';
import 'package:notify/src/settings/sus_service/sus_service.dart';
import 'package:notify/src/settings/sus_service/user_folders_state.dart';

class EditFolderView extends StatefulWidget {
  const EditFolderView({required this.folder, Key? key}) : super(key: key);
  final NotifyFolderQuick folder;

  static const routeName = 'edit_folder_view';

  @override
  State<EditFolderView> createState() => _EditFolderViewState();
}

class _EditFolderViewState extends State<EditFolderView> {
  bool foolproofSubmitButton = true;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    _titleController.text = widget.folder.title;
    _descriptionController.text = widget.folder.description;
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folder.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Wrap(
              runSpacing: 8,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.title,
                    counterText: '',
                  ),
                  maxLength: 50,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.enterSomeText;
                    }
                    return null;
                  },
                  autofocus: true,
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.description,
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                  minLines: 1,
                  controller: _descriptionController,
                  textInputAction: TextInputAction.next,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () async {
          if (!_formKey.currentState!.validate()) return;
          if (!foolproofSubmitButton) return;
          foolproofSubmitButton = false;
          try {
            await ApiService.folders.put(
              uuid: widget.folder.id,
              title: _titleController.text.trim(),
              description: _descriptionController.text.trim(),
            );
            Provider.of<FolderViewLocalState>(context, listen: false)
                .updateState();
            Provider.of<UserFoldersState>(context, listen: false).load();
            Navigator.of(context).pop();
          } on ApiServiceException catch (err) {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(err.message),
            ));
          }
          foolproofSubmitButton = true;
        },
      ),
    );
  }
}
