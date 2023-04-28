//
//  IpadViewController.swift
//  DisplayingTableViewFramework
//
//  Created by Weng Seong Cheang on 4/28/23.
//

import UIKit

class IpadViewController: UISplitViewController {
    // MARK: - Variables
    var webURLConfig:String? = nil
    
    fileprivate var sampleTableViewController: SampleTableViewController {
        if _sampleTableViewController == nil {
            let viewController = SampleTableViewController()
            viewController.configure(urlString: webURLConfig ?? "")
            viewController.delegate = self
            _sampleTableViewController = viewController
        }
        return _sampleTableViewController!
    }
    fileprivate var _sampleTableViewController: SampleTableViewController?
    
    fileprivate var displayInfoViewController: DisplayInfoViewController {
        if _displayInfoViewController == nil {
            let viewController = DisplayInfoViewController()
            _displayInfoViewController = viewController
        }
        return _displayInfoViewController!
    }
    fileprivate var _displayInfoViewController: DisplayInfoViewController?
    
    // MARK: - Override View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setViewController(sampleTableViewController, for: UISplitViewController.Column.primary)
        setViewController(displayInfoViewController, for: UISplitViewController.Column.secondary)
        
    }
    // MARK: - Inits
    override init(style: UISplitViewController.Style) {
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit
    {
        _sampleTableViewController = nil
        _displayInfoViewController = nil
    }
    // MARK: - Class functions
    func configure(urlString:String)
    {
        webURLConfig = urlString
    }
}
// MARK: - Delegate Extension
extension IpadViewController: SampleTableViewDelegate
{
    func didTapMenuItem(imageUrl: String, title: String, description: String) {
        displayInfoViewController.setInfo(imageURL: imageUrl, title: title, description: description)
    }
    
    
}
