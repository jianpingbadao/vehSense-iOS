//
//  RecorderViewController.swift
//  vehsense
//
//  Created by Brian Green on 7/1/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//

import UIKit
import MobileCoreServices

class RecorderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        VideoHelper.startMediaBrowser(delegate: self as! UIViewController & UIImagePickerControllerDelegate & UINavigationControllerDelegate, sourceType: .camera)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
}


extension RecorderViewController : UIImagePickerControllerDelegate{
    
}
extension RecorderViewController: UINavigationControllerDelegate {
}
