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

    var selectedChapter: Int? = nil
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


