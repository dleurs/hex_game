import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();

  bool _showPasswordEyeIcon = false;
  bool _passwordObscur = true;
  bool _showModifyEmailIcon = false;
  bool _emailVerified = false;
  bool _wrongPassword = false;

  TextFormField email() {
    return TextFormField(
      readOnly: _emailVerified,
      style: TextStyle(color: _emailVerified ? Colors.grey[700] : Colors.black),
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: _email,
      validator: FormValidators.validateEmail,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.email,
          color: Colors.grey,
        ),
        suffixIcon: null,
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
      onChanged: (String email) {},
    );
  }

  Widget validateEmail(BuildContext context) {
    return ElevatedButton(
      child: Text(
        'Enter',
        style: TextStyle(
            fontSize: Theme.of(context).textTheme.headline6?.fontSize),
      ),
      onPressed: () async {
        if (_formKey.currentState?.validate() ?? false) {
          print("OK");
        }
      },
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
            borderRadius: BorderRadius.circular(Const.mediumHeight)),
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
            padding: const EdgeInsets.symmetric(horizontal: Const.xSmallHeight),
            child: SingleChildScrollView(child: Column(
              children: toList(() sync* {
                yield SizedBox(height: Const.mediumHeight);
                yield email();
                yield SizedBox(height: Const.mediumHeight);
                yield validateEmail(context);
                yield SizedBox(height: Const.mediumHeight);
                yield password(context);
              }),
            )),
          ),
        );
      }),
    );
  }
}
