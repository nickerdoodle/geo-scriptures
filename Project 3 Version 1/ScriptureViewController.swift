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
    
    static var scriptureId = String()
    var detailViewController: DetailViewController? = nil
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
    
        
        //selectedChapter = ChapterViewController.selectedChapter
        //if ChapterViewController.selectedChapter < 1{
        print(selection!)
        if let data = selection{
            selectedBook = data.0
            selectedChapter = data.1
            scripture = GeoDatabase.shared.versesForScriptureBookId(data.0.id, data.1)
        }
        
        if let book = selectedBook{
            //let book: Book = GeoDatabase.shared.bookForId(selectedBook)
            //self.title = "\(GeoDatabase.shared.bookForId(BookViewController.selectedBook).backName)"
            
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
            
            
            //self.title = ScriptureRenderer.shared.titleForBook(book, ChapterViewController.selectedChapter, false)
            
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
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
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
    
    

}


