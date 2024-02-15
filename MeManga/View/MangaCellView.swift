//
//  MangaCellView.swift
//  MeManga
//
//  Created by Hamza Hajjaj on 04/11/2023.
//

import SwiftUI
import URLImage

struct MangaCellView: View {
    let manga: Manga
    var progress: Float // Progression actuelle (entre 0.0 et 1.0)
    
    // Dimensions fixées pour toutes les images
    let imageWidth: CGFloat = 190 // Largeur fixe pour l'image
    let imageHeight: CGFloat = 300 // Hauteur fixe pour l'image

    var body: some View {
        VStack {
            URLImage(url: URL(string: manga.coverImageURL)!){ image in
                image
                    .resizable()
                        .aspectRatio(contentMode: .fill) // Cela remplira l'espace mais coupera l'excédent
                        .frame(width: imageWidth, height: imageHeight)
                        .clipped() // Ceci coupera l'excédent d'image à l'intérieur du cadre
                        .cornerRadius(8) // Appliquer les coins arrondis directement à l'image
                        .shadow(radius: 4)
            } // Remplacez par l'initialisation appropriée pour votre image
                

            // Barre de progression
            ProgressBar(progress: progress)
                .frame(width: imageWidth,height: 10) // Hauteur fixe pour la barre de progression
                .cornerRadius(5) // Bordures arrondies pour la barre de progression
//                .padding(.horizontal) // Padding horizontal si nécessaire

            // Nom de la collection
            HStack {
                Text(manga.title)
                    .lineLimit(1) // Limite à une seule ligne
                    .truncationMode(.tail)
                    .font(.caption)
                    .frame(width: imageWidth, alignment: .leading)
                
                
//                Spacer()
            } // Ajoute des points de suspension à la fin si le texte est trop long
            .padding(.horizontal)
        }
        .padding(.bottom)
    }
}

struct ProgressBar: View {
    var progress: Float

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color(UIColor.systemTeal))

                Rectangle().frame(width: min(CGFloat(self.progress)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color("special_pink"))
                    .animation(.linear, value: progress)
            }.cornerRadius(45.0)
        }
    }
}

//#Preview {
//    MangaCellView()
//}

// Exemple de données pour la prévisualisation
struct MangaCellView_Previews: PreviewProvider {
    static var previews: some View {
        MangaCellView(manga: Manga(id: 1, title: "One Piece", coverImageURL: "https://static.wikia.nocookie.net/naruto/images/e/e3/Vol26.png"), progress: 0.1)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
