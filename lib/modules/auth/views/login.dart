part of login_library;

class Login extends WidgetView<Login, LoginControllerState> {
  const Login(super.controllerState, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (BuildContext context, Object? state) {

          if (state is LoginSuccess) {
            controllerState.handleApiResponse(context, state);
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error ?? "Login failed"),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (BuildContext context, state) {
          print('🔄 LoginBloc State: $state');
          if (state is LoginLoading) {
            return Center(
              child: CircularProgressIndicator(color: Colors.teal),
            );
          }

          // Show login form for initial and failure states
          if (state is LoginInitial || state is AuthInitial || state is LoginFailure) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.fromLTRB(10, 100, 10, 10),
                    child: Column(
                      children: [
                        Form(
                          key: controllerState.loginFormKey,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Login", style: TextStyle(fontSize: 20)),
                                ],
                              ),
                              const SizedBox(height: 50),
                              TextFormField(
                                controller: controllerState.emailController,
                                decoration: const InputDecoration(
                                  labelText: "Email",
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.email),
                                ),
                                validator: (value) {
                                  final trimmedValue = value?.trim() ?? '';
                                  if (trimmedValue.isEmpty) {
                                    return 'Email is required';
                                  } else if (!MyValidator.isValidEmail(
                                      trimmedValue)) {
                                    return 'Invalid email or mobile number';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 30),
                              TextFormField(
                                controller: controllerState.passwordController,
                                obscureText: controllerState.isPasswordHidden,
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.lock),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      controllerState.changePasswordHidden();
                                    },
                                    child: Icon(
                                      controllerState.isPasswordHidden
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  final trimmedValue = value?.trim() ?? '';
                                  if (trimmedValue.isEmpty) {
                                    return 'Password is required';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 30),
                              SizedBox(
                                width: 150,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (controllerState
                                        .loginFormKey.currentState!
                                        .validate()) {
                                      BlocProvider.of<AuthBloc>(context)
                                          .add(LoginButtonClicked());
                                      controllerState.loginToApp();
                                    }
                                  },
                                  child: const Text("Login",
                                      style: TextStyle(fontSize: 18)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text("Don't Have an account?",
                            style: TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 150,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, AppRoutes.createOrg);
                            },
                            child: const Text("Sign Up",
                                style: TextStyle(fontSize: 18)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  Column(
                    children: [
                      Text("Powered By Shiwkesh Schematics Private Limited"),
                      Text("All Rights Reserved"),
                      Text('version: ${controllerState.appVersion ?? '1.0.0'}'),
                    ],
                  )
                ],
              ),
            );
          }

          // Fallback
          return Container();
        },
      ),
    );
  }
}
