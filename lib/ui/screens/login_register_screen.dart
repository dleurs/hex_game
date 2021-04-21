import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hex_game/bloc/authentication/authentication_bloc.dart';
import 'package:hex_game/bloc/authentication/authentication_event.dart';
import 'package:hex_game/bloc/authentication/authentication_state.dart';
import 'package:hex_game/bloc/form_login_register/form_login_register_bloc.dart';
import 'package:hex_game/core/authentication/authentication_api_manager.dart';
import 'package:hex_game/models/player.dart';
import 'package:hex_game/ui/components/const.dart';
import 'package:hex_game/ui/components/flutter_icon_com_icons.dart';
import 'package:hex_game/ui/screens/base_screen.dart';
import 'package:hex_game/utils/form_validator.dart';
import 'package:hex_game/utils/helpers.dart';

class LoginRegisterScreen extends StatefulWidget {
  static final BeamPage beamLocation = BeamPage(
    key: ValueKey(LoginRegisterScreen.uri.path),
    child: LoginRegisterScreen(),
  );
  static final Uri uri = Uri(path: "/player");

  @override
  _LoginRegisterScreenState createState() =>
      _LoginRegisterScreenState(FormLoginRegisterBloc(AuthenticationApiProvider()));
}

class _LoginRegisterScreenState extends BaseScreenState<LoginRegisterScreen> {
  FormLoginRegisterBloc _blocForm;

  _LoginRegisterScreenState(this._blocForm);

  final _formKey = GlobalKey<FormState>();

  TextEditingController _email = new TextEditingController();
  TextEditingController _pseudo = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  bool _showPasswordEyeIcon = false;
  bool _passwordObscur = true;

  @override
  void dispose() {
    _blocForm.close();
    super.dispose();
  }

  Widget welcomeMessage() {
    return Column(
      children: [
        Text(
          "Welcome",
          style: Theme.of(context).textTheme.headline4,
        ), //TODO int
      ],
    );
  }

  Widget sizedBoxMedium() {
    return SizedBox(
      height: AppDimensions.mediumHeight,
    );
  }

  TextFormField email({required bool readOnly}) {
    return TextFormField(
      readOnly: readOnly,
      style: TextStyle(color: readOnly ? Colors.grey[600] : Colors.black),
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: _email,
      validator: FormValidators.validateEmail,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.email,
          color: Colors.grey,
        ),
        suffixIcon: readOnly
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _email.text = "";
                    _password.text = "";
                  });
                  _blocForm.add(CheckEmailReset());
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

  Widget buttonValidateEmail({required BuildContext context, required bool loading}) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: 120, height: 50),
      child: ElevatedButton(
        child: !loading
            ? Text(
                'Enter', //TODO INTL
                style: TextStyle(fontSize: Theme.of(context).textTheme.headline6?.fontSize),
              )
            : CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
        onPressed: () async {
          if (_formKey.currentState?.validate() ?? false) {
            print("Checking if email " + _email.text + " is already used");
            _blocForm.add(CheckEmailEvent(email: _email.text));
            //bool isEmailAlreadyUsed = await FirestoreUser.isEmailAlreadyUsed(email: _email.text);
          }
        },
      ),
    );
  }

  Widget emailFoundOrNotMessage({required BuildContext context, required bool login0Register1}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 12.0),
      child: Text(
        login0Register1 ? "TODO Email not found" : "TODO (Email found)", //TODO INTL,
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.headline6?.fontSize,
          color: AppColors.green,
        ),
      ),
    );
  }

  TextFormField pseudo() {
    return TextFormField(
      style: TextStyle(color: Colors.black),
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
        });
      },
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.lock,
          color: Colors.grey,
        ), // icon is 48px widget.
        //errorText: "Wrong password.",

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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.mediumHeight)),
      ),
    );
  }

  Widget buttonValidateEmailPseudoPassword(
      {required BuildContext context, required bool loading, required bool login0Register1}) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: 120, height: 50),
      child: ElevatedButton(
        child: !loading
            ? Text(
                login0Register1 ? 'Register' : 'Login', //TODO INTL
                style: TextStyle(fontSize: Theme.of(context).textTheme.headline6?.fontSize),
              )
            : CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
        onPressed: () async {
          if (_formKey.currentState?.validate() ?? false) {
            setState(() {
              loading = true;
            });
            try {
              if (login0Register1) {
                BlocProvider.of<AuthenticationBloc>(context)
                    .add(RegisterEvent(login: _email.text, password: _password.text));
/*                     await FirestoreUser.createUserWithPseudoEmailAndPassword(
                        pseudo: _pseudo.text,
                        email: _email.text,
                        password: _password.text,
                        context: context); */
              } else {
                BlocProvider.of<AuthenticationBloc>(context)
                    .add(LoginEvent(login: _email.text, password: _password.text));
/*                 await FirebaseUser.signIn(
                    email: _email.text, password: _password.text); */
                print("Player logged");
              }
            } catch (e) {
              print("Error : " + e.toString());
            }
          }
        },
      ),
    );
  }

  Widget formLoginRegisterPlayer() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.xSmallHeight),
        child: Wrap(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: AppDimensions.smallScreenSize),
                child: BlocBuilder<FormLoginRegisterBloc, FormLoginRegisterState>(
                    bloc: _blocForm,
                    builder: (context, blocState) {
                      return SingleChildScrollView(
                        child: Column(
                          children: toList(() sync* {
                            yield sizedBoxMedium();
                            yield welcomeMessage();
                            yield sizedBoxMedium();
                            yield email(readOnly: !(blocState is FormLoginRegisterInitial));
                            yield sizedBoxMedium();
                            if (blocState is FormLoginRegisterInitial) {
                              yield buttonValidateEmail(context: context, loading: false);
                            } else if (blocState is CheckEmailProcessing) {
                              yield buttonValidateEmail(context: context, loading: true);
                            }
                            yield sizedBoxMedium();
                            if (blocState is EmailDoesNotExist || blocState is EmailAlreadyExist) {
                              // Register
                              yield emailFoundOrNotMessage(
                                  context: context, login0Register1: (blocState is EmailAlreadyExist));
                              yield sizedBoxMedium();
                            }
                            if (blocState is EmailDoesNotExist) {
                              // Register
                              yield pseudo();
                              yield sizedBoxMedium();
                            }
                            if (blocState is EmailDoesNotExist || blocState is EmailAlreadyExist) {
                              // Register
                              yield password(context);
                              yield sizedBoxMedium();
                              yield buttonValidateEmailPseudoPassword(
                                  context: context,
                                  loading: BlocProvider.of<AuthenticationBloc>(context) is AuthenticationProcessing,
                                  login0Register1: blocState is EmailAlreadyExist);
                            }
                          }),
                        ),
                      );
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget buildScreen(BuildContext context) {
    return formLoginRegisterPlayer();
  }
}
