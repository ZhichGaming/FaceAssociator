//
//  ContentView.swift
//  FaceAssociator
//
//  Created by Nick on 2022-11-20.
//

import SwiftUI
import CoreLocation
import MapKit

struct ContentView: View {
    @StateObject var personVM = PersonVM()
    
    @State var showingSheet = false
    @State var showingImagePicker = false
    
    @State var id = UUID()
    @State var name = ""
    @State var chosenImage: UIImage?
    
    @State var mapRegion: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    let locationFetcher = LocationFetcher()
    
    var body: some View {
        NavigationView {
            List(personVM.people.sorted()) { person in
                NavigationLink {
                    DetailsView(person: person)
                } label: {
                    HStack {
                        if let image = person.image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100)
                        }
                        
                        Text(person.name)
                    }
                }
            }
            .navigationTitle("FaceAssociator")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingSheet) {
                NavigationView {
                    List {
                        Section {
                            TextField("Name", text: $name)
                        }
                        
                        Section {
                            Button {
                                showingImagePicker = true
                            } label: {
                                Group {
                                    if let image = chosenImage {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFit()
                                    } else {
                                        Text("Choose an image")
                                    }
                                }
                            }
                            .sheet(isPresented: $showingImagePicker) {
                                ImagePicker(image: $chosenImage)
                            }
                        }
                        
                        Section {
                            if locationFetcher.lastKnownLocation != nil {
                                Map(coordinateRegion: $mapRegion, interactionModes: .zoom, showsUserLocation: true)
                                    .frame(height: 200)
                            } else {
                                Text("You have not allowed the app to view your location.")
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 200)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .onAppear {
                            locationFetcher.start()
                        }
                        .onChange(of: locationFetcher.lastKnownLocation) { newLocation in
                            guard let newLocation = newLocation else {
                                print("New location is nil")
                                return
                            }

                            mapRegion.center = newLocation
                        }
                    }
                    .navigationTitle("New Person")
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Button("Save") {
                                personVM.save(id: id,
                                              name: name,
                                              uiImage: chosenImage,
                                              location:
                                                locationFetcher.lastKnownLocation != nil
                                              ? Location(longitude: locationFetcher.lastKnownLocation!.longitude,
                                                         latitude: locationFetcher.lastKnownLocation!.latitude)
                                              : nil)
                                id = UUID()
                                name = ""
                                chosenImage = nil
                                
                                showingSheet = false
                            }
                            .disabled(name.isEmpty || chosenImage == nil)
                        }
                    }
                    
                    if chosenImage != nil {
                        Image(uiImage: chosenImage!)
                    } else {
                        Text("Empty")
                    }
                }
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
