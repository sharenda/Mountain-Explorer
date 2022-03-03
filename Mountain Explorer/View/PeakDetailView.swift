//
//  PeakDetailView.swift
//  Mountain app
//
//  Created by Pavel Sharenda on 23.02.22.
//

import SwiftUI

struct PeakDetailView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @ObservedObject var peak: Peak
    @State private var showReview = false
    @AppStorage("hasViewedWalkthrough") var hasViewedWalkthrough: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Image(uiImage: UIImage(data: peak.image)!)
                    .resizable()
                    .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 455)
                    .overlay(
                        HStack(alignment: .bottom) {
                            VStack(alignment: .leading) {
                                Text(peak.title)
                                    .font(.system(.largeTitle, design: .rounded).bold())
                                    .foregroundColor(.blue)
                                    .padding(.horizontal)
                                    .background(Color.white.opacity(0.5))
                                    .clipShape(RoundedRectangle(cornerRadius: 25))
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .bottomLeading)
                            .padding()
                            
                            if let rating = peak.rating, !showReview {
                                Image(rating.image)
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .padding([.bottom, .trailing])
                                    .transition(.scale)
                            }
                        }
                            .animation(.spring(response: 0.2, dampingFraction: 0.3, blendDuration: 0.3), value: peak.rating)
                    )
                
                Group {
                    Text("Elevation: ")
                        .font(.system(.title3, design: .rounded).bold())
                    + Text("\(peak.elevation.formatted()) m")
                        .font(.system(.title3, design: .rounded))
                    
                    Text("Country: ")
                        .font(.system(.title3, design: .rounded).bold())
                    + Text("\(peak.location)")
                        .font(.system(.title3, design: .rounded))
                    
                    Text("Description")
                        .font(.system(.title3, design: .rounded).bold())
                    + Text("\n\(peak.descript)")
                        .font(.system(.title3, design: .rounded))
                    
                    if let link = peak.link {
                        HStack {
                            Text("Website:")
                                .font(.system(.title3, design: .rounded).bold())
                            Link("link", destination: URL(string: link)!)
                                .font(.title3.italic())
                            Spacer()
                        }
                    }
                    
                    if let coordinates = peak.coordinates {
                        NavigationLink(
                            destination:
                                MapView(coordinate: coordinates)
                                .edgesIgnoringSafeArea(.all)
                        ) {
                            MapView(coordinate: coordinates, interactionModes: [])
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .frame(height: 200)
                                .cornerRadius(20)
                        }
                    }
                    
                    Button {
                        self.showReview.toggle()
                    } label: {
                        Text("Rate it")
                            .font(.system(.headline, design: .rounded))
                            .frame(minWidth: 0, maxWidth: .infinity)
                    }
                    .tint(Color.blue)
                    .foregroundColor(.white)
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 25))
                    .controlSize(.large)
                    .padding(.bottom, 20)
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
                .foregroundColor(.blue)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .padding(10)
                        .background(Color.white.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                    }
                    .foregroundColor(.blue)
                    .opacity(showReview ? 0 : 1)
                }
            }
        }
        .ignoresSafeArea(.all, edges: [.top, .horizontal])
        .overlay(
            self.showReview ?
            ZStack {
                ReviewView(isDisplayed: $showReview, peak: peak)
                    .navigationBarHidden(true)
            }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            : nil
        )
        .onChange(of: peak.rating) { _ in
            try? self.moc.save()
        }
        .navigationBarTitle("Info: \(peak.title)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PeakDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PeakDetailView(peak: (PersistenceController.testData?.first)!)
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
