import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_exp_119/main.dart';
import 'package:firebase_exp_119/signup_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool isPassHidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(controller: emailController,),
          StatefulBuilder(builder: (context, ss) => TextField(controller: passController,
            obscuringCharacter: "*",
            obscureText: isPassHidden,
            decoration: InputDecoration(
                suffixIcon: InkWell(
                    onTap: (){
                      isPassHidden = !isPassHidden;
                      ss((){

                      });
                    },
                    child: Icon(isPassHidden ? Icons.visibility_off : Icons.visibility))
            ),),),
          ElevatedButton(onPressed: () async{

            String email = emailController.text;
            String pass = passController.text;


            try{
              UserCredential userCred = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass);
              /// maintain the session through shared prefs
              ///

              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(uid: userCred.user!.uid),));

            } on FirebaseAuthException catch(e){
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: Invalid Credentials!!')));
            } catch(e){
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${e.toString()}')));
            }


          }, child: Text('Login')),
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage(),));
            },
              child: Text("Don't have an account, create now")),
        ],
      ),
    );
  }
}
