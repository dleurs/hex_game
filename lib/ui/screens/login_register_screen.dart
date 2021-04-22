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
  _LoginRegisterScreenState createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends BaseScreenState<LoginRegisterScreen> {
  _LoginRegisterScreenState();

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
    super.dispose();
  }

  bool doIShowEmailValidationButton(FormLoginRegisterState state) {
    return (state is FormLoginRegisterInitial ||
        state is EmailInvalid ||
        state is EmailUserDisabled ||
        state is EmailCheckProcessing);
  }

  Widget welcomeMessage() {
    return Column(
      children: [
        Text(
          "Welcome", //TODO intl
          style: Theme.of(context).textTheme.headline4,
        ),
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

  TextFormField email() {
    var readOnly = (!doIShowEmailValidationButton(BlocProvider.of<FormLoginRegisterBloc>(context).state));
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
                  BlocProvider.of<FormLoginRegisterBloc>(context).add(CheckEmailResetEvent());
                },
                icon: Icon(Icons.cached_outlined))
            : null,
        hintText: 'Email', //TODO INTL
        contentPadding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onChanged: (String email) {
        //BlocProvider.of<FormLoginRegisterBloc>(context, listen: false).add(WritingEmailEvent(email: email));
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

  Widget buttonValidateEmail({required BuildContext context}) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: 120, height: 50),
      child: ElevatedButton(
        child: !(BlocProvider.of<FormLoginRegisterBloc>(context).state is EmailCheckProcessing)
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
              BlocProvider.of<FormLoginRegisterBloc>(context).add(CheckEmailEvent(email: _email.text));
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
        setState(() {
          _showPasswordEyeIcon = true;
        });
      },
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.lock,
          color: Colors.grey,
        ),
        suffixIcon: _showPasswordEyeIcon
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _passwordObscur = !_passwordObscur;
                  });
                },
                icon: Icon(Icons.remove_red_eye_outlined))
            : SizedBox(),
        hintText: 'Password', //TODO INTL
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
    return BlocListener<FormLoginRegisterBloc, FormLoginRegisterState>(
      listener: (context, state) {
        if (state is EmailInvalid) {
          setState(() {
            _emailNameError = true;
            _emailNameErrorText = 'Please enter a valid email address.'; // TODO INTL
          });
        } else if (state is EmailUserDisabled) {
          setState(() {
            _emailNameError = true;
            _emailNameErrorText = 'User link with this email disabled by administrator.'; // TODO INTL
          });
        }
      },
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.xSmallHeight),
          child: Wrap(
            children: [
              Center(
                child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: AppDimensions.smallScreenSize),
                    child: SingleChildScrollView(
                      child: Column(
                        children: toList(() sync* {
                          var formState = BlocProvider.of<FormLoginRegisterBloc>(context).state;
                          yield sizedBoxMedium();
                          yield welcomeMessage();
                          yield sizedBoxMedium();
                          yield email();
                          yield sizedBoxSmall();
                          if (doIShowEmailValidationButton(formState)) {
                            yield buttonValidateEmail(context: context);
                          }
                          if (formState is EmailDoesNotExist || formState is EmailAlreadyExist) {
                            // Register
                            yield emailFoundOrNotMessage(
                                context: context, login0Register1: (formState is EmailDoesNotExist));
                            yield sizedBoxSmall();
                          }

                          if (formState is EmailDoesNotExist) {
                            // Register
                            yield pseudo();
                            yield sizedBoxMedium();
                          }
                          if (formState is EmailDoesNotExist || formState is EmailAlreadyExist) {
                            // Register
                            yield password(context);
                            yield sizedBoxMedium();
                            yield buttonValidateEmailPseudoPassword(
                                context: context,
                                loading: formState is AuthenticationProcessing,
                                login0Register1: formState is EmailDoesNotExist);
                          }
                        }),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget buildScreen(BuildContext context) {
    return formLoginRegisterPlayer();
  }
}
