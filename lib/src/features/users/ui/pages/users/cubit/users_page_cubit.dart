import 'dart:async';

import 'package:bandasybandas/src/core/usecases/usecase.dart';
import 'package:bandasybandas/src/features/users/domain/usecases/users_usecases.dart';
import 'package:bandasybandas/src/features/users/ui/pages/users/cubit/users_page_state.dart';
import 'package:bandasybandas/src/shared/models/user.dart';
import 'package:bloc/bloc.dart';

class UsersPageCubit extends Cubit<UsersPageState> {
  UsersPageCubit({
    required this.getUsers,
    required this.addUserUseCase,
  }) : super(UsersPageInitial());

  final GetUsers getUsers;
  final AddUser addUserUseCase;
  StreamSubscription<List<AppUser>>? _usersSubscription;

  Future<void> loadUsers() async {
    emit(UsersPageLoading());

    final result = await getUsers(NoParams());

    result.fold(
      (failure) => emit(
        UsersPageError(
          'Falló la carga inicial de usuarios: ${failure.message}',
        ),
      ),
      (usersStream) {
        _usersSubscription?.cancel();
        _usersSubscription = usersStream.listen((users) {
          emit(UsersPageLoaded(users));
        });
      },
    );
  }

  Future<void> addUser(AppUser user) async {
    // No se emite un estado de carga aquí para no bloquear toda la UI.
    // La actualización de la lista se manejará por el stream.
    final result = await addUserUseCase(user);

    result.fold(
      (failure) => emit(
        UsersPageError('Falló al agregar el usuario: ${failure.message}'),
      ),
      (_) {}, // En caso de éxito, no hacemos nada, el stream actualizará la UI.
    );
  }

  @override
  Future<void> close() {
    _usersSubscription?.cancel();
    return super.close();
  }
}
