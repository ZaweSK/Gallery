//
//  GallerySelectionTableViewCell.swift
//  Gallery
//
//  Created by Peter on 09/04/2019.
//  Copyright © 2019 Excellence. All rights reserved.
//

import UIKit

protocol GalleryNameEditDelegate {
    func galleryNameEdited(with newName: String, in cell: UITableViewCell)
}

class GallerySelectionTableViewCell: UITableViewCell, UITextFieldDelegate
{

    var delegate : GalleryNameEditDelegate?
    
    @IBOutlet var galleryNameTextField: UITextField! {
        didSet{
            galleryNameTextField.delegate = self
        }
    }
    
    var originalName: String = ""
    
    override var isEditing: Bool {
        didSet{
            
           galleryNameTextField.isEnabled = isEditing
            
            if isEditing == true {
                originalName = galleryNameTextField.text!
            }
            
            if isEditing {
                galleryNameTextField.becomeFirstResponder()
            }else {
                galleryNameTextField.resignFirstResponder()
            }
        }
    }
    
    func endEditing(){
        isEditing = false
    }
    
    override var canBecomeFirstResponder: Bool {
        return isEditing
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        endEditing()
        
        guard let newName = textField.text , newName != "", newName != originalName  else { return }
        
        delegate?.galleryNameEdited(with: newName, in: self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing()
        return true
    }
}
