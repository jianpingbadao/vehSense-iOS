//
//  AuthAlert.swift
//  vehsense
//
//  Created by Brian Green on 8/4/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//

import Foundation
import UIKit

struct Alert{
    
    static func alertWithAction(vc : UIViewController, message : String, userAction: @escaping () -> ()){
        var action : UIAlertAction
        let alertController = UIAlertController(title: NSLocalizedString(message, comment: ""), message: NSLocalizedString("", comment: ""), preferredStyle: .alert)
        
        action = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .cancel) { (_) in
            userAction()
        }
        
        alertController.addAction(action)
        vc.present(alertController, animated: true, completion: nil)
    }
    
    
    static func showAlert(vc : UIViewController, message : String){
        var action : UIAlertAction
        let alertController = UIAlertController(title: NSLocalizedString(message, comment: ""), message: NSLocalizedString("", comment: ""), preferredStyle: .alert)
        
        action = UIAlertAction(title: NSLocalizedString("Ok", comment: ""), style: .cancel) { (_) in }
        
        alertController.addAction(action)
        vc.present(alertController, animated: true, completion: nil)
    }
    
    
}
