//
//  HomeView.swift
//  MeManga
//
//  Created by Hamza Hajjaj on 04/11/2023.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authManager: AuthManager  // Récupérer de l'Environment
    @StateObject var viewManager = ViewManager()
    var body: some View {
        VStack{
            MenuBarView(viewManager: viewManager)
        }
//        .background(Color.black.opacity(0.05).edgesIgnoringSafeArea(.top))
    }
}

//#Preview {
//    HomeView()
//}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let authManager = AuthManager() // Créez un environnement factice
        return HomeView()
            .environmentObject(authManager) // Injectez l'environnement factice
    }
}
