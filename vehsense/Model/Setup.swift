//
//  Setup.swift
//  vehsense
//
//  Created by Brian Green on 6/27/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//

import Foundation

class Setup{
    
    static let shared = Setup()
    
    var accSelectedState = false
    var magSelectedState = false
    var gyroSelectedState = false
    var recSelectedState = false
    var obdSelectedState = false
    
    private init()
    {
  
    }
    
    func stateList() -> [Bool]
    {
        return [accSelectedState,magSelectedState,gyroSelectedState,recSelectedState,obdSelectedState]
    }
    
    
}
