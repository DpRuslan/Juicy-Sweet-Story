//
//  Level+CoreDataProperties.swift
//  Juicy Sweet Story
//
//  Created by Ruslan Yarkun on 27.02.2023.
//
//

import Foundation
import CoreData


extension Level {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Level> {
        return NSFetchRequest<Level>(entityName: "Level")
    }

    @NSManaged public var levelLockUnlock: Bool
    @NSManaged public var id: Int64

}

extension Level : Identifiable {

}
