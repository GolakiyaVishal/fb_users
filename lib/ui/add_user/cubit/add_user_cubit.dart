import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fb_users/data/models/user.dart';
import 'package:fb_users/data/user_repository.dart';
import 'package:flutter/cupertino.dart';

part 'add_user_state.dart';

class AddUserCubit extends Cubit<AddUserState> {
  AddUserCubit(this.userRepository, {this.user, this.userId})
      : super(AddUserInitial(user: user));

  final UserRepository userRepository;
  User? user;
  String? userId;

  List<String> professions = ['IT', 'Account', 'Management', 'Sports', 'Legal'];
  GlobalKey<FormState> formKey = GlobalKey();

  void onAddUserTap(BuildContext context, {int? index}) {
    emit(
      state.copyWith(
        formValidationMode: AutovalidateMode.always,
        uiStatus: UiStatus.loading,
      ),
    );

    if (formKey.currentState?.validate() ?? false) {
      final user = User(
        name: state.nameController.text,
        city: state.cityController.text,
        profession: state.profession!,
      );
      if (state.isEditMode) {
        userRepository
            .updateItem(user, userId!)
            .then((value) => Navigator.pop(context));
      } else {
        userRepository.addNewItem(user).then((value) => Navigator.pop(context));
      }
    }
  }

  void onProfessionChange(String? profession) {
    emit(state.copyWith(profession: profession));
  }
}
