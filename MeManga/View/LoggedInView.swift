//
//  LoggedInView.swift
//  MeManga
//
//  Created by Hamza Hajjaj on 01/11/2023.
//

import SwiftUI

struct LoggedInView: View {
    let logoutAction: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Bienvenue!")
            Button(action: logoutAction) {
                Text("Déconnexion")
            }
        }
    }
}

