//
//  SpreadsheetViewController.swift
//  vehsense
//
//  Created by Brian Green on 7/17/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//

import UIKit
import SpreadsheetView

class SpreadsheetViewController: UIViewController {

    @IBOutlet weak var spreadsheetView: SpreadsheetView!
    
    var data = [[Double]]()
    var header = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        spreadsheetView.dataSource = self
        spreadsheetView.delegate = self
        
        spreadsheetView.register(HeaderCell.self, forCellWithReuseIdentifier: String(describing: HeaderCell.self))
        spreadsheetView.register(TextCell.self, forCellWithReuseIdentifier: String(describing: TextCell.self))
    }

}

extension SpreadsheetViewController : SpreadsheetViewDataSource{
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return header.count
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return data[0].count
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        return 90
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        return 40
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        if case 0 = indexPath.row {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: HeaderCell.self), for: indexPath) as! HeaderCell
            cell.label.text = header[indexPath.column]
        
          return cell
        }
            else{
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TextCell.self), for: indexPath) as! TextCell
            cell.label.text = String(data[indexPath.column][indexPath.row])
                return cell
            }

      }
    
}

extension SpreadsheetViewController : SpreadsheetViewDelegate{
    
}
