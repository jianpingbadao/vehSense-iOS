//
//  DriveSession+CoreDataProperties.swift
//  vehsense
//
//  Created by Brian Green on 7/16/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//
//

import Foundation
import CoreData


extension DriveSession {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DriveSession> {
        return NSFetchRequest<DriveSession>(entityName: "DriveSession")
    }

    @NSManaged public var mphList: [Double]?
    @NSManaged public var bearingList: [Double]?
    @NSManaged public var latitudeList: [Double]?
    @NSManaged public var longitudeList: [Double]?
    @NSManaged public var locationTimeList: [Double]?
    @NSManaged public var gyroYList: [Double]?
    @NSManaged public var gyroXList: [Double]?
    @NSManaged public var gyroZList: [Double]?
    @NSManaged public var accXList: [Double]?
    @NSManaged public var accYList: [Double]?
    @NSManaged public var accZList: [Double]?
    @NSManaged public var accTimeList: [Double]?
    @NSManaged public var gyroTimeList: [Double]?
    @NSManaged public var magXList: [Double]?
    @NSManaged public var magYList: [Double]?
    @NSManaged public var magZList: [Double]?
    @NSManaged public var magTimeList: [Double]?
    @NSManaged public var sessionStartTime: String?
    @NSManaged public var sessionEndTime: String?

}
