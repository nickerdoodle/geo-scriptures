//
//  MasterViewController.swift
//  Project 3 Version 1
//
//  Created by Nick Mahe on 11/2/19.
//  Copyright © 2019 Nick Mahe. All rights reserved.
//

import UIKit

class ChapterViewController: UITableViewController {

    
    weak var mapViewController: MapViewController?
    var selectedBook: Book?
    var selectedChapter: Int?
    var book: Book = Book()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//grab book details
        if let chosenBook = selectedBook{
            book = GeoDatabase.shared.bookForId(chosenBook.id)
            if let numChapters = book.numChapters{
                if numChapters == 1{
                    selectedChapter = 1
                }
            }
        }
        self.title = book.backName
    }

    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapGeoSegue" {
                let controller = segue.destination as! MapViewController
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                mapViewController = controller
                mapViewController?.selection = sender as? (Book, Int)
        }
        if segue.identifier == "showScriptureViewController"{
            let destinationVC = segue.destination as? ScriptureViewController
            destinationVC?.selection = sender as? (Book, Int)
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let numChapters = book.numChapters{
            return numChapters
        }
        else{
            return 0
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
// replace chapter with section for D&C
        var heading = "Chapter"
        if selectedBook?.id == 302{
            heading = "Section"
        }
        cell.textLabel!.text = "\(heading) \(indexPath.row + 1)"
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedChapter = indexPath.row + 1
        self.performSegue(withIdentifier: "showScriptureViewController", sender: (selectedBook, selectedChapter))
    }
}


