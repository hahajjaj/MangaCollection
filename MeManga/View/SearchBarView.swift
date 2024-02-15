//
//  SearchBarView.swift
//  MeManga
//
//  Created by Hamza Hajjaj on 04/11/2023.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    @State private var isEditing = false
    var onCommit: () -> Void
    
    var body: some View {
        HStack {
            TextField("Search manga", text: $text, onCommit: onCommit)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray5))
                .cornerRadius(15)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                    }
                )
                .onTapGesture {
                    withAnimation {
                        self.isEditing = true
                    }
                }
            
            if isEditing {
                Button(action: {
                    withAnimation {
                        self.isEditing = false
                        self.text = ""
                        
                        // Dismiss the keyboard
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }) {
                    Text("Cancel")
                        .foregroundColor(Color("special_pink"))
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
        .frame(height: 30) // Réglez cette hauteur comme vous le souhaitez
        .cornerRadius(15)
    }
}

//#Preview {
//    @State var searchText = ""
//    SearchBarView(searchTex)
//}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        @State var searchText = ""
        SearchBarView(text: $searchText, onCommit: {})
            .padding()
    }
}
