//
//  ViewController.swift
//  ExploringCollectionView
//
//  Created by User on 28.04.2024.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
   
    @IBOutlet weak var collectionViewOne: UICollectionView!
    @IBOutlet weak var collectionViewTwo: UICollectionView!
    
    let arryTemperature = ["temp.green", "temp.blackGreen", "temp.lightYellow", "temp.darkYellow", "temp.orange", "temp.red"]
    let arrySmail = ["favorite","nice","routine","notPleasant","bad","hate"]
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewOne.delegate = self
        collectionViewOne.dataSource = self
        collectionViewTwo.delegate = self
        collectionViewTwo.dataSource = self
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "ShowImageVC") as? ShowImageVC else { return }
        var currentSelectedImage: String!
        if collectionView == collectionViewOne {
            currentSelectedImage = arryTemperature[indexPath.row]
        }
        if collectionView == collectionViewTwo {
            currentSelectedImage = arrySmail[indexPath.row]
        }
        
        vc.setImageName(name: currentSelectedImage)
        present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewOne {
              return arryTemperature.count
            }
            if collectionView == collectionViewTwo {
              return arrySmail.count
            }
            return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewOne{
              if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellOne", for: indexPath) as? Cell {
                let imageName = arryTemperature[indexPath.row]
                cell.setTemperatureImage(tempName: imageName)
                return cell
              }
            }
            if collectionView == collectionViewTwo{
              if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellTwo", for: indexPath) as? Cell {
                let imageName = arrySmail[indexPath.row]
                  cell.setSmailImage(smailName: imageName)
                return cell
              }
            }
            return UICollectionViewCell()
    }
    
}

