//
//  OcrViewController.swift
//  MoneySmart
//
//  Created by Derek Qua on 20/1/21.
//

import Foundation
import UIKit

class OcrViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tabBarController?.parent?.tabBarController?.tabBar.isHidden = true
    }


}
