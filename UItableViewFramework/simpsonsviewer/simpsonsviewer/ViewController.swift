//
//  ViewController.swift
//  simpsonsviewer
//
//  Created by Weng Seong Cheang on 4/26/23.
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
        coordinator.start(withUrl: "https://api.duckduckgo.com/?q=simpsons+characters&format=json")
    }
}

