//
//  Image.swift
//  Gallery
//
//  Created by Peter on 10/04/2019.
//  Copyright © 2019 Excellence. All rights reserved.
//

import Foundation
import UIKit

struct Image: Equatable  {
    var remoteURL : URL!
    
    
    init(url: URL) {
        self.remoteURL = url
    }
    
    init(){
        
    }
    
    static func == (lhs: Image, rhs: Image) -> Bool {
        return lhs.remoteURL == rhs.remoteURL
        
    }
}
