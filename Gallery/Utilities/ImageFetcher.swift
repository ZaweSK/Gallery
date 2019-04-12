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


    static func fetchContent(for url: URL) -> Promise<UIImage> {
        
        let bgq = DispatchQueue.global(qos: .userInitiated)
        
        return Promise<UIImage> { seal in
            
            bgq.async {
                
                do {
                    let imageData = try Data(contentsOf: url.imageURL)
                    
                    if let image = UIImage(data: imageData) {
            
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
    
    static func fetchContent2(for urlString: String) -> Promise<UIImage> {
        
        let bgq = DispatchQueue.global(qos: .userInitiated)
        
        return Promise<UIImage> { seal in
            
            bgq.async {
                
                guard let url = URL(string: urlString)  else {return}
                
                do {
                    let imageData = try Data(contentsOf: url.imageURL)
                    
                    if let image = UIImage(data: imageData) {
                        
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
