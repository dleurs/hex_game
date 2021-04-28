import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hex_game/bloc/authentication/authentication_bloc.dart';
import 'package:hex_game/bloc/authentication/authentication_event.dart';
import 'package:hex_game/bloc/authentication/authentication_state.dart';
import 'package:hex_game/bloc/form_login_register/form_login_register_bloc.dart';
import 'package:hex_game/ui/components/const.dart';
import 'package:hex_game/ui/components/flutter_icon_com_icons.dart';
import 'package:hex_game/ui/screens/base_screen.dart';
import 'package:hex_game/utils/form_validator.dart';
import 'package:hex_game/utils/helpers.dart';
import 'package:hex_game/utils/keys_name.dart';

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

  TextEditingController _email = new TextEditingController();
  final _emailFocusNode = FocusNode();
  String? _emailNameErrorText;
  bool _emailNameError = false;

  TextEditingController _pseudo = new TextEditingController();
  final _pseudoFocusNode = FocusNode();
  String? _pseudoNameErrorText;
  bool _pseudoNameError = false;

  TextEditingController _password = new TextEditingController();
  final _passwordFocusNode = FocusNode();
  String? _passwordNameErrorText;
  bool _passwordNameError = false;
  bool _showPasswordEyeIcon = false;
  bool _passwordObscur = true;

  @override
  void initState() {
    super.initState();
    _email.text = BlocProvider.of<FormLoginRegisterBloc>(context).email;
  }

  bool doIShowEmailValidationButton(FormLoginRegisterState state) {
    return (state is FormLoginRegisterInitial ||
        state is EmailInvalid ||
        state is EmailUserDisabled ||
        state is EmailCheckProcessing ||
        state is EmailTooManyRequest);
  }

  Widget welcomeMessage() {
    return Column(
      children: [
        Text(
          "Welcome", //TODO intl
          key: Key(KeysName.LOGIN_REGISTER_SCREEN_TITLE),
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

  Widget sizedBoxXSmall() {
    return SizedBox(
      height: AppDimensions.xSmallHeight,
    );
  }

  Widget email() {
    var readOnly = (!doIShowEmailValidationButton(BlocProvider.of<FormLoginRegisterBloc>(context).state));
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: AppDimensions.minAndMaxHeightTextFormFieldNoShiftDownOnError,
          minHeight: AppDimensions.minAndMaxHeightTextFormFieldNoShiftDownOnError),
      child: TextFormField(
        readOnly: readOnly,
        key: Key(KeysName.LOGIN_REGISTER_SCREEN_TEXTFORMFIELD_EMAIL),
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
          BlocProvider.of<FormLoginRegisterBloc>(context, listen: false).add(WritingEmailEvent(email: email));
          setState(() {
            _emailNameError = false;
            _emailNameErrorText = null;
          });
        },
        onFieldSubmitted: (value) {
          if (!_emailNameError) {
            FocusScope.of(context).requestFocus(_emailFocusNode);
          }
        },
      ),
    );
  }

  Widget buttonValidateEmail({required BuildContext context}) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: 120, height: 50),
      child: ElevatedButton(
        key: Key(KeysName.LOGIN_REGISTER_SCREEN_BUTTON_CHECK_EMAIL_ONLY),
        child: (BlocProvider.of<FormLoginRegisterBloc>(context).state is EmailCheckProcessing)
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : Text(
                'Enter', //TODO INTL
                style: TextStyle(fontSize: Theme.of(context).textTheme.headline6?.fontSize),
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

  Widget emailFoundOrNotMessage({required BuildContext context}) {
    var formState = BlocProvider.of<FormLoginRegisterBloc>(context).state;
    return Text(
      (formState is EmailDoesNotExist) ? "Email not found" : "Email found", //TODO INTL,
      style: TextStyle(
          fontSize: Theme.of(context).textTheme.headline6?.fontSize,
          color: AppColors.blue,
          fontStyle: FontStyle.italic),
    );
  }

  Widget pseudo() {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: AppDimensions.minAndMaxHeightTextFormFieldNoShiftDownOnError,
          minHeight: AppDimensions.minAndMaxHeightTextFormFieldNoShiftDownOnError),
      child: TextFormField(
        key: Key(KeysName.LOGIN_REGISTER_SCREEN_TEXTFORMFIELD_PSEUDO),
        style: TextStyle(color: Colors.black),
        keyboardType: TextInputType.text,
        focusNode: _pseudoFocusNode,
        controller: _pseudo,
        validator: (value) {
          setState(() {
            if (value != null && value.isEmpty) {
              _pseudoNameError = true;
              _pseudoNameErrorText = 'Please enter a valid pseudo.'; // TODO INTL
            }
            RegExp regex = new RegExp(FormValidators.PSEUDO_PATTERN);
            if (value != null && !regex.hasMatch(value)) {
              _pseudoNameError = true;
              _pseudoNameErrorText = 'Pseudo should be between 2 and 20'; // TODO INTL
            }
            if (value != null && value.contains("@")) {
              _pseudoNameError = true;
              _pseudoNameErrorText = 'Pseudo cannot have @ symbol.'; // TODO INTL
            }
          });
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            FlutterIconCom.user,
            color: Colors.grey,
          ),
          hintText: 'Pseudo', //TODO INTL
          labelText: 'Pseudo', // TODO INTL
          labelStyle: TextStyle(fontSize: AppDimensions.xSmallTextSize),
          errorText: _pseudoNameErrorText,
          contentPadding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
        onChanged: (String pseudo) {
          setState(() {
            _pseudoNameError = false;
            _pseudoNameErrorText = null;
          });
        },
        onFieldSubmitted: (value) {
          if (!_pseudoNameError) {
            FocusScope.of(context).requestFocus(_pseudoFocusNode);
          }
        },
      ),
    );
  }

  Widget password(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: AppDimensions.minAndMaxHeightTextFormFieldNoShiftDownOnError,
          minHeight: AppDimensions.minAndMaxHeightTextFormFieldNoShiftDownOnError),
      child: TextFormField(
        key: Key(KeysName.LOGIN_REGISTER_SCREEN_TEXTFORMFIELD_PASSWORD),
        focusNode: _passwordFocusNode,
        obscureText: _passwordObscur,
        controller: _password,
        validator: (value) {
          setState(() {
            if (value == null || value.isEmpty) {
              _passwordNameError = true;
              _passwordNameErrorText = 'Password must be at least 6 characters.';
            }
            RegExp regex = new RegExp(FormValidators.PASSWORD_PATTERN);
            if (value != null && !regex.hasMatch(value)) {
              _passwordNameError = true;
              _passwordNameErrorText = 'Password must be at least 6 characters.';
            }
          });
          return null;
        },
        onChanged: (String password) {
          setState(() {
            _showPasswordEyeIcon = true;
            _passwordNameError = false;
            _passwordNameErrorText = null;
          });
        },
        onFieldSubmitted: (value) {
          if (!_passwordNameError) {
            FocusScope.of(context).requestFocus(_passwordFocusNode);
          }
        },
        decoration: InputDecoration(
          labelText: 'Password', // TODO INTL
          labelStyle: TextStyle(fontSize: AppDimensions.xSmallTextSize),
          errorText: _passwordNameErrorText,
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
          contentPadding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppDimensions.mediumHeight)),
        ),
      ),
    );
  }

  Widget buttonValidateEmailPseudoPassword({required BuildContext context}) {
    var formState = BlocProvider.of<FormLoginRegisterBloc>(context).state;
    var authState = BlocProvider.of<AuthenticationBloc>(context).state;
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: 120, height: 50),
      child: ElevatedButton(
        key: Key(KeysName.LOGIN_REGISTER_SCREEN_BUTTON_EMAIL_PASSWORD),
        child: (authState is AuthenticationProcessing)
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : Text(
                (formState is EmailDoesNotExist) ? 'Register' : 'Login', //TODO INTL
                style: TextStyle(fontSize: Theme.of(context).textTheme.headline6?.fontSize),
              ),
        onPressed: () async {
          if (_formKey.currentState?.validate() ?? false) {
            if (!_emailNameError && !_passwordNameError && !_pseudoNameError) {
              try {
                if (formState is EmailDoesNotExist) {
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
          }
        },
      ),
    );
  }

  Widget listenersFormAndAuthBlocs({required Widget child}) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, authState) {
        if (authState is RegisterErrorEmailAlreadyUsed) {
          setState(() {
            _emailNameError = true;
            _emailNameErrorText = 'Email already used. You should connect [contact admin]'; // TODO INTL
          });
        } else if (authState is RegisterErrorInvalidEmail) {
          setState(() {
            _emailNameError = true;
            _emailNameErrorText = 'Please enter a valid email address.'; // TODO INTL
          });
        } else if (authState is RegisterError) {
          setState(() {
            _emailNameError = true;
            _emailNameErrorText = 'Unknown error : ' + (authState.error ?? "no string error"); // TODO INTL
          });
        } else if (authState is RegisterErrorPseudoAlreadyUsed) {
          setState(() {
            _pseudoNameError = true;
            _pseudoNameErrorText = 'Pseudo already used'; // TODO INTL
          });
        } else if (authState is RegisterErrorFirestore) {
          setState(() {
            _emailNameError = true;
            _emailNameErrorText = 'Database error : ' + (authState.error ?? "no error message"); // TODO INTL
          });
        }
      },
      child: BlocListener<FormLoginRegisterBloc, FormLoginRegisterState>(
        listener: (context, formState) {
          if (formState is EmailInvalid) {
            setState(() {
              _emailNameError = true;
              _emailNameErrorText = 'Please enter a valid email address.'; // TODO INTL
            });
          } else if (formState is EmailUserDisabled) {
            setState(() {
              _emailNameError = true;
              _emailNameErrorText = 'Account linked with this email has been disabled by administrator.'; // TODO INTL
            });
          } else if (formState is EmailTooManyRequest) {
            setState(() {
              _emailNameError = true;
              _emailNameErrorText = 'Too many requests. Please try later'; // TODO INTL
            });
          }
        },
        child: child,
      ),
    );
  }

  Widget formLoginRegisterPlayer() {
    return listenersFormAndAuthBlocs(
      child: Form(
        key: _formKey,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.xSmallHeight),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: AppDimensions.smallScreenSize),
              child: SingleChildScrollView(
                child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                    return BlocBuilder<FormLoginRegisterBloc, FormLoginRegisterState>(
                      builder: (context, formState) {
                        return Column(
                          children: toList(() sync* {
                            yield sizedBoxMedium();
                            yield welcomeMessage();
                            yield sizedBoxMedium();
                            yield email();
                            if (doIShowEmailValidationButton(formState)) {
                              yield sizedBoxXSmall();
                              yield buttonValidateEmail(context: context);
                            }
                            if (formState is EmailDoesNotExist || formState is EmailAlreadyExist) {
                              yield emailFoundOrNotMessage(context: context);
                              yield sizedBoxSmall();
                            }
                            if (formState is EmailDoesNotExist) {
                              yield pseudo();
                              yield sizedBoxXSmall();
                            }
                            if (formState is EmailDoesNotExist || formState is EmailAlreadyExist) {
                              yield password(context);
                              yield sizedBoxSmall();
                              yield buttonValidateEmailPseudoPassword(context: context);
                            }
                          }),
                        );
                      },
                    );
                  },
                ),
              ),
            )),
      ),
    );
  }

  @override
  Widget buildScreen(BuildContext context) {
    return formLoginRegisterPlayer();
  }
}
