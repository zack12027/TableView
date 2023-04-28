//
//  Coordinator.swift
//  DisplayingTableViewFramework
//
//  Created by Weng Seong Cheang on 4/27/23.
//

import Foundation
import UIKit

open class Coordinator {
    
    // MARK: - Properties
    public let window: UIWindow?
    
    public let rootViewController: UIViewController?
    
    public var webURLConfig : String? = nil
    
    // MARK: Private
    fileprivate static let bundle = Bundle(for: SampleTableViewController.self)
    
    // MARK: View Controllers
    fileprivate var navigationController: UINavigationController {
        if _navigationController == nil {
        
            _navigationController = UINavigationController(rootViewController: self.initialViewController)
            
        }
        return _navigationController!
    }
    private var _navigationController: UINavigationController?
    
    fileprivate var initialViewController: SampleTableViewController {
        if _initialViewController == nil {
            let viewController = SampleTableViewController()
            viewController.configure(urlString: webURLConfig ?? "")
            _initialViewController = viewController
        }
        return _initialViewController!
    }
    fileprivate var _initialViewController: SampleTableViewController?
    
    fileprivate var ipadViewController: IpadViewController {
        if _ipadViewController == nil {
            let viewController = IpadViewController(style: UISplitViewController.Style.doubleColumn)
            viewController.configure(urlString: webURLConfig ?? "")
            _ipadViewController = viewController
        }
        return _ipadViewController!
    }
    fileprivate var _ipadViewController: IpadViewController?
    
    // MARK: - Inits
    
    public init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
        self.window = nil
    }

    public init(window: UIWindow) {
        self.window = window
        self.rootViewController = nil
    }
    // MARK: - Class Functions
    open func start(animated: Bool = true, withUrl: String) {
    webURLConfig = withUrl
    if let rootViewController = rootViewController {
        if UIDevice.current.userInterfaceIdiom == .pad {
            rootViewController.present(ipadViewController, animated: animated, completion: nil)
        }else
        {
            rootViewController.present(navigationController, animated: animated, completion: nil)
        }
    } else if let window = window {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
            
    }

    open func finish(animated: Bool = true) {
        if let rootViewController = rootViewController {
            rootViewController.dismiss(animated: animated, completion: nil)
        }
        _initialViewController = nil
        _ipadViewController = nil
        _navigationController = nil
    }
    
}

// MARK: - UiViewController Extension

public extension UIViewController {
    
    func viewFromNib(optionalName: String? = nil) -> UIView {
        let name = optionalName ?? String(describing: type(of: self))
        let bundle = Bundle(for: Coordinator.self)
        guard let view = bundle.loadNibNamed(name, owner: self, options: nil)?.first as? UIView else {
            fatalError("Nib not found.")
        }
        return view
    }
    
}
