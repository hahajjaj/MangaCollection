//
//  MenuBarView.swift
//  MeManga
//
//  Created by Hamza Hajjaj on 04/11/2023.
//

import SwiftUI

struct MenuBarView: View {
    @StateObject var viewManager: ViewManager
    @State var showPopUp = false
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        GeometryReader { geometry in
            
            VStack {
                Spacer()
                
                switch viewManager.currentPage{
                case .home:
                    MangaListView()
                case .search:
                    MangaSearchView()
                case .read:
                    SearchTestView()
                case .user:
                    AccountView()
                }
                
                Spacer()
                ZStack {
                    if showPopUp {
                        PopUpMenu(widthAndHeight: geometry.size.width/8)
                            .offset(y: -geometry.size.height/9)
                    }
                    HStack{
                        TabBarIcon(viewManager: viewManager, assignedPage: .home, width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "books.vertical", tabName: "Library")
                        
                        TabBarIcon(viewManager: viewManager, assignedPage: .search, width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "magnifyingglass", tabName: "Search")
                        
                        ZStack{
                            Circle()
                                .foregroundColor(.white)
                                .frame(width: geometry.size.width/7, height: geometry.size.width/7)
                                .shadow(radius: 4)
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width/7-6, height: geometry.size.height/7-6)
                                .foregroundColor(Color("special_pink"))
                                .rotationEffect(Angle(degrees: showPopUp ? 90 : 0))
                        }
                        .offset(y: -geometry.size.height/8/4)
                        .onTapGesture {
                            withAnimation {
                                showPopUp.toggle()
                            }
                        }
                        
    //                    TabBarIcon(width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "plus", tabName: "Add")
                        
                        TabBarIcon(viewManager: viewManager, assignedPage: .read, width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "book", tabName: "Read")
                        
                        TabBarIcon(viewManager: viewManager, assignedPage: .user, width: geometry.size.width/5, height: geometry.size.height/28, systemIconName: "person.crop.circle", tabName: "Account")
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height/10)
                .background(Color("White").shadow(radius: 2))
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
        
}

//#Preview {
//    MenuBarView()
//}

// Corrigez l'utilisation des commentaires et ajoutez un State pour la prévisualisation.
struct MenuBarView_Previews: PreviewProvider {
    static var previews: some View {
        let authManager = AuthManager()
        MenuBarView(viewManager: ViewManager())
            .environmentObject(authManager)
    }
}

struct TabBarIcon: View {
    @StateObject var viewManager: ViewManager
    let assignedPage: Pages

    let width, height: CGFloat
    let systemIconName, tabName: String
    
    var body: some View {
        VStack {
            Image(systemName: systemIconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width * 0.7, height: height * 0.7)
                .frame(width: width, height: height)
                .padding(.top, 10)
            Text(tabName)
//                .font(.footnote)
                .font(.system(size: 11))
            
            Spacer()
        }
        .padding(.horizontal, -4)
//        .padding(.top, -5)
        .onTapGesture {
            viewManager.currentPage = assignedPage
        }
        .foregroundColor(viewManager.currentPage ==  assignedPage ? Color(.black) : .gray)
    }
}

struct PopUpMenu: View{
    let widthAndHeight: CGFloat
    
    var body: some View {
        HStack(spacing: 30) {
            ZStack {
                Circle()
                    .stroke(Color("White"), lineWidth: 4) // Use stroke for border
                    .frame(width: widthAndHeight + 2, height: widthAndHeight + 2)
                    .shadow(radius: 4)
                Circle()
                    .foregroundColor(Color("special_pink"))
                    .frame(width: widthAndHeight, height: widthAndHeight)
                Image(systemName: "wifi")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(15)
                    .frame(width: widthAndHeight, height: widthAndHeight)
                    .foregroundColor(.white)
            }
            ZStack {
                Circle()
                    .stroke(Color("White"), lineWidth: 4) // Use stroke for border
                    .frame(width: widthAndHeight + 2, height: widthAndHeight + 2)
                    .shadow(radius: 4)
                Circle()
                    .foregroundColor(Color("special_pink"))
                    .frame(width: widthAndHeight, height: widthAndHeight)
                Image(systemName: "folder")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(15)
                    .frame(width: widthAndHeight, height: widthAndHeight)
                    .foregroundColor(.white)
            }
        }
        .transition(.scale)
    }
}
