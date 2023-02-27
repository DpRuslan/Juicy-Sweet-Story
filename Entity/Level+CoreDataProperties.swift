import Foundation
import CoreData


extension Level {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Level> {
        return NSFetchRequest<Level>(entityName: "Level")
    }

    @NSManaged public var id: Int64
    @NSManaged public var levelLockUnlock: Bool
    @NSManaged public var time: Int64

}

extension Level : Identifiable {

}
