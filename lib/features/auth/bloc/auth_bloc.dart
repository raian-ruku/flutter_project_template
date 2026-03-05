
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final DioClient? dc;
  final AuthRepo ar;
  AuthBloc({required this.dc, required this.ar}) : super(AuthState()) {
    // * login
    on<LoginEvent>((event, emit) async {
      emit(state.copyWith(loginStatus: .loading));

      ApiResponse r = await ar.login(body: event.body);
      if (r.response != null && r.response!.statusCode == 200) {
        ar.saveAccessToken(r.response!.data['data']['token']);
       // * emit your states
      } else {
       
      }
    });
    // * log out
    on<LogoutEvent>((event, emit) async {
      await ar.clearAccessToken();
      emit(AuthState());
    });
  }
}
