//
//  PeakDetailView.swift
//  Mountain app
//
//  Created by Pavel Sharenda on 23.02.22.
//

import SwiftUI

struct ReviewView: View {
    @Binding var isDisplayed: Bool
    @State private var showRatings = false
    
    @ObservedObject var peak: Peak
    
    var body: some View {
        ZStack {
            Image(uiImage: UIImage(data: peak.image)!)
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity)
                .ignoresSafeArea()
            
            Color.white
                .opacity(0.6)
                .background(.ultraThinMaterial)
                .ignoresSafeArea()
          
            HStack {
                Spacer()
                
                VStack {
                    Button(action: {
                        withAnimation(.easeOut(duration: 0.3)) {
                            self.isDisplayed = false
                        }
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 30.0))
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    Spacer()
                }
            }
            
            VStack(alignment: .leading) {
                
                ForEach(Peak.Rating.allCases, id: \.self) { rating in
                    
                    HStack {
                        Image(rating.image)
                        Text(rating.rawValue.capitalized)
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .opacity(showRatings ? 1.0 : 0)
                    .offset(x: showRatings ? 0 : 1000)
                    .animation(.easeOut.delay(Double(Peak.Rating.allCases.firstIndex(of: rating)!) * 0.05), value: showRatings)
                    .onTapGesture {
                        self.peak.rating = rating
                        self.isDisplayed = false
                    }
                }
                
            }
        }
        .onAppear {
            showRatings.toggle()
        }
    }
}

struct ReviewView_Previews: PreviewProvider {
    
    static var previews: some View {
        ReviewView(isDisplayed: .constant(true), peak: (PersistenceController.testData?.first)!)
    }
}
