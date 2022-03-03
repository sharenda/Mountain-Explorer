//
//  Main.swift
//  Mountain app
//
//  Created by Pavel Sharenda on 21.02.22.
//

import SwiftUI

struct TutorialView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("hasViewedWalkthrough") var hasViewedWalkthrough: Bool = false
    
    @State private var currentPage = 0
    
    let pageHeadings = [ "CREATE YOUR OWN MOUNTAIN GUIDE", "EXPLORE MOUNTAINS" ]
    let pageSubHeadings = [ "Add your favorite mountains and create your own mountain guide",
                            "Explore the most beautiful and highest mountains of the planet"
    ]
    let pageImages = [ "Walkthrough1", "Walkthrough2" ]
    
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .systemIndigo
        UIPageControl.appearance().pageIndicatorTintColor = .lightGray
    }
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(pageHeadings.indices) { index in
                    TutorialPage(image: pageImages[index], heading: pageHeadings[index], subHeading: pageSubHeadings[index])
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .automatic))
            .animation(.default, value: currentPage)
            
            VStack(spacing: 20) {
                Button(action: {
                    if currentPage < pageHeadings.count - 1 {
                        currentPage += 1
                    } else {
                        hasViewedWalkthrough = true
                        dismiss()
                    }
                }) {
                    Text(currentPage == pageHeadings.count - 1 ? String(localized: "GET STARTED") : String(localized: "NEXT"))
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .padding(.horizontal, 50)
                        .background(Color(.systemIndigo))
                        .cornerRadius(25)
                }
                
                if currentPage < pageHeadings.count - 1 {
                    
                    Button(action: {
                        hasViewedWalkthrough = true
                        dismiss()
                    }) {
                        
                        Text(String(localized: "Skip"))
                            .font(.headline)
                            .foregroundColor(Color(.darkGray))
                        
                    }
                }
            }
            .padding(.bottom)
            
        }
        
    }
}

struct TutorialPage: View {
    
    let image: String
    let heading: String
    let subHeading: String
    
    var body: some View {
        VStack(spacing: 70) {
            Image(image)
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity)
            
            VStack(spacing: 10) {
                Text(heading)
                    .font(.headline)
                
                Text(subHeading)
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .padding(.top)
    }
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
        
        TutorialPage(image: "Walkthrough1", heading: "CREATE YOUR OWN MOUNTAIN GUIDE", subHeading: "Add your favorite mountains and create your own mountain guide")
            .previewLayout(.sizeThatFits)
    }
}
