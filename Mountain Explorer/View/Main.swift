//
//  Main.swift
//  Mountain app
//
//  Created by Pavel Sharenda on 21.02.22.
//

import SwiftUI

struct Main: View {
    @State private var favoritesViewAlreadyAppeared = false
    var body: some View {
        TabView {
            FavoritesView(alreadyAppeared: favoritesViewAlreadyAppeared)
                .tabItem {
                    Label("Favorites", systemImage: "tag.fill")
                }
                .tag(0)
                .onDisappear {
                    favoritesViewAlreadyAppeared = true
                }
            
            DiscoverView()
                .tabItem {
                    Label("Discover", systemImage: "wand.and.rays")
                }
                .tag(1)
        }
        .ignoresSafeArea()
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}
