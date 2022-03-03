//
//  AddNewPeakView.swift
//  Mountain app
//
//  Created by Pavel Sharenda on 23.02.22.
//

import SwiftUI

struct AddNewPeakView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @FocusState private var amountIsFocused: Bool
    
    @StateObject private var peakFormViewModel = PeakFormViewModel(image: UIImage(imageLiteralResourceName: "gallery"))
    @State private var showPhotoOptions = false
    @State private var showingAlert = false
    @State private var chooseLocation = false
    @State private var photoSource: PhotoSource?
    
    var isEverythingFilled: Bool {
        if peakFormViewModel.title.replacingOccurrences(of: " ", with: "") == "" {
            return false
        } else if peakFormViewModel.elevation == nil {
            return false
        } else if peakFormViewModel.descript.replacingOccurrences(of: " ", with: "") == "" {
            return false
        } else if peakFormViewModel.image == UIImage(imageLiteralResourceName: "gallery") {
            return false
        } else if peakFormViewModel.location == "" {
            return false
        } else {
            return true
        }
    }
    
    enum PhotoSource: Identifiable {
        case photoLibrary
        case camera
        
        var id: Int {
            hashValue
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    Group {
                        ZStack {
                            if peakFormViewModel.image == UIImage(imageLiteralResourceName: "gallery") {
                                VStack {
                                    Image(uiImage: peakFormViewModel.image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(minWidth: 0, maxWidth: .infinity)
                                        .frame(height: 125)
                                    
                                    Text("TAP TO ADD PHOTO")
                                        .font(.system(.headline, design: .rounded))
                                        .foregroundColor(.blue)
                                }
                                .onTapGesture {
                                    showPhotoOptions.toggle()
                                }
                            } else {
                                Image(uiImage: peakFormViewModel.image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .frame(height: 250)
                                    .cornerRadius(5)
                            }
                        }
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 250)
                        .clipped()
                        
                        Section {
                            TextField("Fill in the mountain name", text: $peakFormViewModel.title)
                                .focused($amountIsFocused)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(.blue, lineWidth: 1)
                                )
                        } header: {
                            Text("NAME")
                                .font(.system(.headline, design: .rounded))
                                .foregroundColor(.blue)
                        }
                        
                        Section {
                            TextField("Fill in the mountain elevation", value: $peakFormViewModel.elevation, format: .number)
                                .keyboardType(.numberPad)
                                .focused($amountIsFocused)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(.blue, lineWidth: 1)
                                )
                        } header: {
                            Text("ELEVATION")
                                .font(.system(.headline, design: .rounded))
                                .foregroundColor(.blue)
                        }
                        
                        Section {
                            HStack {
                                Button {
                                    chooseLocation.toggle()
                                } label: {
                                    Text(peakFormViewModel.location == "" ? "Choose a location" : peakFormViewModel.location)
                                }
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.blue, lineWidth: 1)
                            )
                        } header: {
                            Text("LOCATION")
                                .font(.system(.headline, design: .rounded))
                                .foregroundColor(.blue)
                        }
                        
                        Section {
                            TextEditor(text: $peakFormViewModel.descript)
                                .focused($amountIsFocused)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(.blue, lineWidth: 1)
                                )
                        } header: {
                            Text("DESCRIPTION")
                                .font(.system(.headline, design: .rounded))
                                .foregroundColor(.blue)
                        }
                        
                        Section {
                            TextField("https://www.example.net", text: $peakFormViewModel.link)
                                .focused($amountIsFocused)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(.blue, lineWidth: 1)
                                )
                        } header: {
                            Text("LINK (OPTIONAL)")
                                .font(.system(.headline, design: .rounded))
                                .foregroundColor(.blue)
                        }
                        
                        Section {
                            TextField("48.24, 16.38", text: $peakFormViewModel.coordinates)
                                .focused($amountIsFocused)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(.blue, lineWidth: 1)
                                )
                        } header: {
                            Text("COORDINATES (OPTIONAL)")
                                .font(.system(.headline, design: .rounded))
                                .foregroundColor(.blue)
                        }
                    }
                    .listRowSeparatorTint(.clear)
                    .listRowBackground(Color.clear)
                }
                .listStyle(GroupedListStyle())
            }
            .navigationTitle("Add a new mountain")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button("Done") {
                        amountIsFocused = false
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if isEverythingFilled {
                            save()
                            dismiss()
                        } else {
                            showingAlert.toggle()
                        }
                    } label: {
                        Text("Save")
                            .font(.system(.headline, design: .rounded))
                    }
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Warning"), message: Text("Please fill in all required fields."))
            }
            .sheet(isPresented: $chooseLocation) {
                CountryPicker(location: $peakFormViewModel.location)
                    .onAppear {
                        UITableView.appearance().backgroundColor = .secondarySystemBackground
                    }
                    .onDisappear {
                        UITableView.appearance().backgroundColor = .clear
                    }
            }
            .actionSheet(isPresented: $showPhotoOptions) {
                ActionSheet(title: Text(String(localized: "Choose your photo source", comment: "Choose your photo source")),
                            message: nil,
                            buttons: [
                                .default(Text(String(localized: "Camera", comment: "Camera"))) {
                                    self.photoSource = .camera
                                },
                                .default(Text(String(localized: "Photo Library", comment: "Photo Library"))) {
                                    self.photoSource = .photoLibrary
                                },
                                .cancel()
                            ])
            }
            .fullScreenCover(item: $photoSource) { source in
                switch source {
                case .photoLibrary: ImagePicker(sourceType: .photoLibrary, selectedImage: $peakFormViewModel.image).ignoresSafeArea()
                case .camera: ImagePicker(sourceType: .camera, selectedImage: $peakFormViewModel.image).ignoresSafeArea()
                }
            }
            .onAppear {
                UITableView.appearance().backgroundColor = .clear
            }
            .onDisappear {
                UITableView.appearance().backgroundColor = .secondarySystemBackground
            }
        }
    }
    
    private func save() {
        let peak = Peak(context: moc)
        
        peak.title = peakFormViewModel.title
        peak.descript = peakFormViewModel.descript
        peak.elevation = peakFormViewModel.elevation!
        peak.image = peakFormViewModel.image.pngData()!
        peak.location = peakFormViewModel.location
        
        if let _ = URL(string: peakFormViewModel.link) {
            peak.link = peakFormViewModel.link
        }
        
        var areCoordinatesGood = true
        for (n, item) in peakFormViewModel.coordinates.components(separatedBy: ", ").enumerated() {
            if Double(item) == nil || n >= 2 {
                areCoordinatesGood = false
                break
            }
        }
        
        if areCoordinatesGood {
            peak.coordinates = peakFormViewModel.coordinates
        }
        
        do {
            try moc.save()
        } catch {
            print("Failed to save the record...")
            print(error.localizedDescription)
        }
    }
}

struct AddNewPeakView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewPeakView()
    }
}
