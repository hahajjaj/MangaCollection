//
//  ViewManager.swift
//  MeManga
//
//  Created by Hamza Hajjaj on 04/11/2023.
//

import Foundation
import SwiftUI

class ViewManager: ObservableObject {
    @Published var currentPage: Pages = .home
}

enum Pages {
    case home
    case search
    case read
    case user
}
