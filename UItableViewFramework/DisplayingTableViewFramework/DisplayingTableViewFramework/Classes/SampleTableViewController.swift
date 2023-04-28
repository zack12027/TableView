//
//  sampleTableViewController.swift
//  DisplayingTableViewFramework
//
//  Created by Weng Seong Cheang on 4/26/23.
//

import UIKit

protocol SampleTableViewDelegate: AnyObject {
    func didTapMenuItem(imageUrl: String, title:String, description:String)
}
class SampleTableViewController: UIViewController {
    
    weak var delegate:SampleTableViewDelegate?
    // MARK: - Properties
    private var dataRetrieved: movieCharacters? = nil
    private var dataRetrievedOriginal: movieCharacters? = nil
    private var currentDevice:UIDevice = UIDevice.current
    
    fileprivate var displayInfoViewController: DisplayInfoViewController {
        if _displayInfoViewController == nil {
            let viewController = DisplayInfoViewController()
            _displayInfoViewController = viewController
        }
        return _displayInfoViewController!
    }
    fileprivate var _displayInfoViewController: DisplayInfoViewController?
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Override View
    open override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
    }
    
    override func loadView() {
        view = viewFromNib()
    }
    
    // MARK: - Class functions
    public func configure(urlString: String) {
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                // Handle error
                print(error.localizedDescription)
            }
            
            guard let data = data else {
                // Handle missing data
                return
            }
            
            // Parse data
            do {
                let jsonData = try JSONDecoder().decode(movieCharacters.self, from: data)
                self.dataRetrieved = jsonData
                self.dataRetrievedOriginal = jsonData
                DispatchQueue.main.async {
                   self.tableView.reloadData()
                }
            } catch {
                // Handle parsing error
            }
        }
        
        task.resume()
    }
}

// MARK: - Search Bar EXT
extension SampleTableViewController: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
               let filteredData = dataRetrievedOriginal?.relatedTopics?.filter { $0.text?.contains(searchText) ?? false }
            dataRetrieved?.relatedTopics = filteredData
            tableView.reloadData()
           }
           else {
               dataRetrieved = dataRetrievedOriginal
               tableView.reloadData()
           }
    }
}
// MARK: - Table View EXT
extension SampleTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataRetrieved?.relatedTopics?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = dataRetrieved?.relatedTopics?[indexPath.row].text?.components(separatedBy: "-")[0]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var imageURL = ""
        if(dataRetrieved?.relatedTopics?[indexPath.row].icon?.url != "")
        {
            imageURL = "https://duckduckgo.com/" + (dataRetrieved?.relatedTopics?[indexPath.row].icon?.url)!
        }
        let title = dataRetrieved?.relatedTopics?[indexPath.row].text?.components(separatedBy: "-")[0] ?? ""
        let description = String(dataRetrieved?.relatedTopics?[indexPath.row].text?.components(separatedBy: "-")[1].dropFirst() ?? "")
        displayInfoViewController.setInfo(imageURL: imageURL, title: title, description: description)
        delegate?.didTapMenuItem(imageUrl: imageURL, title: title, description: description)
        if UIDevice.current.userInterfaceIdiom == .phone {
            navigationController?.pushViewController(displayInfoViewController, animated: true)
        }
        
        
    }
}

