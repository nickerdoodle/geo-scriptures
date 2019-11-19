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

class ScriptureViewController: UIViewController, WKNavigationDelegate {

    //@IBOutlet weak var scriptureLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    private weak var mapViewController: MapViewController?
    
    static var scriptureId = String()
    var objects = [Any]()
    var selection: (Book, Int)?
    var selectedBook: Book?
    var selectedChapter: Int?
    //static var selectedChapter: Int = Int()
    var scripture: [Scripture] = [Scripture]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //from class
        webView.navigationDelegate = self

        /*func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            print("message: \(message.body)")
            // and whatever other actions you want to take
        }*/
        
        configureDetailViewController()
        

        print(selection!)
        if let data = selection{
            selectedBook = data.0
            selectedChapter = data.1
            scripture = GeoDatabase.shared.versesForScriptureBookId(data.0.id, data.1)
        }
        
        if let book = selectedBook{
           
            if let numChapters = book.numChapters{
                if numChapters < 2{
                    if numChapters == 1{
                        self.title = book.backName
                    }
                    else{
                       self.title = book.backName
                    }
                    webView.loadHTMLString( ScriptureRenderer.shared.htmlForBookId(book.id, chapter: numChapters)
                    , baseURL: nil)
                }
                else {
                    if let chapter = selectedChapter{
                        self.title = "\(book.backName) \(chapter)"
                        webView.loadHTMLString( ScriptureRenderer.shared.htmlForBookId(book.id, chapter: chapter)
                        , baseURL: nil)
                    }
                }
                
            }
            else{
                self.title = book.backName
                webView.loadHTMLString( ScriptureRenderer.shared.htmlForBookId(book.id, chapter: 0)
                , baseURL: nil)
            }
       
        }
        
        else{
            if let book = selectedBook{
                if let numChapters = book.numChapters{
                if numChapters < 1{
                    self.title = book.backName
                    webView.loadHTMLString( ScriptureRenderer.shared.htmlForBookId(book.id, chapter: numChapters)
                    , baseURL: nil)
                }
            }
            
            
        }
        }
   
        if let split = splitViewController {
            let controllers = split.viewControllers
                let mapVC = split.viewControllers.last as? MapViewController
                //mapViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? MapViewController
            
            //detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    /*override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
*/

    // MARK: - Segues
    //Edit this for selecting the books of the volume
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "showScriptureViewController"{
            print("success")
        }
        
        if segue.identifier == "textGeoSegue"{
            
                MapViewController.textClicked = true
            
        }
        
        if segue.identifier == "mapGeoSegue" {
            //if let indexPath = tableView.indexPathForSelectedRow {
                
                //let controller = (segue.destination as! UINavigationController).topViewController as! MapViewController
                    
            let controller = segue.destination as! MapViewController
            
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                mapViewController = controller
            //}
        }
    }

    //USE THE HYPERLINKED TEXT (A TAG'S BASEURL AND ID TO IDENTIFY WHICH WORDS HAVE LINKS AND CANCEL ITS FUNCTION TO ACT ON THE MAP FOR THE MARKER
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        //if let sourceFrame = navigationAction.targetFrame{
        //print(navigationAction.sourceFrame)
        print(navigationAction.request)
        print(navigationAction.navigationType)
        print(navigationAction.targetFrame!)
        //}
        
        let request: String = "\(navigationAction.request)"
        if request != "about:blank"{
            let startOfDomain = request.index(request.startIndex, offsetBy: 37)
            let range = startOfDomain..<request.endIndex
            ScriptureViewController.scriptureId = String(request[range])
            print(ScriptureViewController.scriptureId)
            decisionHandler(.cancel)
            self.performSegue(withIdentifier: "textGeoSegue", sender: self)
        }
        else{
            decisionHandler(.allow)
        }

    }
    
    private func configureDetailViewController(){
        mapViewController = nil
        if let splitVC = splitViewController{
            if let navVC = splitVC.viewControllers.last as? UINavigationController{
                mapViewController = navVC.topViewController as? MapViewController
            }
        }
        
        configureRightButton()
    }
    
    private func configureRightButton(){
        if mapViewController == nil{
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Map", style: .plain, target: self, action: #selector(ScriptureViewController.showMap))
        }
        else{
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc func showMap(){
        performSegue(withIdentifier: "mapGeoSegue", sender: self)
    }

}


