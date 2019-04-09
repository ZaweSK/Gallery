//
//  GallerySelectionTableViewController.swift
//  Gallery
//
//  Created by Peter on 09/04/2019.
//  Copyright © 2019 Excellence. All rights reserved.
//

import UIKit

class GallerySelectionTableViewController: UITableViewController {

    var itemsSub = ["Empty", "Empty2", "Empty3"]
    var recentlyDeletedSub : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? recentlyDeletedSub.count : itemsSub.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "galleryNameCell", for: indexPath)
        
        cell.textLabel?.text = itemsSub[indexPath.row]
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

}
