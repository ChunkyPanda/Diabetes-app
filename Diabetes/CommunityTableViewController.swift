//
//  CommunityTableViewController.swift
//
//
//  Created by Malhotra, Neil on 10/2/17.
//
//

import UIKit
import Foundation
import UIKit
import Alamofire
import AlamofireRSSParser

class CommunityTableViewController: UITableViewController {
    
    
    
    
    
    @IBOutlet weak var mywebView: UIWebView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let wvUrl = URL(string: "https://community.wealthmeethealth.com")
        
        mywebView.loadRequest(URLRequest(url: wvUrl!))
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








/*
 override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
 
 // Configure the cell...
 
 return cell
 }
 */

/*
 // Override to support conditional editing of the table view.
 override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the specified item to be editable.
 return true
 }
 */

/*
 // Override to support editing the table view.
 override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
 if editingStyle == .delete {
 // Delete the row from the data source
 tableView.deleteRows(at: [indexPath], with: .fade)
 } else if editingStyle == .insert {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
 
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
 // Return false if you do not want the item to be re-orderable.
 return true
 }
 */

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */


