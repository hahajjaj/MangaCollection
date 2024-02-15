//
//  SignInView.swift
//  MeManga
//
//  Created by Hamza Hajjaj on 02/11/2023.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var authManager: AuthManager  // Récupérer de l'Environment
    @State private var isShowingLoading = false
    @State private var email: String = ""
    @State private var password: String = ""
    var body: some View {
        ZStack {
            ZStack {
                Color(.white).edgesIgnoringSafeArea(.all)
                VStack {
                    
                    Spacer()
                    
                    VStack {
                        Text("Sign In")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.bottom, 30)
                        
//                        SocialLoginButton(image: Image(uiImage: UIImage(imageLiteralResourceName: "apple")), text: "Sign in with Apple")
//                            .padding(.horizontal)
                        
                        SocialLoginButton(image: Image(uiImage: UIImage(imageLiteralResourceName: "apple")), text: "Sign in with Apple") {
                            isShowingLoading = true // Commencez l'animation de chargement
                            authManager.signInWithApple {
                                isShowingLoading = false
                            }
                        }
                        .foregroundColor(.black)
                        .padding(.horizontal)
                        
                        SocialLoginButton(image: Image(uiImage: UIImage(imageLiteralResourceName: "google")), text: "Sign in with Google") {
                            isShowingLoading = true // Commencez l'animation de chargement
                            authManager.signInWithGoogle {
                                isShowingLoading = false // Arrêtez l'animation de chargement
                            }
                        }
                        .foregroundColor(Color("special_pink"))
                        .padding()
                        
                        
                        
                        Text("or use ur email and password")
                            .foregroundColor(Color.black.opacity(0.4))
                            .padding(.top)
                        
                        TextField("Email", text: $email)
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(50)
                            .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                            .padding(.horizontal)
                            .autocapitalization(.none)
                            .textContentType(.emailAddress) // Empêche iOS de suggérer un mot de passe.
                        
                        SecureField("Password", text: $password)
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(50)
                            .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                            .padding(.horizontal)
                        
                        
                        PrimaryButton(title: "Sign in"){
                            isShowingLoading = true
                            authManager.signIn(email: email, password: password) {
                                isShowingLoading = false
                            }
                        }
                            .padding()
                    }
                    
                    Spacer()
                    Divider()
                        .padding()
                    
                    
                    HStack {
                        Text("Forgot your password?")
                        Text("Click here.")
                            .foregroundColor(Color("special_blue"))
                    }
                    .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                }
                .padding()
            }
            if isShowingLoading {
                // On utilise Color.black.opacity(0.4) comme fond pour le chargement
                // pour créer un effet de fondu et désactiver les interactions en dessous.
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all) // Pour étendre le fondu à tous les bords de l'écran.
                    .overlay(
                        // On place le LoadingView au centre de l'écran.
                        LoadingView()
                            .frame(width: 100, height: 100) // Vous pouvez ajuster la taille selon vos besoins.
                    )
            }
        }
    }
}

#Preview {
    SignInView()
}

import SwiftUI

struct SocialLoginButton: View {
    @EnvironmentObject var authManager: AuthManager
    var image: Image
    var text: String
    var action: (() -> Void)? // Optional action
    
    var body: some View {
        Button(action: {
            // Execute the action when it's not nil
            action?()
        }) {
            HStack {
                image
                    .padding(.horizontal)
                
                Spacer()
                
                Text(text)
                    .font(.title2)
                
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(50)
            .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
        }
        .buttonStyle(PlainButtonStyle()) // Ensures that the button does not have any additional styling
    }
}

