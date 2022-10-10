import 'package:bloc/bloc.dart';
import 'package:fb_users/data/models/user.dart';
import 'package:fb_users/data/user_repository.dart';
import 'package:fb_users/ui/add_user/view/add_user_screen.dart';
import 'package:fb_users/ui/user_list/cubit/user_list_state.dart';
import 'package:fb_users/utils/internet_connection.dart';
import 'package:flutter/material.dart';

class UserListCubit extends Cubit<UserListState> {
  UserListCubit(this.userRepository) : super(UserListState.empty());

  final UserRepository userRepository;
  final List<String> _userIds = [];

  void addNewUser(BuildContext context) {
    Navigator.push(context, AddUserScreen.route()).then((value){
      getUsers();
      emit(state.copyWith(uiStatus: UiStatus.loaded));
    });
  }

  void userTap(BuildContext context, User user, int index) {
    Navigator.push(
      context,
      AddUserScreen.route(
        user: user,
        userId: _userIds[index],
      ),
    ).then((value) {
      emit(
        state.copyWith(
          uiStatus: UiStatus.loaded,
        ),
      );
    });
  }

  void getUsers() {
    checkAndCall(() async {
      try {
        final resp = await userRepository.getUsersId();
        if (resp != null) {
          final list = resp[0];
          if (list is List<String>) {
            _userIds..clear()
            ..addAll(list);
          }


          final list2 = resp[1];
          if (list2 is List<User>) {
            emit(
              state.copyWith(
                uiStatus: UiStatus.loaded,
                // shoppingList: l1,
              ),
            );
          }
        } else {
          emit(
            state.copyWith(
              uiStatus: UiStatus.initial,
            ),
          );
        }
      } catch (exception) {
        onException(exception);
      }
    });
  }

  // for the warning: check change only support nullable variable
  Future<void> onItemCheckChange({
    required User item,
    required int index,
  }) async {
    emit(state.copyWith(uiStatus: UiStatus.loading));
    try {
      await userRepository.updateItem(item, _userIds[index]);
      emit(
        state.copyWith(
          uiStatus: UiStatus.loaded,
        ),
      );
    } catch (exception) {
      onException(exception);
    }
  }

  // delete shopping item
  Future<void> onDeleteTap(int index) async {
    emit(state.copyWith(uiStatus: UiStatus.loading));
    try {
      await userRepository.deleteItem(_userIds[index]);

      _userIds.removeAt(index);

      print('_userIds :: $_userIds');

      emit(
        state.copyWith(
          uiStatus: _userIds.isEmpty ? UiStatus.initial : UiStatus.loaded,
        ),
      );
    } catch (exception) {
      onException(exception);
    }
  }

  // before api call check for internet connection
  void checkAndCall(void Function() call) {
    InternetConnection.check().then((value) {
      if (value) {
        call();
      } else {
        emit(
          state.copyWith(
            uiStatus: UiStatus.failure,
            error: 'No internet connection, Please try again',
          ),
        );
      }
    });
  }

  // handle all exception and update screen state
  void onException(dynamic exception) {
    debugPrint('onException:: $onException');
    emit(
      state.copyWith(
        uiStatus: UiStatus.failure,
        error: exception.toString(),
      ),
    );
  }
}
