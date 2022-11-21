//
//  DetailsView.swift
//  FaceAssociator
//
//  Created by Nick on 2022-11-21.
//

import SwiftUI

struct DetailsView: View {
    var person: Person
    
    var body: some View {
        NavigationView {
            Image(uiImage: person.image!)
                .resizable()
                .scaledToFit()
                .navigationTitle(person.name)
        }
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(person: Person(id: UUID(), name: "Test"))
    }
}
