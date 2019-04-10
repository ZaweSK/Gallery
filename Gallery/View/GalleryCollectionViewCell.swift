//
//  GalleryCollectionViewCell.swift
//  Gallery
//
//  Created by Peter on 10/04/2019.
//  Copyright © 2019 Excellence. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var label: UILabel!
    
    var url = URL(string: "https://www.facebook.com")
    
    
    override func prepareForReuse() {
        <#code#>
    }
}
