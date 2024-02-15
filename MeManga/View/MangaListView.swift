import SwiftUI
import FirebaseFirestore
import Firebase
import URLImage

struct MangaListView: View {
    @EnvironmentObject var authManager: AuthManager  // Récupérer de l'Environment
    @State private var mangas: [Manga] = []
    @State private var newMangaTitle: String = ""
    @State private var searchText: String = ""
    @State private var isSearchActive: Bool = false // State to track if search is active
    @State private var filterButtonOffset: CGFloat = 0 // State to track filter button's offset

    var body: some View {
        NavigationView {
            VStack {
                Text("Library")
                    .font(.title3)
                    .fontWeight(.bold)
                
                // Search bar and filter button
                HStack {
                    SearchBarView(text: $searchText, onCommit: {
                        // Commit action
                    })
                    .onChange(of: searchText) { newValue in
                        withAnimation {
                            // Hide filter button when search bar is in use
                            filterButtonOffset = newValue.isEmpty ? 0 : UIScreen.main.bounds.width
                        }
                        // Optional: Your logic here for search
                    }
                    
                    // Filter button
                    Button(action: {
                        // Your filter action here
                    }) {
                        Image(systemName: "line.horizontal.3.decrease.circle")
                            .foregroundColor(Color("special_pink"))
                    }
                    .offset(x: filterButtonOffset) // Use the offset to show/hide the filter button
                }
                .padding(.horizontal)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.gray.opacity(0.4))
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(), GridItem()]) {
                        ForEach(mangas, id: \.id) { manga in
                            MangaCellView(manga: manga, progress: 0.5)
                        }
                    }
                    .padding()
                }
                .onAppear {
                    if let userId = authManager.currentUserId {
                        DBManager.shared.fetchMangasWithImages(userId: userId) { fetchedMangas in
                            self.mangas = fetchedMangas
                        }
                    } else {
                        print("No user ID found - make sure the user is logged in.")
                    }
                }
            }
        }
    }
}

struct MangaListView_Previews: PreviewProvider {
    static var previews: some View {
        let authManager = AuthManager()
        MangaListView().environmentObject(authManager)
    }
}
