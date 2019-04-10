//
//  GalleryCollectionViewController.swift
//  Gallery
//
//  Created by Peter on 09/04/2019.
//  Copyright © 2019 Excellence. All rights reserved.
//

import UIKit



class GalleryCollectionViewController: UICollectionViewController {
    
    var itemsSub = ["a","b","c", "e", "f", "g", "h"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

   

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsSub.count
    }


    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryItemCell", for: indexPath)
    
        cell.backgroundColor = UIColor.blue
    
        return cell
    }

   
}


// MARK: - UICollectionView DataLayout

extension GalleryCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    var flowLayout: UICollectionViewFlowLayout? {
        return collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
    }
    
    struct FlowLayoutConstatns {
        static let collectionViewInset: CGFloat = 10
        static let itemsHorizontalSpacing: CGFloat = 5
        static let itemsVerticalSpacing: CGFloat = 5
    }
    
    var numberOfItemsInRow : Int {
        return 2
    }
    
    var totalCollectionViewHorizontalPadding : CGFloat {
        return FlowLayoutConstatns.collectionViewInset * 2
    }
    
    var totalItemsHorizontalSpacing: CGFloat {
        return CGFloat((numberOfItemsInRow - 1)) * FlowLayoutConstatns.itemsHorizontalSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(#function)
        
        let itemsContainerWidth = view.bounds.width - totalCollectionViewHorizontalPadding
        
        let itemWidth = (itemsContainerWidth - totalItemsHorizontalSpacing) / CGFloat(numberOfItemsInRow)
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = FlowLayoutConstatns.collectionViewInset
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return FlowLayoutConstatns.itemsHorizontalSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return FlowLayoutConstatns.itemsVerticalSpacing
    }
    
    
    
    var isLandscape: Bool {
        switch traitCollection.verticalSizeClass {
        case .compact:
            return true
        case .regular:
            return false
        default : return false
        }
    }
    
}
