import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:notify/src/settings/api_service/api_service.dart';
import 'package:notify/src/settings/api_service/middleware/api_service_exception.dart';
import 'package:notify/src/settings/sus_service/sus_service.dart';
import 'package:notify/src/settings/sus_service/user_folders_state.dart';

class CreateFolderView extends StatefulWidget {
  const CreateFolderView({Key? key}) : super(key: key);

  static const routeName = 'create_folder_view';

  @override
  State<CreateFolderView> createState() => _CreateFolderViewState();
}

class _CreateFolderViewState extends State<CreateFolderView> {
  bool foolproofSubmitButton = true;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

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
        title: Text(AppLocalizations.of(context)!.createFolder),
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
            await ApiService.folders.post(
              title: _titleController.text.trim(),
              description: _descriptionController.text.trim(),
            );
            Provider.of<UserFoldersState>(context, listen: false).load();
            Navigator.of(context).pop(true);
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
