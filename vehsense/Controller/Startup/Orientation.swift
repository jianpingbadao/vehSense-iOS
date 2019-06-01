//
//  Orientation.swift
//  vehsense
//
//  Created by Brian Green on 8/3/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//

import Foundation
import UIKit


//class is responsible for locking SPECIFIC view controllers, instead of locking entire app in one orientation, functionality is implemented in Startup files (sign in , register, recovery

struct AppUtility {
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        
        self.lockOrientation(orientation)
        
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
    
}
