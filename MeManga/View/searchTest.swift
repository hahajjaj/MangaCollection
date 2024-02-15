//
//  searchTest.swift
//  MeManga
//
//  Created by Hamza Hajjaj on 05/11/2023.
//

import SwiftUI
import Combine

struct SearchTestView: View {
    @ObservedObject var viewModel = SearchViewModel()

    var body: some View {
        VStack {
            TextField("Search...", text: $viewModel.searchTerm)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            List(viewModel.searchResults) { media in
                VStack(alignment: .leading) {
                    Text(media.title.romaji ?? "")
                    Text(media.title.english ?? "")
                    Text(media.title.native ?? "")
                }
            }
        }
    }
}



struct Response: Decodable {
    let data: Page
}

struct Page: Decodable {
    let media: [Media]
}

struct Media: Decodable, Identifiable {
    let id: Int
    let title: Title
}

struct Title: Decodable {
    let romaji: String?
    let english: String?
    let native: String?
}

// La classe ViewModel
class SearchViewModel: ObservableObject {
    // ... vos autres variables et initialisations ...
    @Published var searchTerm: String = ""
    @Published var searchResults: [Media] = []

    var cancellationToken: AnyCancellable?

    init() {
        cancellationToken = $searchTerm
            .removeDuplicates()
            .debounce(for: 0.5, scheduler: RunLoop.main) // attendre 0.5 secondes après le dernier événement de frappe
            .sink(receiveValue: { (str) in
                if !str.isEmpty {
                    self.fetchSearchResults(for: str)
                } else {
                    self.searchResults = []
                }
            })
    }
    
    func fetchSearchResults(for searchTerm: String) {
        let query = """
        {
            Page {
                media(search: "\(searchTerm)", type: ANIME) {
                    id
                    title {
                        romaji
                        english
                        native
                    }
                }
            }
        }
        """

        // Configurez vos en-têtes et votre corps de demande ici
        var request = URLRequest(url: URL(string: "https://graphql.anilist.co")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: String] = ["query": query]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        // Créez une tâche de session pour envoyer la demande
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data")
                return
            }
            
            // Ajoutez un point d'arrêt ici pour voir ce que vous obtenez dans la réponse
            print(String(data: data, encoding: .utf8) ?? "Invalid data encoding")
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(Response.self, from: data)
                DispatchQueue.main.async {
                    self.searchResults = decodedResponse.data.media
                }
            } catch DecodingError.keyNotFound(let key, let context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch DecodingError.valueNotFound(let type, let context) {
                print("Value '\(type)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch DecodingError.typeMismatch(let type, let context) {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch DecodingError.dataCorrupted(let context) {
                print(context)
            } catch {
                print("Decoding error: \(error.localizedDescription)")
            }
        }.resume()
    }
}

