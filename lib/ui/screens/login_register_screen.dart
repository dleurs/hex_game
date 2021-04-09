import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hex_game/core/authentication/firebase_user.dart';
import 'package:hex_game/core/firebase_user_storage.dart';
import 'package:hex_game/generated/l10n.dart';
import 'package:hex_game/models/player.dart';
import 'package:hex_game/ui/components/const.dart';
import 'package:hex_game/ui/components/flutter_icon_com_icons.dart';
import 'package:hex_game/ui/components/main_scaffold.dart';
import 'package:hex_game/ui/screens/player_screen.dart';
import 'package:hex_game/utils/form_validator.dart';
import 'package:hex_game/utils/helpers.dart';
import 'package:hex_game/utils/log.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LoginRegisterScreen extends StatefulWidget {
  static final BeamPage beamLocation = BeamPage(
    key: ValueKey(LoginRegisterScreen.uri.path),
    child: LoginRegisterScreen(),
  );
  static final Uri uri = Uri(path: "/player");

  @override
  _LoginRegisterScreenState createState() => _LoginRegisterScreenState();
}

enum LoginRegistersStep { enterEmail, login, register }

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _email = new TextEditingController();
  TextEditingController _pseudo = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  bool _showPasswordEyeIcon = false;
  bool _passwordObscur = true;
  LoginRegistersStep _step = LoginRegistersStep.enterEmail;
  bool _wrongPassword = false;
  bool _loading = false;

  TextFormField email() {
    return TextFormField(
      readOnly: (_step == LoginRegistersStep.login ||
          _step == LoginRegistersStep.register),
      style: TextStyle(
          color: (_step == LoginRegistersStep.login ||
                  _step == LoginRegistersStep.register)
              ? Colors.grey[600]
              : Colors.black),
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: _email,
      validator: FormValidators.validateEmail,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.email,
          color: Colors.grey,
        ),
        suffixIcon: (_step == LoginRegistersStep.login ||
                _step == LoginRegistersStep.register)
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _email.text = "";
                    _password.text = "";
                    _step = LoginRegistersStep.enterEmail;
                  });
                },
                icon: Icon(Icons.cached_outlined))
            : null,
        hintText: 'Email', //TODO INTL
        contentPadding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onChanged: (String email) {},
    );
  }

  Widget buttonValidateEmail(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: 120, height: 50),
      child: ElevatedButton(
        child: !_loading
            ? Text(
                'Enter', //TODO INTL
                style: TextStyle(
                    fontSize: Theme.of(context).textTheme.headline6?.fontSize),
              )
            : CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
        onPressed: () async {
          if (_formKey.currentState?.validate() ?? false) {
            setState(() {
              _loading = true;
            });
            print("Checking if email " + _email.text + " is already used");
            bool isEmailAlreadyUsed =
                await FirestoreUserStorage.isEmailAlreadyUsed(
                    email: _email.text);
            print("isEmailAlreadyUsed : " + isEmailAlreadyUsed.toString());

            setState(() {
              (isEmailAlreadyUsed)
                  ? _step = LoginRegistersStep.login
                  : _step = LoginRegistersStep.register;
              _loading = false;
            });
          }
        },
      ),
    );
  }

  TextFormField pseudo() {
    return TextFormField(
      readOnly: (_step == LoginRegistersStep.login),
      style: TextStyle(
          color: (_step == LoginRegistersStep.login)
              ? Colors.grey[600]
              : Colors.black),
      keyboardType: TextInputType.text,
      autofocus: false,
      controller: _pseudo,
      validator: FormValidators.validatePseudo,
      decoration: InputDecoration(
        prefixIcon: Icon(
          FlutterIconCom.user,
          color: Colors.grey,
        ),
        hintText: 'Pseudo', //TODO INTL
        contentPadding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onChanged: (String email) {},
    );
  }

  TextFormField password(BuildContext context) {
    return TextFormField(
      autofocus: false,
      obscureText: _passwordObscur,
      controller: _password,
      validator: (password) {
        return FormValidators.validatePassword(password);
      },
      onChanged: (String password) {
        //BlocProvider.of<AuthenticationBloc>(context).add(ResetEvent());
        setState(() {
          _showPasswordEyeIcon = true;
          _wrongPassword = false;
        });
      },
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.lock,
          color: Colors.grey,
        ), // icon is 48px widget.
        errorText: (_wrongPassword) ? "Wrong password." : null,

        suffixIcon: _showPasswordEyeIcon
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _passwordObscur = !_passwordObscur;
                  });
                },
                icon: Icon(Icons.remove_red_eye_outlined))
            : SizedBox(), // icon is 48px widget.

        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.mediumHeight)),
      ),
    );
  }

  Widget buttonValidateEmailPseudoPassword({required BuildContext context}) {
    if (_step == LoginRegistersStep.enterEmail) {
      return SizedBox();
    }
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: 120, height: 50),
      child: ElevatedButton(
        child: !_loading
            ? Text(
                _step == LoginRegistersStep.login
                    ? 'Login'
                    : 'Register', //TODO INTL
                style: TextStyle(
                    fontSize: Theme.of(context).textTheme.headline6?.fontSize),
              )
            : CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
        onPressed: () async {
          if (_formKey.currentState?.validate() ?? false) {
            setState(() {
              _loading = true;
            });
            try {
              if (_step == LoginRegistersStep.register) {
                Player? newPlayer = await FirestoreUserStorage
                    .createUserWithPseudoEmailAndPassword(
                        pseudo: _pseudo.text,
                        email: _email.text,
                        password: _password.text,
                        context: context);
                print("newPlayer : " + newPlayer.toString());
              } else if (_step == LoginRegistersStep.login) {
                await FirebaseUser.signIn(
                    email: _email.text, password: _password.text);
                print("Player logged");
              }
            } catch (e) {
              print("Error : " + e.toString());
            }

            setState(() {
              _loading = false;
            });
          }
        },
      ),
    );
  }

  Widget formLoginRegisterPlayer() {
    return Form(
      key: _formKey,
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: AppDimensions.xSmallHeight),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ConstrainedBox(
              constraints:
                  BoxConstraints(maxWidth: AppDimensions.smallScreenSize),
              child: SingleChildScrollView(child: Column(
                children: toList(() sync* {
                  yield SizedBox(height: AppDimensions.mediumHeight);
                  yield email();
                  if (_step == LoginRegistersStep.enterEmail) {
                    yield SizedBox(height: AppDimensions.mediumHeight);
                    yield buttonValidateEmail(context);
                    yield SizedBox(height: AppDimensions.mediumHeight);
                  } else if (_step == LoginRegistersStep.login) {
                    yield Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 12.0),
                      child: Text(
                        "TODO (Email found)", //TODO INTL,
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.headline6?.fontSize,
                          color: AppColors.green,
                        ),
                      ),
                    );
                  } else if (_step == LoginRegistersStep.register) {
                    yield Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 12.0),
                      child: Text(
                        "TODO New email", //TODO INTL,
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.headline6?.fontSize,
                          color: AppColors.grey,
                        ),
                      ), //TODO INTL,
                    );
                    yield pseudo();
                    yield SizedBox(height: AppDimensions.mediumHeight);
                  }
                  //yield CircularProgressIndicator();
                  if (_step == LoginRegistersStep.login ||
                      _step == LoginRegistersStep.register) {
                    yield password(context);
                    yield SizedBox(height: AppDimensions.mediumHeight);
                    yield buttonValidateEmailPseudoPassword(context: context);
                  }
                }),
              )),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      body: Consumer<User?>(builder: (context, user, child) {
        if (user == null || user.isAnonymous) {
          return formLoginRegisterPlayer();
        } else {
          return Text('Wrong page, you are already connected');
        }
      }),
    );
  }
}
