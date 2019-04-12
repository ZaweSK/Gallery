//
//  Gallery.swift
//  
//
//  Created by Peter on 11/04/2019.
//

import Foundation
import UIKit
import RealmSwift


class Gallery: Object {
    
    @objc dynamic var name : String  = ""
    @objc dynamic var recentlyDeleted : Bool = false 
    
    var items = List<GalleryItem>()
    
}
