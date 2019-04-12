//
//  GalleryItem.swift
//  Gallery
//
//  Created by Peter on 11/04/2019.
//  Copyright © 2019 Excellence. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class GalleryItem : Object {
    
    @objc dynamic var id : String = ""
    @objc dynamic var remoteURLString : String?
    
}
