//
//  ShowImageVC.swift
//  ExploringCollectionView
//
//  Created by User on 28.04.2024.
//

import UIKit

class ShowImageVC: UIViewController {
    @IBOutlet weak var currentImage: UIImageView!
    var imageName: String!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        currentImage.image = UIImage(named:  imageName)

    }
    
    func setImageName(name: String) {
        imageName = name
    }
}
