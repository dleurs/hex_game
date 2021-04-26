import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hex_game/bloc/authentication/authentication_bloc.dart';
import 'package:hex_game/bloc/authentication/authentication_state.dart';
import 'package:hex_game/bloc/authentication/bloc.dart';
import 'package:hex_game/generated/l10n.dart';
import 'package:hex_game/ui/components/flutter_icon_com_icons.dart';
import 'package:hex_game/ui/screens/home_screen.dart';
import 'package:hex_game/ui/screens/login_register_screen.dart';
import 'package:hex_game/ui/screens/player_screen.dart';
import 'package:hex_game/ui/screens/players_screen.dart';
import 'package:hex_game/ui/screens/splash_screen.dart';
import 'package:hex_game/utils/keys_name.dart';

abstract class BaseScreenState<T extends StatefulWidget> extends State<T> {
  @protected
  Color get backgroundColor => Theme.of(context).backgroundColor;

  @override
  void initState() {
    super.initState();
    print("ScreenLifecycle: ${this.widget.toStringShort()}: initState ${this.toString()}");
  }

  @override
  void dispose() {
    super.dispose();
    print("ScreenLifecycle: ${this.widget.toStringShort()}: dispose ${this.toString()}");
  }

  @override
  void reassemble() {
    super.reassemble();
    print("ScreenLifecycle: ${this.widget.toStringShort()}: reassemble ${this.toString()}");
  }

  @override
  void deactivate() {
    super.deactivate();
    print("ScreenLifecycle: ${this.widget.toStringShort()}: deactivate ${this.toString()}");
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("ScreenLifecycle: ${this.widget.toStringShort()}: didUpdateWidget ${this.toString()}");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("ScreenLifecycle: ${this.widget.toStringShort()}: didChangeDependencies ${this.toString()}");
  }

  Widget syncUserFirebaseAuth(BuildContext context) {
    AuthenticationBloc authBloc = BlocProvider.of<AuthenticationBloc>(context);
    return FutureBuilder<bool>(
      future: authBloc.userAlreadyOpenApp(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshotUserAlreadyUsed) {
        if (snapshotUserAlreadyUsed.hasData) {
          bool userAlreadyOpenApp = snapshotUserAlreadyUsed.data ?? false;
          BlocProvider.of<AuthenticationBloc>(context).add(SynchroniseAuthentication());
          if (userAlreadyOpenApp == false) {
            return SplashScreen();
          } else {
            return buildScreen(context);
          }
        } else if (snapshotUserAlreadyUsed.hasData) {
          return SplashScreen(message: "Error userAlreadyOpenApp " + snapshotUserAlreadyUsed.error.toString());
        } else {
          return SplashScreen();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("ScreenLifecycle: ${this.widget.toStringShort()}: build ${this.toString()}");
    return BlocListener<AuthenticationBloc, AuthenticationState>(listener: (context, state) {
      if (state is LoggedOut) {
        this.onLoggedOut();
      } else if (state is AuthenticationSuccess) {
        this.onLoggedIn();
        // } else if (state is AuthenticationSuccessWithRefresh) {
      } else if (state is LoggingErrorWrongPassword) {
        this.onWrongPassword();
      }
    }, child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, authState) {
        return Scaffold(
          //backgroundColor: this.backgroundColor,
          appBar: this.buildAppBar(context),
          body: (authState is InitialAuthenticationState) ? syncUserFirebaseAuth(context) : this.buildScreen(context),
          bottomNavigationBar: this.buildBottomNavigationBar(context),
          floatingActionButton: this.buildFloatingActionButton(context),
        );
      },
    ));
  }

  Widget buildScreen(BuildContext context);

  Widget? buildLeading(BuildContext context) {
    return null;
  }

  ///
  /// Implement this to build an [AppBar] for all screens
  /// Override this method in each screen that needs a specific one
  ///
  PreferredSizeWidget? buildAppBar(BuildContext context) {
    AuthenticationBloc authBloc = BlocProvider.of<AuthenticationBloc>(context);
    return AppBar(
      title: TextButton(
        onPressed: () {
          Beamer.of(context).beamBack();
        },
        child: Text(
          S.of(context).hex_game_title,
          style: TextStyle(color: Colors.white, fontSize: Theme.of(context).textTheme.headline6!.fontSize),
        ),
      ),
      leading: buildLeading(context),
      actions: [
        IconButton(
          icon: Icon(FlutterIconCom.group),
          key: Key(KeysName.BASE_SCREEN_BUTTON_GOTO_PLAYERS),
          onPressed: () {
            Beamer.of(context).beamToNamed(PlayersScreen.uri.path);
          },
        ),
        IconButton(
          icon: Icon(FlutterIconCom.user),
          key: Key(KeysName.BASE_SCREEN_BUTTON_GOTO_PLAYER),
          onPressed: () {
            if (authBloc.isLoggedIn && (authBloc.pseudo?.isNotEmpty ?? false)) {
              Beamer.of(context).beamToNamed(PlayerScreen.uri(playerPseudo: authBloc.pseudo).path);
            } else {
              Beamer.of(context).beamToNamed(LoginRegisterScreen.uri.path);
            }
          },
        )
      ],
    );
  }

  ///
  /// Implement this to build a [BottomNavigationBar] for all screens
  /// Override this method in each screen that needs a specific one
  ///
  Widget? buildBottomNavigationBar(BuildContext context) {
    return null;
  }

  ///
  /// Implement this to build a [FloatingActionButton] for all screens
  /// Override this method in each screen that needs a specific one
  ///
  Widget? buildFloatingActionButton(BuildContext context) {
    return null;
  }

  ///
  /// Default back navigation behavior
  ///
  void goBack() {
    Beamer.of(context).beamBack();
  }

  ///
  /// Sends a log in event
  ///
  void doLogin(String login, String password) {
    print("doLogin");
    //BlocProvider.of<AuthenticationBloc>(context)
    //    .add(LoginEvent(login: login, password: password));
  }

  ///
  /// Sends a logout event
  ///
  void doLogout() {
    print("doLogout");
    //BlocProvider.of<AuthenticationBloc>(context).add(LogoutEvent());
  }

  ///
  /// Logout event has completed
  /// Clear all navigation history and push login page
  /// Override this method to implement how the app should behave
  /// once a user has been logged out
  ///
  void onLoggedOut() {
    print("OnLoggedOut");
    Beamer.of(context).beamToNamed(HomeScreen.uri.path);
    //Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (r) => false);
  }

  ///
  /// Log in event has completed
  /// Override this method to implement how the app should behave
  /// once a user has been logged in
  ///
  void onLoggedIn() {
    print("OnLoggedIn");
    Beamer.of(context).beamToNamed(HomeScreen.uri.path);
  }

  void onWrongPassword() {
    print("OnWrongPassword");
  }
}
