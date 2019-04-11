//
//  GalleryCollectionViewController.swift
//  Gallery
//
//  Created by Peter on 09/04/2019.
//  Copyright © 2019 Excellence. All rights reserved.
//

import UIKit



class GalleryCollectionViewController: UICollectionViewController {
    
    var galleryImages : [Image] = {
        let image1 = Image(url: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTu4SFLvr4FLtDjZ5F4ivTUO8s_AcA588QiJ_Wz1gAqofpG8Tut9Q")!)

        let image3 = Image(url: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT0YFaQGjeg_f9U_bOjAOAS3_WmXl3ykffBmb_ahG3IbEDOxQNeEw")!)
        
        return [image1, image3]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dropDelegate = self
        collectionView.dragDelegate = self
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        flowLayout?.invalidateLayout()
    }

   

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryImages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryItemCell", for: indexPath) as! GalleryCollectionViewCell
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let galleryItem = galleryImages[indexPath.row]
        
        ImageFetcher.fetchContent(for: galleryItem).done { image in
            
            if let cell = self.isCellDisplayed(for: galleryItem) {
                
                cell.update(with: image)
            }
            
            }.catch { error in
                
                if let cell = self.isCellDisplayed(for: galleryItem) {
                    cell.imageNotFound()
                }
                
        }
    }
    
    
    private func isCellDisplayed(for image : Image) -> GalleryCollectionViewCell? {
        
        guard let imageIndex = galleryImages.index(of: image) else { return nil }
        
        let imageIndexPath = IndexPath(item: imageIndex, section: 0)
        
        let cell = collectionView.cellForItem(at: imageIndexPath) as? GalleryCollectionViewCell
        
        return cell ?? nil
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
        
        let galleryImage = galleryImages[indexPath.row]
        let itemProvider =  NSItemProvider(object: galleryImage.remoteURL as NSURL )
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = galleryImage
        
        return [dragItem]
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
        
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(row: 0, section: 0)
        
        let items = coordinator.items
        
        switch coordinator.proposal.operation {
          
        case .copy:
            
            if items.count == 1 , let item = items.first {
                
                let placeholderContext = coordinator.drop(item.dragItem, to: UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: "dropPlaceholderCell"))
                
                var draggedImage = Image()
                
                item.dragItem.itemProvider.loadObject(ofClass: NSURL.self) { (provider, error) in
                   
                    if let url = provider as? URL {
                        
                        draggedImage.remoteURL = url
                        
                        ImageFetcher.fetchContent(for: draggedImage).done { image in
                            
                            placeholderContext.commitInsertion(dataSourceUpdates: { insertionIndexPath in
                                self.galleryImages.insert(draggedImage, at: insertionIndexPath.row)
                            })
                            
                        }.catch { _ in
                            placeholderContext.deletePlaceholder()
                        }
                    }
                }
            }
            
        case .move:
            
            if items.count == 1 , let item = items.first, let sourceIndexPath = item.sourceIndexPath {
                
                collectionView.performBatchUpdates({
                    self.galleryImages.remove(at: sourceIndexPath.row)
                    self.galleryImages.insert(item.dragItem.localObject as! Image, at: destinationIndexPath.row)
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [destinationIndexPath])
                }, completion: nil)
                
                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            }
            
        default: break
        }
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
