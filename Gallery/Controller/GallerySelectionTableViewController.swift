//
//  GallerySelectionTableViewController.swift
//  Gallery
//
//  Created by Peter on 09/04/2019.
//  Copyright © 2019 Excellence. All rights reserved.
//

import UIKit
import RealmSwift

class GallerySelectionTableViewController: UITableViewController
{
    
    
    // MARK : - Stored Properities
    
    let realm = try! Realm()
    var galleries : Results<Gallery>?
    var recentlyDeletedGalleries : Results<Gallery>?
    
    
    // MARK : - Realm DB methods
    
    func loadGalleries() {
        
        let allGalleries = realm.objects(Gallery.self)
        
        galleries = allGalleries.filter(NSPredicate(format: "recentlyDeleted == false"))
        recentlyDeletedGalleries = allGalleries.filter(NSPredicate(format: "recentlyDeleted == true" ))
    }
    
    func addNew(_ gallery: Gallery){
        do { try realm.write {
                realm.add(gallery)
            }
        } catch {
        
            let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        }
        
       tableView.reloadData()
    }
    
    func update(gallery: Gallery, with bool: Bool){
        do { try realm.write {
                gallery.recentlyDeleted = bool
            }}catch {
            print(error)
        }
    }
    
    func delete(_ gallery: Gallery){
        do { try realm.write {
                realm.delete(gallery.items)
                realm.delete(gallery)}
        } catch { }
    }
    
    func updateGalleryName(for gallery: Gallery, with name: String){
        do { try realm.write {
                gallery.name = name }
        } catch {}
       tableView.reloadData()
    }
    
    // MARK: - View Controller's Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadGalleries()
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped(_:)))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if splitViewController?.preferredDisplayMode != .primaryOverlay{
            splitViewController?.preferredDisplayMode = . primaryOverlay
        }
    }
    
    
    // MARK: - Target Actions
    
    @IBAction func addNewGallery(_ sender: UIBarButtonItem) {
        
        var galleryNames = [String]()
        
        galleries?.forEach {
            galleryNames.append($0.name)
        }
        let name = "Empty".madeUnique(withRespectTo: galleryNames)
        let gallery = Gallery()
        gallery.name = name
        
        addNew(gallery)
    }
    
    
    
    @objc func doubleTapped(_ sender: UITapGestureRecognizer){
        if let indexPath = tableView.indexPathForRow(at: sender.location(in: self.view)) {
            guard indexPath.section == 0 else {return}
            if let cell = tableView.cellForRow(at: indexPath) as? GallerySelectionTableViewCell {
                cell.isEditing = true
            }
        }
    }
    
    // MARK: - Table view data source & delegate methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? recentlyDeletedGalleries?.count ?? 0 : galleries?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "galleryNameCell", for: indexPath) as! GallerySelectionTableViewCell
        cell.delegate = self
        cell.galleryNameTextField.text = galleries?[indexPath.row].name
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 1 ? "Recently Deleted" : nil
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            switch indexPath.section {
            case 0:
                guard let gallery = galleries?[indexPath.row] else {return }
                update(gallery: gallery, with: true)
                tableView.moveRow(at: indexPath, to: IndexPath(row: recentlyDeletedGalleries!.count - 1 , section: 1) )
            case 1:
                guard let gallery = recentlyDeletedGalleries?[indexPath.row] else {return }
                delete(gallery)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            default:
                break
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath.section == 1 {
            let action = UIContextualAction(style: .normal, title: "Undelete") { (action, view, _ ) in
                if let gallery = self.recentlyDeletedGalleries?[indexPath.row]{
                    
                    self.update(gallery: gallery, with: false)
                    self.tableView.reloadData()
                }
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
            
            DispatchQueue.main.async {
                guard let gallery = self.galleries?[indexPath.row] else {return}
                
                
                let navigationVC = segue.destination as! UINavigationController
                let galleryVC = navigationVC.viewControllers.first as! GalleryCollectionViewController
                
                galleryVC.gallery = gallery
                galleryVC.title = gallery.name
            }
        }
    }
}

// MARK: - GalleryCellNameEditDelegate methods

extension GallerySelectionTableViewController: GalleryNameEditDelegate
{
    func galleryNameEdited(with newName: String, in cell: UITableViewCell) {
        if let indexPath = tableView.indexPath(for: cell), let gallery = galleries?[indexPath.row] {
            updateGalleryName(for: gallery, with: newName)
        }
    }
}
