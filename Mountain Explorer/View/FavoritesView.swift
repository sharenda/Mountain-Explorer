//
//  FavoritesView.swift
//  Mountain app
//
//  Created by Pavel Sharenda on 22.02.22.
//

import SwiftUI

struct FavoritesView: View {
    @FetchRequest(entity: Peak.entity(), sortDescriptors: []) var peaks: FetchedResults<Peak>
    @Environment(\.managedObjectContext) var moc
    @State private var showNewPeak = false
    @State private var showWalkthrough = false
    @State private var searchText = ""
    @AppStorage("hasViewedWalkthrough") var hasViewedWalkthrough: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                if peaks.count == 0 {
                    VStack {
                        Image("mountains-hills")
                            .resizable()
                            .scaledToFit()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: 125)
                            .shadow(color: .blue, radius: 2)
                        Text("NOTHING HERE")
                            .font(.system(.headline, design: .rounded))
                            .foregroundColor(.blue)
                    }
                    .listRowSeparator(.hidden)
                    .padding(.top, 100)
                } else {
                    ForEach(peaks.indices, id: \.self) { index in
                        NavigationLink {
                            PeakDetailView(peak: peaks[index])
                                .navigationBarBackButtonHidden(true)
                        } label: {
                            BasicTextImageRow(peak: peaks[index])
                        }
                    }
                    .onDelete(perform: deleteRecord)
                    .listRowSeparator(.hidden)
                }
            }
            .searchable(text: $searchText)
            .listStyle(.plain)
            .navigationTitle("Favourites")
            .toolbar {
                ToolbarItem {
                    Button {
                        showNewPeak.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showNewPeak) {
            AddNewPeakView()
        }
        .sheet(isPresented: $showWalkthrough) {
            TutorialView()
        }
        .onAppear() {
            showWalkthrough = hasViewedWalkthrough ? false : true
        }
        .onChange(of: searchText) { searchText in
            let predicate = searchText.isEmpty ? NSPredicate(value: true) : NSPredicate(format: "title CONTAINS[c] %@", searchText)
            peaks.nsPredicate = predicate
        }
        .task {
            prepareNotification()
        }
    }
    
    private func deleteRecord(indexSet: IndexSet) {
        for index in indexSet {
            let itemToDelete = peaks[index]
            moc.delete(itemToDelete)
        }
        
        DispatchQueue.main.async {
            do {
                try moc.save()
                
            } catch {
                print(error)
            }
        }
    }
    
    private func prepareNotification() {
        // Make sure the restaurant array is not empty
        if peaks.count <= 0 {
            return
        }
        // Create the user notification
        let content = UNMutableNotificationContent()
        content.title = "Mountain Recommendation"
        content.subtitle = "Explore new mountains today!"
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "Mountain_Explorer.Suggestion", content: content, trigger: trigger)
        // Schedule the notification
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

struct BasicTextImageRow: View {
    let peak: Peak
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            if let imageData = peak.image {
                Image(uiImage: UIImage(data: imageData) ?? UIImage())
                    .resizable()
                    .frame(width: 120, height: 118)
                    .cornerRadius(20)
                    .shadow(color: .blue, radius: 2)
            }
            
            VStack(alignment: .leading) {
                Spacer()
                Text(peak.title)
                    .font(.system(.title2, design: .rounded).bold())
                    .foregroundColor(.blue)
                
                Text("\(peak.elevation.formatted()) m")
                    .font(.system(.title3, design: .rounded))
                    .foregroundColor(.blue)
                
                Text(peak.location)
                    .font(.system(.title3, design: .rounded))
                    .foregroundColor(.blue)
                
                Spacer()
            }
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
