//
//  PersonVM.swift
//  FaceAssociator
//
//  Created by Nick on 2022-11-20.
//

import Foundation
import UIKit
import SwiftUI

class PersonVM: ObservableObject {
    @Published var people = [Person]()

    init() {
        load()
    }
    
    func load() {
        let documentsDirectory: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let saveUrl = documentsDirectory.appendingPathComponent("people")

        do {
            if !FileManager().fileExists(atPath: saveUrl.path()) {
                try FileManager().createDirectory(at: saveUrl, withIntermediateDirectories: true)
            }
            
            let savePathContents = try FileManager().contentsOfDirectory(atPath: saveUrl.path())

            for savePathContent in savePathContents where !savePathContent.contains(".jpeg") {
                let data = try Data(contentsOf: saveUrl
                    .appendingPathComponent(savePathContent, conformingTo: .item))
                var decoded = try JSONDecoder().decode(Person.self, from: data)
                let imageData = try Data(contentsOf: saveUrl
                    .appendingPathComponent(savePathContent, conformingTo: .jpeg))
                let image = UIImage(data: imageData)
                
                decoded.image = image
                people.append(decoded)
            }
        } catch {
            print(error)
        }
    }
    
    func save(id: UUID, name: String, uiImage: UIImage?) {
        let documentsDirectory: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let savePath = documentsDirectory
            .appendingPathComponent("people")
        
        people.append(Person(id: id, name: name, image: uiImage!))
        
        do {
            let person = Person(id: id, name: name)
            let encoded = try JSONEncoder().encode(person)
            try encoded.write(to: savePath.appendingPathComponent(id.uuidString, conformingTo: .item))
            try uiImage?.jpegData(compressionQuality: 0.8)?.write(to: savePath.appendingPathComponent(id.uuidString, conformingTo: .jpeg))
        } catch {
            print(error)
        }
    }
}
