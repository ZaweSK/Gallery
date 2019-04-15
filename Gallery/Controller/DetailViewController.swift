//
//  DetailViewController.swift
//  Gallery
//
//  Created by Peter on 15/04/2019.
//  Copyright © 2019 Excellence. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIScrollViewDelegate {

    // MARK: - View Controller Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        spinner.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let urlString = item.remoteURLString else {return}
        
        ImageFetcher.fetchContent2(for: urlString).done { (image) in
            self.spinner.stopAnimating()
            self.image = image
            }.catch { error in
                self.imageView.image = UIImage(named: "placeholderImage")
        }
    }
    
    // MARK: - Stored Properities
    
    var item: GalleryItem!
    
    var image : UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            centerImage()
        }
    }
    
    // MARK : - @IBOutlets
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var imageViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var imageViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    @IBOutlet var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
        }
    }
    
    // MARK: - Centering Scroll View's content
    
    func centerImage(){
        
        fitImage(in: scrollView.bounds.size)
        
        updateConstraintsForImage(in: scrollView.bounds.size)
    }
    
    func fitImage(in view: CGSize) {
        let imageSize = image!.size
        
        let widthScale = view.width / imageSize.width
        let heightScale = view.height / imageSize.height
        
        let minScale = min(widthScale,heightScale)
        scrollView.minimumZoomScale = minScale * 0.2
        scrollView.maximumZoomScale = 5
        scrollView.zoomScale = minScale
    }
    
    func updateConstraintsForImage(in view: CGSize){
        
        let imageSize = image!.size
        
        let imageViewSize = CGSize(width: imageSize.width * scrollView.zoomScale, height: imageSize.height * scrollView.zoomScale)
        
        let yOffset = max(0 , (view.height - imageViewSize.height)/2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset
        
        let xOffset = max(0 , (view.width - imageViewSize.width)/2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
        
        self.view.layoutIfNeeded()
    }
    

    // MARK: - ScrollView's delegate methods
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForImage(in: scrollView.bounds.size)
    }
}
