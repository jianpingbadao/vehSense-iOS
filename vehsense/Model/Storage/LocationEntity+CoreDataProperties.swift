//
//  LocationEntity+CoreDataProperties.swift
//  vehsense
//
//  Created by Brian Green on 7/22/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//
//

import Foundation
import CoreData


extension LocationEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocationEntity> {
        return NSFetchRequest<LocationEntity>(entityName: "LocationEntity")
    }

    @NSManaged public var lat: [Double]?
    @NSManaged public var long: [Double]?
    @NSManaged public var bearing: [Double]?
    @NSManaged public var timeList: [Double]?
    @NSManaged public var mph: [Double]?
    @NSManaged public var session: DriveSession?

}
