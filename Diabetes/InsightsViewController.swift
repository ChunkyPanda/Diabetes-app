//
//  InsightsViewController.swift
//  Diabetes
//
//  Created by Arrington, Darryn on 8/9/17.
//  Copyright © 2017 Malhotra, Neil. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireRSSParser
import FirebaseAnalytics

class InsightsViewController : UIViewController {
    
    @IBOutlet weak var rssTextView: UITextView!
    @IBOutlet weak var webView: UIWebView!
    
    @IBAction func resetInsightsButton(_ sender: Any) {
        let wvUrl = URL(string: "https://insightsondiabetes.wordpress.com")
        
        webView.loadRequest(URLRequest(url: wvUrl!))
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Analytics.logEvent("insights_opened", parameters: nil)
        
        let wvUrl = URL(string: "https://insightsondiabetes.wordpress.com")
        
        webView.loadRequest(URLRequest(url: wvUrl!))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        /*let url = "https://totallydiabetic.wordpress.com/feed/"
        
        Alamofire.request(url).responseRSS() { (response) -> Void in
            if let feed: RSSFeed = response.result.value {
                //do something with your new RSSFeed object!
                for item in feed.items {
                    self.rssTextView.text = self.rssTextView.text + item.title! + "\n"
                    //print(item)
                }
            }
        }*/
    }
}
