import Foundation
import Firebase
import FirebaseFirestore

class DBManager {
    static let shared = DBManager() // Singleton instance
    private let db = Firestore.firestore()
    
    func addManga(mangaTitle: String, userId: String, completion: @escaping (Bool, Error?) -> Void) {
        db.collection("users").document(userId).collection("mangas").addDocument(data: ["title": mangaTitle]) { error in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
    
    func fetchMangasWithImages(userId: String, completion: @escaping ([Manga]) -> Void) {
        db.collection("users").document(userId).collection("mangas").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching mangas: \(error)")
                return
            }
            
            var titles: [String] = []
            for document in querySnapshot!.documents {
                let data = document.data()
                if let title = data["title"] as? String {
                    titles.append(title)
                }
            }
            
            let dispatchGroup = DispatchGroup()
            var mangaDetails: [Manga] = []
            
            for title in titles {
                dispatchGroup.enter()
                searchManga(query: title) { results in
                    if let firstResult = results.first {
                        mangaDetails.append(firstResult)
                    }
                    dispatchGroup.leave()
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                completion(mangaDetails)
            }
        }
    }
    
    // Add here other database related methods...
}
