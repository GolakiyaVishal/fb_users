import 'package:fb_users/data/models/user.dart';
import 'package:fb_users/data/user_repository.dart';
import 'package:fb_users/l10n/l10n.dart';
import 'package:fb_users/ui/add_user/cubit/add_user_cubit.dart';
import 'package:fb_users/ui/add_user/view/add_user_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddUserScreen extends StatelessWidget {
  const AddUserScreen({super.key});

  static Route<void> route({User? user, String? userId}) {
    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) =>
            AddUserCubit(UserRepository(), user: user, userId: userId),
        child: const AddUserScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const AddUserContent();
  }
}

class AddUserContent extends StatelessWidget {
  const AddUserContent({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.addUserAppBarTitle)),
      bottomNavigationBar: BlocBuilder<AddUserCubit, AddUserState>(
        builder: (context, state) {
          return BottomAppBar(
            elevation: 0,
            child: TextButton(
              onPressed: () =>
                  context.read<AddUserCubit>().onAddUserTap(context),
              child: Text(
                state.isEditMode
                    ? l10n.buttonTextEditUser
                    : l10n.buttonTextAddUser,
              ),
            ),
          );
        },
      ),
      body: const AddUserForm(),
    );
  }
}
