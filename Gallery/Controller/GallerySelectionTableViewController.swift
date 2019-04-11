//
//  GallerySelectionTableViewController.swift
//  Gallery
//
//  Created by Peter on 09/04/2019.
//  Copyright © 2019 Excellence. All rights reserved.
//

import UIKit

class GallerySelectionTableViewController: UITableViewController
{
    
    var itemsSub = ["Empty 1", "Empty 2", "Empty 3"] 
     
    var recentlyDeletedSub : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped(_:)))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView(self.tableView, didSelectRowAt: indexPath)
    }
    
    @IBAction func addNewGallery(_ sender: UIBarButtonItem) {
            let newGallery = "Empty".madeUnique(withRespectTo: itemsSub)
            itemsSub.append(newGallery)
            tableView.reloadData()
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if splitViewController?.preferredDisplayMode != .primaryOverlay{
            splitViewController?.preferredDisplayMode = . primaryOverlay
        }
    }
    
    @objc func doubleTapped(_ sender: UITapGestureRecognizer){
        if let indexPath = tableView.indexPathForRow(at: sender.location(in: self.view)) {
            guard indexPath.section == 0 else {return}
            if let cell = tableView.cellForRow(at: indexPath) as? GallerySelectionTableViewCell {
                cell.isEditing = true
            }
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? recentlyDeletedSub.count : itemsSub.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "galleryNameCell", for: indexPath) as! GallerySelectionTableViewCell
        cell.delegate = self
        cell.galleryNameTextField.text = itemsSub[indexPath.row]
        
      
        
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 1 ? "Recently Deleted" : nil
    }


    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            switch indexPath.section {
            case 0:
                recentlyDeletedSub += [itemsSub.remove(at: indexPath.row)]
                tableView.moveRow(at: indexPath, to: IndexPath(row: recentlyDeletedSub.count - 1 , section: 1) )
            case 1:
                recentlyDeletedSub.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            default:
                break
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath.section == 1 {
            let action = UIContextualAction(style: .normal, title: "Undelete") { (action, view, _ ) in
                let recoveringItem = self.recentlyDeletedSub.remove(at: indexPath.row)
                self.itemsSub.append(recoveringItem)
                self.tableView.reloadData()
            }
            
            return UISwipeActionsConfiguration(actions: [action])
        }else {
            return nil
        }
    }
    
    
    // MARK : - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showGallery", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGallery" {
            
            let indexPath = sender as! IndexPath
            let gallery = itemsSub[indexPath.row]
            
            let navigationVC = segue.destination as! UINavigationController
            let galleryVC = navigationVC.viewControllers.first as! GalleryCollectionViewController
            
            galleryVC.title = gallery
        }
    }
}




// MARK: - GalleryCellNameEditDelegate methods

extension GallerySelectionTableViewController: GalleryNameEditDelegate
{
    func galleryNameEdited(with newName: String, in cell: UITableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            itemsSub[indexPath.row] = newName
            tableView.reloadData()
        }
    }
}
