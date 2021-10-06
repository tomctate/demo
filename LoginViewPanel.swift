//
//  LoginViewPanel.swift
//
//  Created by Thomas Tate on 2/2/21.
//  Copyright © 2021 Thomas Tate. All rights reserved.
//

import SwiftUI
//import Firebase

struct LoginViewPanel: View {
    
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    
    var body: some View {
        
        VStack{

            // Check if user is logged in
            if status{

                Home()
            }
            else {
                
                NavigationView{
     
                    LoginView()
                        .navigationBarHidden(true)
                        .navigationBarTitle("Log In", displayMode:.inline)
   
                }.accentColor(Color("Color"))
            }

        }.onAppear {

                NotificationCenter.default.addObserver(forName:
                    NSNotification.Name("statusChange"), object: nil, queue: .main) {
                    (_) in

                        let status = UserDefaults.standard.value(forKey: "status") as? Bool
                            ?? false
                        self.status = status
            }
        }
    }
}

struct LoginViewPanel_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginViewPanel()
            WelcomeViewPanel()
        }
    }
}

//MARK: - Welcome View Panel
struct WelcomeViewPanel : View {
    
    @State private var index = 0
    
    var body: some View{
        
        NavigationView {
        
            VStack{
                
                Text("Welcome")
                    .font(.system(size: 28))
                    .foregroundColor(Color("Color"))
                    .padding(.bottom, 5)
                
                VStack {
                    
                    Text("Are you looking to create a new account")
                    
                }.foregroundColor(.gray)
      
                Divider()
                
                VStack{
                    
                    Button(action: {
                        
                        self.index = 0
                        
                    }) {
                        
                       WelcomeButtonDetail(imageName: "person", buttonText: "Create new account")
                    }
                    
                    Button(action: {
                        
                        self.index = 1
                        
                    }) {
                        WelcomeButtonDetail(imageName: "person.3", buttonText: "Join an existing account")
                    }
                }
                .padding(.vertical, 25)
                
                Divider().padding(.horizontal, 6)
                
                Spacer(minLength: 0)
                
            }.padding(.top, 40)
            .padding(.horizontal, 30)
            
            // Hide the navigation bar
            .navigationBarHidden(true)
            .navigationBarTitle("BACK", displayMode:.inline)

        // Change the NavigationView back button color to white
        // Note: it is added here on the NavigationView
        }.accentColor(Color("Color"))
    }
    
}

struct WelcomeButtonDetail : View {
    
    var imageName : String = ""
    var buttonText : String = ""
    
    var body: some View{
        
        HStack{
            
            Image(systemName: imageName)
                // Enlarge SF Symbols for button image
                .font(.system(size: 22))
                .frame(width: 20, height: 25)
                .foregroundColor(Color.white)
                .padding(.leading, 20)
                .padding(.trailing, 10)
            
            HStack{
                
                Text(buttonText)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
            }
            .padding(.horizontal, 10)
            
            Spacer(minLength: 0)
            
            Image(systemName: "chevron.right")
                .foregroundColor(Color.white)
                .padding(.horizontal, 20)
    
        }
        .padding(.vertical, 30)
        .frame(width: (UIScreen.main.bounds.width - 80))
        .background(Color("Color"))
        .cornerRadius(8)
        .shadow(radius: 10)
        .padding(.vertical, 10)
    }
}

struct LoginView : View {
    
    @State var user = ""
    @State var pass = ""
    @State var msg = ""
    @State var alert = false
    
    var body : some View{
        
        VStack{
                        
            Text("Log In")
                .foregroundColor(Color("Color"))
                .fontWeight(.heavy)
                .font(.largeTitle)
                .padding([.top,.bottom], 20)
            
            VStack(alignment: .leading){
                                              
                VStack(alignment: .leading) {
                
                    Text("Email Address").font(.headline).fontWeight(.light)
                        .foregroundColor(Color.init(.label).opacity(0.75))
                    
                    HStack{
                        
                        TextField("Enter Your Email Address", text: $user)
                            .autocapitalization(.none)
                        
                        if user != "" {
                            
                            Image(systemName: "checkmark").foregroundColor(Color.init(.label))
                        }
                    }
                    
                    Divider()
                    
                }.padding(.bottom, 15)
                
                VStack(alignment: .leading) {
                    
                    Text("Password").font(.headline).fontWeight(.light)
                        .foregroundColor(Color.init(.label).opacity(0.75))

                    SecureField("Enter Your Password", text: $pass)
                
                    Divider()
                }
                
                HStack{
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }) {
                        
                        Text("Forgot Password ?").foregroundColor(Color.gray.opacity(0.95))
                    }
                }.padding(.top, 5)
            
            }.padding(.horizontal, 6)
            
            Button(action: {
                
                signInWithEmail(email: self.user, password: self.pass) { (verified,
                    status) in
                    
                    if !verified{
                        
                        self.msg = status
                        self.alert.toggle()
                    }
                    else{
                    
                        UserDefaults.standard.set(true, forKey: "status")
                        NotificationCenter.default.post(name:
                            NSNotification.Name("statusChange"), object: nil)
                    }
                }
                
            }) {
                
                Text("Log In").foregroundColor(.white).frame(width:
                    UIScreen.main.bounds.width - 120).padding()
                
            }.background(Color("Color"))
            .clipShape(Capsule())
            .padding(.top, 10)
            
            bottomView()
            
            Spacer()
             
        }.padding(.top, 40).padding(.horizontal, 20)
        .alert(isPresented: $alert) {
                
            Alert(title: Text("Error"), message: Text(self.msg), dismissButton: .default(Text("Ok")))
        }
        
    }
}

struct bottomView : View {
    
    @State var show = false
    
    var body : some View{
        
        VStack{

            Text("(or)").foregroundColor(Color.gray.opacity(0.95)).padding(.top, 25)
            
            HStack(spacing: 8){
                
                Text("Don't Have An Account ?").foregroundColor(Color.gray.opacity(0.95))
                
                Button(action: {
                      
                    self.show.toggle()
                    
                }) {
                      
                    NavigationLink(destination: WelcomeViewPanel(), label: {
                            
                        Text("Sign Up")
                            .foregroundColor(Color("Color"))
                    })
                }
                
            }.padding(.top, 20)
                    
        }
    }
}


func signInWithEmail(email: String, password : String, completion: @escaping (Bool,String)->Void) {
    
//    Auth.auth().signIn(withEmail: email, password: password) { (res, err) in
//
//        if err != nil{
//
//            completion(false,(err?.localizedDescription)!)
//            return
//        }
//
//        completion(true,(res?.user.email)!)
//    }
}

struct Home : View {

    var body : some View{

        VStack{
            
            Text("Home Example")
        }
    }
}


