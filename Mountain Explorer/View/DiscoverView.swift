//
//  DiscoverView.swift
//  Mountain app
//
//  Created by Pavel Sharenda on 21.02.22.
//

import SwiftUI

struct DiscoverView: View {
    @StateObject private var response = Response()
    
    var body: some View {
        
        NavigationView {
            ZStack {
//                Image("beautiful mountains")
//                    .resizable()
//                    .scaledToFill()
//                    .frame(minWidth: 0, maxWidth: .infinity)
//                    .ignoresSafeArea(.all, edges: [.top, .horizontal])
                ScrollView(.vertical, showsIndicators: false) {
                    if !response.results.isEmpty {
                        ForEach(response.results) { result in
                            NavigationLink {
                                WebView(url: URL(string: result.linkToWikipedia) ?? URL(string: "https://www.wikipedia.org")!)
                                    .navigationTitle(result.name)
                            } label: {
                                MountainBadge(image: result.name, title: result.name, elevation: result.altitude)
                                    .padding()
                            }
                        }
                    } else {
                        ProgressView("Loading...")
                            .padding(.top, 100)
                    }
                }
                .navigationTitle("Beautiful Mountains")
            }
        }
        .task {
            await response.loadData()
        }
    }
}

struct MountainBadge: View {
    var image: String
    var title: String
    var elevation: Double
    
    var body: some View {
        GeometryReader { geo in
            HStack {
                Image(image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.frame(in: .local).width * 0.53)
                    .frame(height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 50))
                    .overlay(
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(Color.blue)
                    )
                
                HStack {
                    Spacer()
                    VStack(alignment: .center) {
                        Spacer()
                        Group {
                            Text(title)
                                .font(.system(.title2, design: .rounded)).bold()
                            Text("\(elevation.formatted()) m")
                                .font(.system(.caption, design: .rounded)).bold()
                        }
                        .foregroundColor(.blue)
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
        .frame(minWidth: 0, maxHeight: .infinity)
        .frame(height: 150)
        .background(
            Color.white
                .opacity(0.3)
                .ignoresSafeArea()
        )
        .clipShape(RoundedRectangle(cornerRadius: 50))
        .overlay(
            RoundedRectangle(cornerRadius: 50)
                .stroke(Color.blue)
        )
        .shadow(color: .white, radius: 1)
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
