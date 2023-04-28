//
//  ViewController.swift
//  wireviewer
//
//  Created by Weng Seong Cheang on 4/28/23.
//

import UIKit
import DisplayingTableViewFramework

class ViewController: UIViewController {

    lazy var coordinator: Coordinator = {
        return Coordinator(rootViewController: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        coordinator.start(withUrl: "https://api.duckduckgo.com/?q=the+wire+characters&format=json")
    }

}

