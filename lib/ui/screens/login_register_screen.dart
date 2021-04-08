import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hex_game/core/authentication/user_firebase.dart';
import 'package:hex_game/generated/l10n.dart';
import 'package:hex_game/ui/components/const.dart';
import 'package:hex_game/ui/components/main_scaffold.dart';
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
  static final Uri uri = Uri(path: "/welcome");

  @override
  _LoginRegisterScreenState createState() => _LoginRegisterScreenState();
}

enum LoginRegistersStep { enterEmail, login, register }

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _email = new TextEditingController();
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
              ? Colors.grey[700]
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
                await UserFirebase.isEmailAlreadyUsed(email: _email.text);
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

  Widget buttonValidateEmailPassword(
      {required BuildContext context, required LoginRegistersStep step}) {
    if (step == LoginRegistersStep.enterEmail) {
      return SizedBox();
    }
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: 120, height: 50),
      child: ElevatedButton(
        child: !_loading
            ? Text(
                step == LoginRegistersStep.login
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
            print("Checking if email " + _email.text + " is already used");
            bool isEmailAlreadyUsed =
                await UserFirebase.isEmailAlreadyUsed(email: _email.text);
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

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      body: Consumer<User?>(builder: (context, user, child) {
        return Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.xSmallHeight),
            child: Center(
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(maxWidth: AppDimensions.smallScreenSize),
                child: SingleChildScrollView(child: Column(
                  children: toList(() sync* {
                    yield SizedBox(height: AppDimensions.mediumHeight);
                    yield email();
                    yield SizedBox(height: AppDimensions.mediumHeight);
                    if (_step == LoginRegistersStep.enterEmail) {
                      yield buttonValidateEmail(context);
                      yield SizedBox(height: AppDimensions.mediumHeight);
                    }
                    //yield CircularProgressIndicator();
                    if (_step == LoginRegistersStep.login ||
                        _step == LoginRegistersStep.register) {
                      yield password(context);
                      yield SizedBox(height: AppDimensions.mediumHeight);
                    }
                  }),
                )),
              ),
            ),
          ),
        );
      }),
    );
  }
}
