//
//  MapView.swift
//  Mountain app
//
//  Created by Pavel Sharenda on 25.02.22.
//

import SwiftUI
import MapKit

struct AnnotatedItem: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    @State private var region: MKCoordinateRegion
    var annotatedItem: AnnotatedItem
    var interactionModes: MapInteractionModes
    
    var body: some View {
        Map(coordinateRegion: $region, interactionModes: interactionModes, annotationItems: [annotatedItem]) { item in
            MapMarker(coordinate: item.coordinate, tint: .red)
        }
    }
    
    init(coordinate: String, interactionModes: MapInteractionModes = .all) {
        let latitude = Double(coordinate.components(separatedBy: ", ")[0])!
        let longitude = Double(coordinate.components(separatedBy: ", ")[1])!
        
        _region = State(initialValue: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.0015, longitudeDelta: 0.0015)))
        annotatedItem = AnnotatedItem(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        self.interactionModes = interactionModes
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(coordinate: "28.89, 83.86")
    }
}
