//
//  LoginView.swift
//  MeManga
//
//  Created by Hamza Hajjaj on 01/11/2023.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isUserLoggedIn: Bool = Auth.auth().currentUser != nil
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""


    var body: some View {
        if isUserLoggedIn {
            MangaListView()
        } else {
            VStack(spacing: 20) {
                TextField("Email", text: $email)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                Button(action: signUp) {
                    Text("Sign Up")
                }
                Button(action: signIn) {
                    Text("Sign In")
                }
                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .padding()
        }
    }

    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Error signing up: \(error)")
                if let errCode = AuthErrorCode.Code(rawValue: error._code) {
                    switch errCode {
                    case .weakPassword:
                        self.errorMessage = "Le mot de passe est trop faible."
                    case .emailAlreadyInUse:
                        self.errorMessage = "Cette adresse e-mail est déjà utilisée."
                    default:
                        self.errorMessage = "Erreur lors de l'inscription."
                    }
                }
                self.showError = true
            } else {
                // Utilisateur inscrit avec succès.
                self.isUserLoggedIn = true
                self.showError = false
            }
        }
    }

    func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Error signing in: \(error)")
                if let errCode = AuthErrorCode.Code(rawValue: error._code) {
                    switch errCode {
                    case .wrongPassword:
                        self.errorMessage = "Mot de passe incorrect."
                    case .userNotFound:
                        self.errorMessage = "Aucun utilisateur trouvé pour cette adresse e-mail."
                    default:
                        self.errorMessage = "Erreur lors de la connexion."
                    }
                }
                self.showError = true
            } else {
                // Utilisateur connecté avec succès.
                self.isUserLoggedIn = true
                self.showError = false
            }
        }
    }


    func logout() {
        do {
            try Auth.auth().signOut()
            self.isUserLoggedIn = false
        } catch {
            print("Error signing out: \(error)")
        }
    }
}

#Preview {
    LoginView()
}
