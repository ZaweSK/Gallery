//
//  ImageStre.swift
//  Gallery
//
//  Created by Peter on 15/04/2019.
//  Copyright © 2019 Excellence. All rights reserved.
//

import Foundation
import UIKit

struct ImageStore {
    
    
    static func localURL(withKey key: String)->URL{
        
       let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
       let documentDirectory = documentsDirectory.first!
       return documentDirectory.appendingPathComponent(key)
    }
    
    static func save(_ image: UIImage, for galleryItem: GalleryItem){
        let uid = galleryItem.id
        let imageURL = localURL(withKey: uid)
        if let data = image.jpegData(compressionQuality: 0.8) {
            try? data.write(to: imageURL)
        }
    }
    
    static func getImage(for galleryItem: GalleryItem)->UIImage?{
        let local = localURL(withKey: galleryItem.id)
        
        guard let image = UIImage(contentsOfFile: local.path) else {
            return nil
        }
        return image
    }
    
    static func removeImage(for galleryItem : GalleryItem) throws{
        
        let url = localURL(withKey: galleryItem.id)
        
        try FileManager.default.removeItem(at: url)
        
        print("deleted from disk")
        
    }
}
