//
//  SecondViewController.swift
//  ios-app
//
//  Created by Gwen Sax on 14/10/2024.
//

import Foundation
import UIKit

class SecondViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var crashButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func crashApp(_ sender: UIButton) {
        fatalError("User initiated crash")
    }

    
}
