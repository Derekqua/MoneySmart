//
//  IncomeViewController.swift
//  MoneySmart
//
//  Created by Derek Qua on 20/1/21.
//

import Foundation
import UIKit

class IncomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    var imageArray = [UIImage(named: "clothing"),UIImage(named: "entertainment"),UIImage(named: "food"),UIImage(named: "utilities"),UIImage(named: "transport"),UIImage(named: "uncategorized")]
    
    var textArray = ["Clothing", "Entertainment", "Food", "Utilities", "Transport", "Uncategorized"]
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/6, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        cell.catImage.image = imageArray[indexPath.row]
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 1
        cell.layer.backgroundColor = UIColor.white.cgColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        categoryField.text = textArray[indexPath.row]
    }
    

    @IBOutlet weak var categoryField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

  
}
