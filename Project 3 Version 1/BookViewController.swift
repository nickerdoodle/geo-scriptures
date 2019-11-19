//
//  MasterViewController.swift
//  Project 3 Version 1
//
//  Created by Nick Mahe on 11/2/19.
//  Copyright © 2019 Nick Mahe. All rights reserved.
//

import UIKit

class BookViewController: UITableViewController {

    
    var mapViewController: MapViewController? = nil
    var objects = [Any]()

    var selectedVolume: Int?
    var selectedBook: Int?
    
    var theVolume: Int = Int()
    
    var books: [Book] = [Book]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedVolume!)
        // Do any additional setup after loading the view.
        //navigationItem.leftBarButtonItem = editButtonItem

        //let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        //navigationItem.rightBarButtonItem = addButton
        
        //put back in
        //selectedVolume = MasterViewController.selectedVolume
        if let volume = selectedVolume{
            books = GeoDatabase.shared.booksForParentId(volume)
            self.title = GeoDatabase.shared.bookForId(volume).backName
        }
        
        if let split = splitViewController {
            let mapVC = split.viewControllers.last as? MapViewController
            //mapViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? MapViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    @objc
    func insertNewObject(_ sender: Any) {
        objects.insert(NSDate(), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues
    //Edit this for selecting the books of the volume
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapGeoSegue" {
            //if let indexPath = tableView.indexPathForSelectedRow {
                //let controller = (segue.destination as! UINavigationController).topViewController as! MapViewController
                let controller = segue.destination as! MapViewController
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                mapViewController = controller
            //}
        }
        if segue.identifier == "showChapterViewController"{
            let destinationVC = segue.destination as? ChapterViewController
            destinationVC?.selectedBook = sender as? Book
            
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
        //return objects.count
        
        return books.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(selectedVolume!)
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //let object = objects[indexPath.row] as! NSDate
        //cell.textLabel!.text = object.description
        let volume = books[indexPath.row]
        cell.textLabel!.text = volume.fullName
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Grab the correct volume to send to next table
        
        var theBook: Book?
        selectedBook = books[indexPath.row].id
        
        if let book = selectedBook{
            theBook = GeoDatabase.shared.bookForId(book)
        }
        if let book = theBook{
            if let numChapters = book.numChapters{
                if numChapters < 2{
                    self.performSegue(withIdentifier: "showScriptureViewController", sender: (book, book.numChapters))
                }
                else{
                    self.performSegue(withIdentifier: "showChapterViewController", sender: book)
                }
            }
            else{
                self.performSegue(withIdentifier: "showScriptureViewController", sender: (book, 0))
            }
            
            
        }
        

    }


}


