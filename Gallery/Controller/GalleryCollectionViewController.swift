//
//  GalleryCollectionViewController.swift
//  Gallery
//
//  Created by Peter on 09/04/2019.
//  Copyright © 2019 Excellence. All rights reserved.
//

import UIKit



class GalleryCollectionViewController: UICollectionViewController {
    
    var itemsSub = ["a","b","c", "d"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dropDelegate = self
        collectionView.dragDelegate = self
        
    }

   

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsSub.count
    }


    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryItemCell", for: indexPath) as! GalleryCollectionViewCell
    
        cell.backgroundColor = UIColor.gray
        cell.label.text = itemsSub[indexPath.row]
        
        return cell
    }

   
}

// MARK: - UIColletionView Drag & Drop

extension GalleryCollectionViewController:  UICollectionViewDropDelegate, UICollectionViewDragDelegate{
    
    // DRAG
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView
        return dragItems(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dragItems(at: indexPath)
    }

    private func dragItems(at indexPath: IndexPath)->[UIDragItem]{
        
        if let url = (collectionView.cellForItem(at: indexPath) as? GalleryCollectionViewCell)?.url as NSURL? {

            let dragItem = UIDragItem(itemProvider: NSItemProvider(object: url))
            dragItem.localObject = url

            return [dragItem]
        } else {
            return []
        }
    }
    
    // DROP
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        if collectionView.hasActiveDrag{
            return session.canLoadObjects(ofClass: NSURL.self)
        }else {
            return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isSelf = (session.localDragSession?.localContext) as? UICollectionView == collectionView
        
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        print("perform drop")
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
        return 3
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
    
}
