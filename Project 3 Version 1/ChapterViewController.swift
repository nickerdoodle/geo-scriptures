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
    var objects = [Any]()

    var selectedBook: Book?
    var selectedChapter: Int?
    
    var book: Book = Book()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //navigationItem.leftBarButtonItem = editButtonItem

        //let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        //navigationItem.rightBarButtonItem = addButton
        
        print(selectedBook!)
        
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
            
            //added below
                
                mapViewController?.selection = sender as? (Book, Int)
            //}
        }
       //Didn't have this in before Thur night
        if segue.identifier == "showScriptureViewController"{
            
            /*if let splitVC = splitViewController{
                if let navVC = splitVC.viewControllers.last as? UINavigationController{
                    mapViewController = navVC.topViewController as? MapViewController
                    if mapViewController != nil{
                        //print("it's the first")
                        
                        performSegue(withIdentifier: "mapGeoSegue", sender: (selectedBook, selectedChapter))*/
                        /*let controller = segue.destination as! MapViewController
                        controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                        controller.navigationItem.leftItemsSupplementBackButton = true
                        mapViewController = controller*/
                        
                    /*}
                    
                }
                
            }*/
            //End of stuff
            
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
        if let numChapters = book.numChapters{
            return numChapters
        }
        else{
            return 0
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(selectedBook!)
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //let object = objects[indexPath.row] as! NSDate
        //cell.textLabel!.text = object.description
        //let chapter = book[indexPath.row]
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
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Grab the correct volume to send to next table
        selectedChapter = indexPath.row + 1
        print(selectedBook!)
        print(selectedChapter!)
        self.performSegue(withIdentifier: "showScriptureViewController", sender: (selectedBook, selectedChapter))
        
    }
    
    // TODO HAVE SPLIT VIEW CHECK IF THERE IS A MAPVIEW ON THE STACK. IF THERE ISNT ONE, NEED TO CREATE A NEW ONE. HAPPENS WHEN YOU SWITCH TO LANDSCAPE WHEN ON A CHAPTER


}


