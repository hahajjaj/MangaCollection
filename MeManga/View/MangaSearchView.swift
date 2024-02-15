//
//  MangaSearchView.swift
//  MeManga
//
//  Created by Hamza Hajjaj on 01/11/2023.
//

import SwiftUI
import URLImage
import Combine

struct MangaSearchView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var query: String = ""
    @State private var mangas: [Manga] = []
    @State private var timer: AnyCancellable?

    var body: some View {
        NavigationView {
            VStack {
                SearchBarView(text: $query, onCommit: {
                    searchManga(query: query) { results in
                        self.mangas = results
                    }
                })
                .padding(.horizontal)
                .onChange(of: query) { _ in
                    timer?.cancel() // Cancel the previous timer and start a new one
                    timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
                        .sink { _ in
                            searchManga(query: self.query) { results in
                                self.mangas = results
                            }
                        }
                }
                List(mangas, id: \.id) { manga in
                    NavigationLink(destination: MangaDetailView(manga: manga, addToCollection: authManager.logout)) {
                        Text(manga.title)
                    }
                }
                .listStyle(PlainListStyle()) // Apply a plain list style
            }
            .navigationBarHidden(true)
        }
        .onDisappear {
            self.timer?.cancel()
        }
    }
}


struct MangaSearchView_Previews: PreviewProvider {
    static var previews: some View {
        MangaSearchView().environmentObject(AuthManager()) // Ensure AuthManager is initialized for preview
    }
}
