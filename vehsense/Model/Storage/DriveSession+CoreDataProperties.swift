//
//  DriveSession+CoreDataProperties.swift
//  vehsense
//
//  Created by Brian Green on 7/22/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//
//

import Foundation
import CoreData


extension DriveSession {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DriveSession> {
        return NSFetchRequest<DriveSession>(entityName: "DriveSession")
    }

    @NSManaged public var sessionEndTime: String?
    @NSManaged public var sessionStartTime: String?
    @NSManaged public var gyroscope: GyroEntity?
    @NSManaged public var locale: LocationEntity?
    @NSManaged public var magnetometer: MagEntity?
    @NSManaged public var accelerometer: AccEntity?

}
