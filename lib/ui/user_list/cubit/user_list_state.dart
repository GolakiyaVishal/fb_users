import 'package:equatable/equatable.dart';
import 'package:fb_users/data/models/user.dart';
import 'package:flutter/material.dart';

/// [UserListState]
/// A State class for cubit

enum UiStatus { initial, loading, loaded, failure }

@immutable
class UserListState extends Equatable {
  const UserListState({
    this.uiStatus = UiStatus.initial,
    this.error,
  });

  UserListState.empty()
      : uiStatus = UiStatus.loading,
        error = null;

  final UiStatus uiStatus;
  final String? error;

  UserListState copyWith({
    UiStatus? uiStatus,
    String? error,
    List<User>? userList,
  }) {
    return UserListState(
      uiStatus: uiStatus ?? this.uiStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [uiStatus, error];
}