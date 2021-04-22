import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hex_game/bloc/authentication/authentication_bloc.dart';
import 'package:hex_game/bloc/authentication/authentication_event.dart';
import 'package:hex_game/bloc/authentication/authentication_state.dart';
import 'package:hex_game/bloc/form_login_register/form_login_register_bloc.dart';
import 'package:hex_game/core/authentication/authentication_api_manager.dart';
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

  TextEditingController _pseudo = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  bool _showPasswordEyeIcon = false;
  bool _passwordObscur = true;

  TextEditingController _email = new TextEditingController();
  final _emailFocusNode = FocusNode();
  String? _emailNameErrorText;
  bool _emailNameError = false;

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
        ), //TODO intl
      ],
    );
  }

  Widget sizedBoxMedium() {
    return SizedBox(
      height: AppDimensions.mediumHeight,
    );
  }

  Widget sizedBoxSmall() {
    return SizedBox(
      height: AppDimensions.smallHeight,
    );
  }

  TextFormField email({required bool readOnly}) {
    return TextFormField(
      readOnly: readOnly,
      style: TextStyle(color: readOnly ? Colors.grey[600] : Colors.black),
      keyboardType: TextInputType.emailAddress,
      focusNode: _emailFocusNode,
      controller: _email,
      validator: (String? value) {
        setState(() {
          if (value != null && value.isEmpty) {
            _emailNameError = true;
            _emailNameErrorText = 'Email required.'; // TODO INTL
          }
          RegExp regex = new RegExp(FormValidators.EMAIL_PATTERN);
          if (value != null && !regex.hasMatch(value)) {
            _emailNameError = true;
            _emailNameErrorText = 'Please enter a valid email address.'; // TODO INTL
          }
        });
        return null;
      },
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.email,
          color: Colors.grey,
        ),
        labelText: 'Email', // TODO INTL
        labelStyle: TextStyle(fontSize: AppDimensions.xSmallTextSize),
        errorText: _emailNameErrorText,
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
      onChanged: (String email) {
        setState(() {
          _emailNameError = false;
          _emailNameErrorText = null;
        });
      },
      onFieldSubmitted: (value) {
        _formKey.currentState!.validate(); // Trigger validation
        if (!_emailNameError) {
          FocusScope.of(context).requestFocus(_emailFocusNode);
        }
      },
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
            if (!_emailNameError) {
              print("Checking if email " + _email.text + " is already used");
              _blocForm.add(CheckEmailEvent(email: _email.text));
            }
            //bool isEmailAlreadyUsed = await FirestoreUser.isEmailAlreadyUsed(email: _email.text);
          }
        },
      ),
    );
  }

  Widget emailFoundOrNotMessage({required BuildContext context, required bool login0Register1}) {
    return Text(
      login0Register1 ? "Email not found" : "Email found", //TODO INTL,
      style: TextStyle(
          fontSize: Theme.of(context).textTheme.headline6?.fontSize,
          color: AppColors.blue,
          fontStyle: FontStyle.italic),
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
                    .add(RegisterEvent(email: _email.text, password: _password.text, pseudo: _pseudo.text));
              } else {
                BlocProvider.of<AuthenticationBloc>(context)
                    .add(LoginEvent(email: _email.text, password: _password.text));
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
                            yield sizedBoxSmall();
                            if (blocState is FormLoginRegisterInitial) {
                              yield buttonValidateEmail(context: context, loading: false);
                            } else if (blocState is CheckEmailProcessing) {
                              yield buttonValidateEmail(context: context, loading: true);
                            }
                            if (blocState is EmailDoesNotExist || blocState is EmailAlreadyExist) {
                              // Register
                              yield emailFoundOrNotMessage(
                                  context: context, login0Register1: (blocState is EmailDoesNotExist));
                              yield sizedBoxSmall();
                            }
/*                             if (blocState is EmailInvalid) {
                              setState(() {
                                _emailNameError = true;
                                _emailNameErrorText = 'Please enter a valid email address.'; // TODO INTL
                              });
                            } else if (blocState is EmailUserDisabled) {
                              setState(() {
                                _emailNameError = true;
                                _emailNameErrorText = 'User link with this email disabled.'; // TODO INTL
                              });
                            } */
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
                                  login0Register1: blocState is EmailDoesNotExist);
                            }
                          }),
                        ),
                      );
                    }),
              ),
            ),
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
