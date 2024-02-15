//
//  MangaDetailView.swift
//  MeManga
//
//  Created by Hamza Hajjaj on 04/11/2023.
//

import SwiftUI
import Firebase

struct MangaDetailView: View {
    @State var manga: Manga
    // Supposons que vous avez une méthode 'addToCollection()' que vous implémenterez pour ajouter le manga à une collection
    var addToCollection: () -> Void// Une closure vide comme substitut jusqu'à ce que vous ayez la méthode

    var body: some View {
        ScrollView {
            VStack {
                // AsyncImage est un visualiseur d'images qui prend en charge le chargement asynchrone
                AsyncImage(url: URL(string: manga.coverImageURL)) { phase in
                    if let image = phase.image {
                        image
                            .resizable() // Rend l'image redimensionnable
                            .scaledToFit() // Assurez-vous que toute l'image s'intègre en gardant ses proportions
                            .frame(maxWidth: .infinity) // Utilisez tout l'espace disponible en largeur
                            .cornerRadius(10) // Coins arrondis pour l'esthétique
                            .padding() // Un peu de padding autour de l'image
                    } else if phase.error != nil {
                        Text("Could not load image") // Gestion des erreurs
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ProgressView() // Affichez une vue de progression pendant le chargement de l'image
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                
                Text(manga.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top) // Ajoutez un espace entre l'image et le titre

                if let description = manga.description {
                    Text(description)
                        .padding() // Ajoutez de l'espace autour de la description
                } else {
                    Text("No description available")
                        .padding() // Ajoutez de l'espace autour de la description
                        .italic()
                }

                // Bouton 'Add' avec action
                Button(action: {
                    
                    guard let userId = Auth.auth().currentUser?.uid else {
                        print("No user found")
                        return
                    }
                    
                    let db = Firestore.firestore()
                    db.collection("users").document(userId).collection("mangas").addDocument(data: ["title": manga.title])
                    
                }) {
                    Text("Add")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("special_pink"))
                        .foregroundColor(Color.white)
                        .cornerRadius(10)
                        .padding() // Ajoutez un peu d'espace autour du bouton
                }
            }
        }
        .navigationTitle(manga.title) // Utilisez le titre du manga comme titre de la barre de navigation
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MangaDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MangaDetailView(manga: Manga(id: 1, title: "Naruto", coverImageURL: "https://static.wikia.nocookie.net/naruto/images/e/e3/Vol26.png", description: "Exciting Ninja Adventures"), addToCollection: {})
    }
}

