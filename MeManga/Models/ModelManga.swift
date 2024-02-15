//
//  ModelManga.swift
//  MeManga
//
//  Created by Hamza Hajjaj on 01/11/2023.
//

import Foundation

struct Manga: Identifiable {
    var id: Int
    var title: String
    var coverImageURL: String
    var description: String?
    // Ajout d'un chemin local optionnel pour une image téléchargée
    var localImagePath: String?

    // Fonction pour récupérer l'image, soit depuis le cache local, soit depuis le web
    func getImage(completion: @escaping (Data?) -> Void) {
        // Si l'image est déjà téléchargée, utilisez la version locale
        if let localImagePath = self.localImagePath, let imageData = FileManager.default.contents(atPath: localImagePath) {
            completion(imageData)
        } else {
            // Sinon, téléchargez depuis l'URL et stockez localement
            guard let url = URL(string: coverImageURL) else {
                completion(nil) // Si l'URL est invalide, renvoyez nil
                return
            }
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    completion(nil)
                    return
                }
                // Éventuellement, enregistrez 'data' dans un fichier local et mettez à jour 'localImagePath'
                completion(data)
            }.resume()
        }
    }
}
