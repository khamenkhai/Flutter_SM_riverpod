import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sm_project/sm/controllers/authController.dart';
import 'package:sm_project/sm/utils/utils.dart';
import 'package:sm_project/sm/view/authScreens/registerScreen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {

  var _formKey = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  bool isObscure = true;

  navigateToSignUp(BuildContext context){
    navigatorPush(context, RegisterScreen());
  }

  login(WidgetRef ref){
      ref.read(authControllerProvider.notifier).login(email: _email.text, password: _password.text, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(  
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ///logo image
                SizedBox(height: 60),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Container(
                    height:130,
                    width: 130,
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(offset: Offset(0, 10),blurRadius: 25,color: Theme.of(context).cardColor)
                      ]
                    ),
                    child: Image.asset("assets/images/camera-lens.png"),
                  ),
                ),
                  
                SizedBox(height: 35),
                Text("SocialPulse",style:TextStyle(fontSize: 30,fontWeight: FontWeight.bold)),
                SizedBox(height: 60),
                  
                ///email form field
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 35),
                  child: TextFormField(
                    controller: _email,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if(value==""){
                        return "Email is required!";
                      }return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Email",
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: EdgeInsets.only(left: 35)
                    ),
                  ),
                ),
          
                ///password form field
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 35),
                  child: TextFormField(
                    controller: _password,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value){
                      if(value==""){
                        return "Password is required!";
                      }return null;
                    },
                     obscureText: isObscure,
                      decoration: InputDecoration(
                      hintText: "Password",
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      suffixIcon: GestureDetector(child: Icon(isObscure ? Icons.visibility_off : Icons.visibility),onTap: (){
                        setState(() {
                          isObscure = !isObscure;
                        });
                      }),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: EdgeInsets.only(left: 35)
                    ),
                  ),
                ),
          
          
                ///login 
                SizedBox(height: 25),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 35),
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton(onPressed: (){
                    ///login
                    if(_formKey.currentState!.validate()){
                      login(ref);
                  
                    }else{
                       showMessageSnackBar(message: "You have to fill the form", context: context);
                    }
                  }, child: 
                  ref.watch(authControllerProvider)==true ? loadingWidget(color: Colors.white) : 
                  Text("Login"),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                    )
                  ),),
                ),
          
          
                ///forgot passsword button
                SizedBox(height: 25),
                TextButton(onPressed: (){}, child: Text("Forgot password?",style:TextStyle(color: Colors.grey.shade700))),
                SizedBox(height: 25),
      
                Container(
                  width: double.infinity,
                  height: 45,
                  padding: EdgeInsets.symmetric(horizontal: 35),
                  child: ElevatedButton(onPressed: (){}, child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset("assets/images/google.png"),
                      ),
                      Text("Continue with Google",style:TextStyle(color: Colors.grey.shade900)),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                    )
                  ),),
                ),
      
                SizedBox(height: 20),
      
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(onPressed: (){
                      ///navigate to signup
                      navigateToSignUp(context);
                    }, child: Text("Sign up",style: TextStyle(color: Colors.grey.shade700)))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}