//
//  ContentView.swift
//  MeManga
//
//  Created by Hamza Hajjaj on 31/10/2023.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @StateObject var authManager = AuthManager()
    
    var body: some View {
        Group {
            if authManager.isUserLoggedIn {
                HomeView()
                    .environmentObject(authManager)
                    .transition(.opacity) // Ajoute une transition de type fondu
            } else {
                WelcomeScreen()
                    .environmentObject(authManager)
            }
        }
        .animation(.easeInOut, value: authManager.isUserLoggedIn) // Déclenche l'animation sur le changement d'état de isUserLoggedIn
    }
}


#Preview {
    ContentView()
}
