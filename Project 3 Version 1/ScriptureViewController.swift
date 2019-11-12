//
//  MasterViewController.swift
//  Project 3 Version 1
//
//  Created by Nick Mahe on 11/2/19.
//  Copyright © 2019 Nick Mahe. All rights reserved.
//

import UIKit
import WebKit
import MapKit

class ScriptureViewController: UIViewController {

    //@IBOutlet weak var scriptureLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    var detailViewController: DetailViewController? = nil
    var objects = [Any]()

    var selectedChapter: Int? = nil
    //static var selectedChapter: Int = Int()
    var scripture: [Scripture] = [Scripture]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       /* let config = WKWebViewConfiguration()
        let source = "document.addEventListener('click', function(){ window.webkit.messageHandlers.iosListener.postMessage('click clack!'); })"
        let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        
        config.userContentController.addUserScript(script)
        config.userContentController.add(self, name: "iosListener")
        webView.configuration
        webView = WKWebView(frame: UIScreen.main.bounds, configuration: config)*/
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            print("message: \(message.body)")
            // and whatever other actions you want to take
        }
        
        // Do any additional setup after loading the view.
        //navigationItem.leftBarButtonItem = editButtonItem

        //let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        //navigationItem.rightBarButtonItem = addButton
        
        
        selectedChapter = ChapterViewController.selectedChapter
        self.title = "\(GeoDatabase.shared.bookForId(BookViewController.selectedBook).backName) \(ChapterViewController.selectedChapter)"
        scripture = GeoDatabase.shared.versesForScriptureBookId(BookViewController.selectedBook, ChapterViewController.selectedChapter)

        //ScriptureRenderer.shared.injectGeoPlaceCollector(GeoPlaceCollector())
        webView.loadHTMLString( ScriptureRenderer.shared.htmlForBookId(BookViewController.selectedBook, chapter: ChapterViewController.selectedChapter)
            , baseURL: nil)
        
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    /*override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    @objc
    func insertNewObject(_ sender: Any) {
        objects.insert(NSDate(), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }*/

    // MARK: - Segues
    //Edit this for selecting the books of the volume
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row] as! NSDate
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                detailViewController = controller
            }
        }*/
    }

    // MARK: - Table View

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }*/

    /*override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return objects.count
        if let numChapters = book.numChapters{
            return numChapters
        }
        else{
            return 0
        }
        
    }*/

    /*override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(selectedBook!)
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //let object = objects[indexPath.row] as! NSDate
        //cell.textLabel!.text = object.description
        //let chapter = book[indexPath.row]
        cell.textLabel!.text = "Chapter \(indexPath.row + 1)"
        return cell
    }*/

    /*override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
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
        ChapterViewController.selectedChapter = indexPath.row + 1
        //self.performSegue(withIdentifier: "showBookViewController", sender: nil)
        
    }*/

    
    
    

}


