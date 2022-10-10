import 'package:fb_users/l10n/l10n.dart';
import 'package:fb_users/ui/add_user/cubit/add_user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddUserForm extends StatelessWidget {
  const AddUserForm({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<AddUserCubit, AddUserState>(
      builder: (context, state) {
        return Form(
          key: context.read<AddUserCubit>().formKey,
          autovalidateMode: state.formValidationMode,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  controller: state.nameController,
                  validator: (value) =>
                  value?.isEmpty ?? false ? l10n.errorName : null,
                  decoration: InputDecoration(
                    label: Text(l10n.labelName),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  controller: state.cityController,
                  validator: (value) =>
                  value?.isEmpty ?? false ? l10n.errorCity : null,
                  decoration: InputDecoration(
                    label: Text(l10n.labelCity),
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  onChanged: context.read<AddUserCubit>().onProfessionChange,
                  value: state.profession,
                  validator: (value) {
                    return value == null ? l10n.errorProfession : null;
                  },
                  decoration: InputDecoration(
                    label: Text(l10n.labelProfession),
                  ),
                  items: context
                      .watch<AddUserCubit>()
                      .professions
                      .map(
                        (e) => DropdownMenuItem<String>(
                      value: e,
                      child: Text(e),
                    ),
                  )
                      .toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
