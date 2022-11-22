//
//  DetailsView.swift
//  FaceAssociator
//
//  Created by Nick on 2022-11-21.
//

import SwiftUI
import CoreLocation
import MapKit

struct DetailsView: View {
    var person: Person
    @State var mapRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    
    var body: some View {
        List {
            Section {
                Image(uiImage: person.image!)
                    .resizable()
                    .scaledToFit()
                    .navigationTitle(person.name)
            }
            
            Section {
                if let items = person.location {
                    Map(coordinateRegion: $mapRegion, interactionModes: .zoom, annotationItems: [items]) { location in
                        MapMarker(coordinate: location.coordinates)
                    }
                    .onAppear {
                        let _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { timer in
                            mapRegion.center = items.coordinates
                        }
                    }
                } else {
                    Text("No location added")
                        .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 200)
        }

    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(person: Person(id: UUID(), name: "Test", location: Location(longitude: 0.0, latitude: 0.0)))
    }
}
