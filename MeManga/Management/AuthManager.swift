//
//  AuthManager.swift
//  MeManga
//
//  Created by Hamza Hajjaj on 03/11/2023.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import Firebase
import AuthenticationServices

class AuthManager: NSObject, ObservableObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    @Published var isUserLoggedIn: Bool = Auth.auth().currentUser != nil
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    private var completionBlock: (() -> Void)?
    
    var currentUserId: String? {
        return Auth.auth().currentUser?.uid
    }


    func signUp(email: String, password: String, completion: @escaping () -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                // Handle error
                self?.handleSignUpError(error)
            } else {
                // Utilisateur inscrit avec succès.
                DispatchQueue.main.async {
                    self?.isUserLoggedIn = true
                    self?.showError = false
                }
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    func signIn(email: String, password: String, completion: @escaping () -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                // Handle error
                self?.handleSignInError(error)
            } else {
                // Utilisateur connecté avec succès.
                DispatchQueue.main.async {
                    self?.isUserLoggedIn = true
                    self?.showError = false
                }
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.isUserLoggedIn = false
            }
        } catch {
            // Handle error
        }
    }

    private func handleSignUpError(_ error: Error) {
        // Set error message
        DispatchQueue.main.async {
            self.showError = true
            self.errorMessage = error.localizedDescription // Set the error message to be displayed in the UI if needed
            print("Sign in error: \(error.localizedDescription)")
        }
    }

    private func handleSignInError(_ error: Error) {
        // Set error message
        DispatchQueue.main.async {
            self.showError = true
            self.errorMessage = error.localizedDescription // Set the error message to be displayed in the UI if needed
            print("Sign in error: \(error.localizedDescription)")
        }
    }
    
    func signInWithGoogle(completion: @escaping () -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) { [weak self] user, error in
            if let error = error {
                // Gérer l'erreur ici
                DispatchQueue.main.async {
                    self?.handleSignInError(error)
                    completion()
                }
                return
            }

            guard let authentication = user?.user, let idToken = authentication.idToken else {
                DispatchQueue.main.async {
                    completion()
                }
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                           accessToken: authentication.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                if let error = error {
                    // Gérer l'erreur ici
                    DispatchQueue.main.async {
                        self?.handleSignInError(error)
                    }
                } else {
                    // L'utilisateur est connecté avec succès
                    DispatchQueue.main.async {
                        self?.isUserLoggedIn = true
                        self?.showError = false
                    }
                }
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }

    private func getRootViewController() -> UIViewController {
        // Trouver le ViewController actuellement présenté
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return UIViewController()
        }
        return rootViewController
    }
    
    func signInWithApple(completion: @escaping () -> Void) {
        completionBlock = completion
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authController = ASAuthorizationController(authorizationRequests: [request])
        authController.delegate = self
        authController.presentationContextProvider = self
        authController.performRequests()
    }
    
    // MARK: - ASAuthorizationControllerDelegate

        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
               let appleIDToken = appleIDCredential.identityToken,
               let idTokenString = String(data: appleIDToken, encoding: .utf8) {
                
                let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                          idToken: idTokenString,
                                                          rawNonce: nil)  // Utilisez un nonce si vous l'implémentez pour plus de sécurité.

                Auth.auth().signIn(with: credential) { [weak self] (authResult, error) in
                    DispatchQueue.main.async {
                        if let error = error {
                            self?.handleSignInError(error)
                        } else {
                            self?.isUserLoggedIn = true
                            self?.showError = false
                        }
                        // Exécution du bloc de complétion et réinitialisation
                        self?.completionBlock?()
                        self?.completionBlock = nil
                    }
                }
            }
        }

        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            // Gérer l'erreur ici
            DispatchQueue.main.async { [weak self] in
                self?.handleSignInError(error)
                // Exécution du bloc de complétion et réinitialisation
                self?.completionBlock?()
                self?.completionBlock = nil
                print("Authorization error: \(error.localizedDescription)") // Print error to console
            }
        }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            return getRootViewController().view.window!
        }
}
