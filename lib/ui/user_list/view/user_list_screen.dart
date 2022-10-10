import 'package:fb_users/data/models/user.dart';
import 'package:fb_users/data/user_repository.dart';
import 'package:fb_users/l10n/l10n.dart';
import 'package:fb_users/ui/user_list/cubit/user_list_cubit.dart';
import 'package:fb_users/ui/user_list/cubit/user_list_state.dart';
import 'package:fb_users/ui/user_list/view/empty_list_view.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserListCubit(UserRepository())..getUsers(),
      child: const UserView(),
    );
  }
}

class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.userAppBarTitle)),
      body: BlocBuilder<UserListCubit, UserListState>(
        builder: (context, state) {
          // onInitial state show empty view
          if (UiStatus.initial ==
              context.watch<UserListCubit>().state.uiStatus) {
            return const EmptyListView();
          }

          // for any error show error dialog
          if (state.error != null) {
            Fluttertoast.showToast(
              msg: state.error ?? context.l10n.commonErrorText,
            );
          }

          return const Center(child: UserListView());
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => context.read<UserListCubit>().addNewUser(context),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class UserListView extends StatelessWidget {
  const UserListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        if (UiStatus.loading == context.watch<UserListCubit>().state.uiStatus)
          const LinearProgressIndicator(),

        Expanded(
          child: FirebaseAnimatedList(
            query: context.read<UserListCubit>().userRepository.getAllItems(),
            itemBuilder: (context, snapshot, animation, index) {
              debugPrint('snapshot :: ${snapshot.value}');

              final json = snapshot.value! as Map<dynamic, dynamic>;
              final user = User.fromJson(json);

              return ListTile(
                key: UniqueKey(),
                title: Text('${user.name} - ${user.profession}'),
                subtitle: Text(user.city),
                onTap: () =>
                    context.read<UserListCubit>().userTap(context, user, index),
                trailing: IconButton(
                        icon: const Icon(Icons.delete_forever),
                        onPressed: () =>
                            context.read<UserListCubit>().onDeleteTap(index),
                      ),
              );
            },
          ),
        ),
      ],
    );
  }
}
