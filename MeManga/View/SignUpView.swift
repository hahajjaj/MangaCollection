//
//  SignUpView.swift
//  MeManga
//
//  Created by Hamza Hajjaj on 03/11/2023.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authManager: AuthManager  // Récupérer de l'Environment
    @State private var isShowingLoading = false
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    @State private var showError = false
    @State private var errorMessage: String = ""
    var body: some View {
        ZStack {
            ZStack {
                Color(.white).edgesIgnoringSafeArea(.all)
                VStack {
                    
                    Spacer()
                    
                    VStack {
                        Text("Sign Up")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.bottom, 30)
                        
                        SocialLoginButton(image: Image(uiImage: UIImage(imageLiteralResourceName: "apple")), text: "Sign up with Apple") {
                            isShowingLoading = true // Commencez l'animation de chargement
                            authManager.signInWithApple {
                                isShowingLoading = false
                            }
                        }
                        .foregroundColor(.black)
                        .padding(.horizontal)
                        
                        SocialLoginButton(image: Image(uiImage: UIImage(imageLiteralResourceName: "google")), text: "Sign up with Google") {
                            isShowingLoading = true // Commencez l'animation de chargement
                            authManager.signInWithGoogle {
                                isShowingLoading = false // Arrêtez l'animation de chargement
                            }
                        }
                        .foregroundColor(Color("special_pink"))
                        .padding()
                        
                        
                        
                        HStack {
                            // Le séparateur à gauche du Text
                            Line()
                                .frame(width: 50 ,height: 1)
                            
                            // Le Text qui apparaîtra au milieu
                            Text("or")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                                .padding(.horizontal, 10) // Ajuster l'espacement horizontal si nécessaire

                            // Le séparateur à droite du Text
                            Line()
                                .frame(width: 50 ,height: 1)
                        }.frame(maxWidth: .infinity) // Assurez-vous que le HStack prend toute la largeur disponible

                        
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
                        
                        SecureField("Confirm Password", text: $confirmPassword)
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(50)
                            .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                            .padding(.horizontal)
                        
                        if showError {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding()
                                .transition(.opacity) // Transition en fondu pour le texte d'erreur
                                .animation(.easeIn, value: showError) // Animation en douceur
                        }
                        
                        PrimaryButton(title: "Sign up") {
                            if password == confirmPassword {
                                isShowingLoading = true
                                authManager.signUp(email: email, password: password) {
                                    // Vous pouvez ici traiter la fin du chargement, par exemple naviguer vers une nouvelle page ou afficher un message de succès
                                    isShowingLoading = false
                                }
                            } else {
                                errorMessage = "Les mots de passe ne correspondent pas."
                                withAnimation {
                                    showError = true
                                }
                            }
                        }
                        .padding()
                    }
                    
                    Spacer()
                    
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
        .onTapGesture {
            self.hideKeyboard()
        }
    }
    
    private func hideKeyboard() {
        // Fonction pour masquer le clavier si l'utilisateur appuie en dehors des champs de texte
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


#Preview {
    SignUpView()
}

struct Line: View {
    var color: Color = .gray
    var width: CGFloat = 1
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: width)
            .edgesIgnoringSafeArea(.horizontal)
    }
}
