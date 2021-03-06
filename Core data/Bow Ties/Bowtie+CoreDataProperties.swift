//
//  Bowtie+CoreDataProperties.swift
//  Bow Ties
//
//  Created by Mikhail Lyapich on 12.01.17.
//  Copyright © 2017 Razeware. All rights reserved.
//

import Foundation
import CoreData


extension Bowtie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Bowtie> {
        return NSFetchRequest<Bowtie>(entityName: "Bowtie");
    }

    @NSManaged public var name: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var searchKey: String?
    @NSManaged public var rating: Double
    @NSManaged public var tintColor: NSObject?
    @NSManaged public var lastWorn: NSDate?
    @NSManaged public var timesWorn: Int32
    @NSManaged public var photoData: NSData?

}
