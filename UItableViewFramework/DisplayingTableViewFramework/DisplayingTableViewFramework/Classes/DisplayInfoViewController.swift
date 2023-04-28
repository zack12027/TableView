//
//  DisplayInfoViewController.swift
//  DisplayingTableViewFramework
//
//  Created by Weng Seong Cheang on 4/27/23.
//

import UIKit

class DisplayInfoViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Override View
    override func viewDidLoad() {
        super.viewDidLoad()
        //scrollView.contentSize = descriptionLabel.bounds.size
        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        view = viewFromNib()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        descriptionLabel.sizeToFit()
    }
    
    // MARK: - Class Functions
    public func setInfo(imageURL: String, title: String, description: String)
    {
        _ = self.view
        if(imageURL == "")
        {
            //imageView.image = UIImage(named: "defaultProfilePhoto")
            //is returning nil, I do not know why at the moment. So we download it from the web and display it once
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileName = documentDirectory.appendingPathComponent("defaultProfilePhoto.png")

            // Check if file exist
            if FileManager.default.fileExists(atPath: fileName.path) {
                // Load the image
                if let loadedImage = UIImage(contentsOfFile: fileName.path) {
                    imageView.image = loadedImage
                }
            } else {
                // Download the image
                do {
                    let imageData = try Data(contentsOf: URL(string: "https://i.imgur.com/GM5KBKm.jpg")!)
                    let image = UIImage(data: imageData)
                    // Save the image
                    if let pngImageData = image!.pngData() {
                        try? pngImageData.write(to: fileName)
                    }
                    imageView.image = image
                } catch {
                    print("something went wrong with image data")
                }

                
                
            }
            
        } else
        {
            DispatchQueue.global(qos: .background).async {
                let imageData = try? Data(contentsOf: URL(string: imageURL)!)
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: imageData!)
                }
            }
        }
        titleLabel.text = title
        descriptionLabel.text = description
      
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
// MARK: - Delegate Extensions
extension DisplayInfoViewController:SampleTableViewDelegate
{
    func didTapMenuItem(imageUrl: String, title: String, description: String) {
        setInfo(imageURL: imageUrl, title: title, description: description)
    }
    
    
}
