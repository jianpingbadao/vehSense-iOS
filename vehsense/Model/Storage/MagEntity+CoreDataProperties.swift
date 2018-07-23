//
//  MagEntity+CoreDataProperties.swift
//  vehsense
//
//  Created by Brian Green on 7/22/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//
//

import Foundation
import CoreData


extension MagEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MagEntity> {
        return NSFetchRequest<MagEntity>(entityName: "MagEntity")
    }

    @NSManaged public var x: [Double]?
    @NSManaged public var y: [Double]?
    @NSManaged public var z: [Double]?
    @NSManaged public var timeList: [Double]?
    @NSManaged public var session: DriveSession?

}
