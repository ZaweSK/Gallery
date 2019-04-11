//
//  ImageFetcher.swift
//  Gallery
//
//  Created by Peter on 11/04/2019.
//  Copyright © 2019 Excellence. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire
import UIKit

enum PhotoFetchError: Error {
    case unableToCreatePhotoFromData
}

struct ImageFetcher {


    static func fetchContent(for image: Image) -> Promise<UIImage> {
        
        print("------------------")
        print(image.remoteURL)
        
        let bgq = DispatchQueue.global(qos: .userInitiated)
        
        return Promise<UIImage> { seal in
            
            bgq.async {
                
                do {
                    let imageData = try Data(contentsOf: image.remoteURL.imageURL)
                    
                    if let image = UIImage(data: imageData) {
                        print(image)
                        seal.fulfill(image)
                    }else {
                        seal.reject(PhotoFetchError.unableToCreatePhotoFromData)
                    }
                    
                }catch {
                    seal.reject(error)
                }
            }
        }
    }


}
