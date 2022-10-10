part of 'add_user_cubit.dart';

enum UiStatus { initial, loading, loaded, failure }

class AddUserState extends Equatable {
  const AddUserState({
    required this.formValidationMode,
    required this.nameController,
    required this.cityController,
    this.profession,
    this.user,
    this.isEditMode = false,
    this.uiStatus = UiStatus.initial,
  });

  final AutovalidateMode formValidationMode;
  final TextEditingController nameController;
  final TextEditingController cityController;
  final String? profession;
  final User? user;
  final bool isEditMode;
  final UiStatus uiStatus;

  AddUserState copyWith({
    AutovalidateMode? formValidationMode,
    TextEditingController? nameController,
    TextEditingController? cityController,
    String? profession,
    User? user,
    bool? isEditMode,
    UiStatus? uiStatus,
  }) {
    return AddUserState(
      formValidationMode: formValidationMode ?? this.formValidationMode,
      nameController: nameController ?? this.nameController,
      cityController: cityController ?? this.cityController,
      profession: profession ?? this.profession,
      user: user ?? this.user,
      isEditMode: isEditMode ?? this.isEditMode,
      uiStatus: uiStatus ?? this.uiStatus,
    );
  }

  @override
  List<Object?> get props => [
        formValidationMode,
        nameController,
        cityController,
        profession,
        user,
        isEditMode
      ];
}

class AddUserInitial extends AddUserState {
  AddUserInitial({User? user})
      : super(
          formValidationMode: user != null
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          nameController: TextEditingController()..text = user?.name ?? '',
          cityController: TextEditingController()..text = user?.city ?? '',
          profession: user?.profession,
          isEditMode: user != null,
        );

  @override
  List<Object> get props => [];
}
