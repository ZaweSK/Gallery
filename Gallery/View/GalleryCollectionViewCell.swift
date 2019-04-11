//
//  GalleryCollectionViewCell.swift
//  Gallery
//
//  Created by Peter on 10/04/2019.
//  Copyright © 2019 Excellence. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    @IBOutlet var imageView: UIImageView!
    
    func update(with image: UIImage?){
        
        if let imageToDisplay = image {
            print("stopAnimating")
            spinner.stopAnimating()
            imageView.image = imageToDisplay
            
        }else {
            spinner.startAnimating()
            imageView.image = nil
        }
    }
    
    func imageNotFound(){
        spinner.stopAnimating()
        imageView.image = UIImage(named: "placeholderImage")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        update(with: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        update(with: nil)
    }
}
