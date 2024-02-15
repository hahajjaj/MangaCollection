//
//  MeMangaApp.swift
//  MeManga
//
//  Created by Hamza Hajjaj on 31/10/2023.
//

import SwiftUI
import Firebase

@main
struct MeMangaApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
        }
    }
}
