//
//  Bebidas+CoreDataProperties.swift
//  practica4
//
//  Created by Erendira Cruz Reyes on 07/04/22.
//
//

import Foundation
import CoreData


extension Bebidas {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bebidas> {
        return NSFetchRequest<Bebidas>(entityName: "Bebidas")
    }

    @NSManaged public var image: String?
    @NSManaged public var directions: String?
    @NSManaged public var name: String?
    @NSManaged public var ingredients: String?

}

extension Bebidas : Identifiable {

}
