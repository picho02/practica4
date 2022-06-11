//
//  Bebidas+CoreDataClass.swift
//  practica4
//
//  Created by Erendira Cruz Reyes on 07/04/22.
//
//

import Foundation
import CoreData

@objc(Bebidas)
public class Bebidas: NSManagedObject {
    func inicializaCon(_ dict: [String:String]){
        let image = dict["image"] ?? ""
        let name = dict["name"] ?? ""
        let ingredients = dict["ingredients"] ?? ""
        let directions = dict["directions"] ?? ""
        self.image = image
        self.name = name
        self.ingredients = ingredients
        self.directions = directions
    }

}
