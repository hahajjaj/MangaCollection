//
//  WelcomeScreen.swift
//  MeManga
//
//  Created by Hamza Hajjaj on 02/11/2023.
//

import SwiftUI

struct WelcomeScreen: View {
    @EnvironmentObject var authManager: AuthManager  // Récupérer de l'Environment

    var body: some View {
        NavigationView {
            ZStack {
    //            Color(.white).edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    Image(uiImage: UIImage(imageLiteralResourceName: "onBoard"))
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width * 0.9)
                        .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
                    Spacer()
                    
                    NavigationLink(
                        destination: SignUpView().toolbar(.hidden),
                        label: {
                            Text("Get Started")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("special_pink"))
                                .cornerRadius(50)
                                .padding(.horizontal)
                        })
                    .toolbar(.hidden)
                    
                    NavigationLink(
                        destination: SignInView().toolbar(.hidden),
                        label: {
                            Text("Sign In")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(Color("special_pink"))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(50)
                                .shadow(color: Color.black.opacity(0.08), radius: 60, x: 0.0, y: 16)
                                .padding()
                        })
                    .toolbar(.hidden)
                    
                    Spacer()
                    
                    HStack {
                        Text("Powered by")
                        Text("LIMINAL")
                            .foregroundColor(Color("special_blue"))
                            .fontWeight(.bold)
                    }
                    .font(.footnote)
                    .padding(.top)
                }
                .padding()
            }
        }
    }
}

#Preview {
    WelcomeScreen()
}

struct PrimaryButton: View {
    var title: String
    var action: (() -> Void)?  // Faites l'action optionnelle

    var body: some View {
        Button(action: { action?() }) {  // Appelle l'action si elle est définie
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color("special_pink"))
                .cornerRadius(50)
        }
    }
}

extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}
