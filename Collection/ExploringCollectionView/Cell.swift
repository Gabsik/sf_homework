//
//  Cell.swift
//  ExploringCollectionView
//
//  Created by User on 28.04.2024.
//

import UIKit

class Cell: UICollectionViewCell {
    
@IBOutlet weak var temperatureImage: UIImageView!
@IBOutlet weak var smailImage: UIImageView!
    
    func setTemperatureImage (tempName: String) {
        temperatureImage.image = UIImage(named: tempName)
    }
    func setSmailImage (smailName: String) {
        smailImage.image = UIImage(named: smailName)
    }
    
    
}
