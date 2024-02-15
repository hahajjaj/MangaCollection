//
//  AniListAPI.swift
//  MeManga
//
//  Created by Hamza Hajjaj on 01/11/2023.
//

import Foundation

func searchManga(query: String, completion: @escaping ([Manga]) -> Void) {
    let url = URL(string: "https://graphql.anilist.co")!

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let json: [String: Any] = [
        "query": """
        query ($search: String) {
          Page(page: 1, perPage: 30) {
            media(search: $search, type: MANGA) {
              id
              title {
                romaji
              }
              coverImage {
                large
              }
              description
            }
          }
        }
        """,
        "variables": ["search": query]
    ]
    
    request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: [])
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            print("Error fetching data from AniList API:", error?.localizedDescription ?? "Unknown error")
            return
        }
        
        do {
            if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let jsonData = jsonObject["data"] as? [String: Any],
               let page = jsonData["Page"] as? [String: Any],
               let media = page["media"] as? [[String: Any]] {
                
                var mangas: [Manga] = []
                for mangaData in media {
                    if let id = mangaData["id"] as? Int,
                       let title = mangaData["title"] as? [String: String],
                       let romajiTitle = title["romaji"],
                       let coverImage = mangaData["coverImage"] as? [String: String],
                       let coverImageURL = coverImage["large"] {
                        let description = mangaData["description"] as? String
                        let manga = Manga(id: id, title: romajiTitle, coverImageURL: coverImageURL, description: description)
                        mangas.append(manga)
                    }
                }
                
                DispatchQueue.main.async {
                    completion(mangas)
                }
            }
        } catch {
            print("Error parsing data from AniList API:", error)
        }
    }.resume()
}


