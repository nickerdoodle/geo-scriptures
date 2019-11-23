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

    @IBOutlet weak var webView: WKWebView!
    private weak var mapViewController: MapViewController?
    
    static var scriptureId = String()
    var objects = [Any]()
    var selection: (Book, Int)?
    var selectedBook: Book?
    var selectedChapter: Int?
    var scripture: [Scripture] = [Scripture]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
    //grab the passed scripture info
        if let data = selection{
            selectedBook = data.0
            selectedChapter = data.1
            scripture = GeoDatabase.shared.versesForScriptureBookId(data.0.id, data.1)
        }
     // set the web page based on if it is a one chapter book or if a chapter was selected
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
        
        configureDetailViewController()

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //configureDetailViewController()
    }
    
    // MARK: - Segues
    //Edit this for selecting the books of the volume
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "showScriptureViewController"{
        }
        
        //segue if a geoplace was tapped
        if segue.identifier == "textGeoSegue"{
                MapViewController.textClicked = true
            let controller = (segue.destination as! UINavigationController).topViewController as! MapViewController
            mapViewController = controller
            mapViewController?.selection = selection
        }
       //segue for all the geoplaces in the chapter
        if segue.identifier == "mapGeoSegue" {
         
            let controller = (segue.destination as! UINavigationController).topViewController as! MapViewController

            mapViewController = controller
            mapViewController?.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            mapViewController?.navigationItem.leftItemsSupplementBackButton = true
            mapViewController?.selection = selection
        }
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        let request: String = "\(navigationAction.request)"
        if request != "about:blank"{
            //grab the request and get substring of the scripture id
            let startOfDomain = request.index(request.startIndex, offsetBy: 37)
            let range = startOfDomain..<request.endIndex
            ScriptureViewController.scriptureId = String(request[range])
            decisionHandler(.cancel)
            self.performSegue(withIdentifier: "textGeoSegue", sender: (selectedBook, selectedChapter))
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
                if mapViewController != nil{
                    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(ScriptureViewController.showMap))
                    performSegue(withIdentifier: "mapGeoSegue", sender: (selectedBook, selectedChapter))
                }
                
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
        performSegue(withIdentifier: "mapGeoSegue", sender: (selectedBook, selectedChapter))
    }

}


