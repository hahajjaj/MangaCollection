//
//  AccountView.swift
//  MeManga
//
//  Created by Hamza Hajjaj on 04/11/2023.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        Button(action: authManager.logout) {
            Text("Déconnexion")
        }
    }
}

//#Preview {
//    AccountView()
//}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        let authManager = AuthManager()
        AccountView()
            .environmentObject(authManager)
    }
}
