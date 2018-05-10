//
//  FileViewController.swift
//  Diabetes
//
//  Created by Arrington, Darryn on 8/2/17.
//  Copyright © 2017 Malhotra, Neil. All rights reserved.
//

import Foundation
import UIKit
import FileBrowser

class FileViewController: UIViewController {
    
    let fileBrowser = FileBrowser()
    
  
    @IBAction func openFiledBrowser(_ sender: Any) {
        
        present(fileBrowser, animated: true, completion: nil)
        
    }
    
    
    /*  @IBAction func openFiledBrowser(_ sender: Any) {
        present(fileBrowser, animated: true, completion: nil)
    }
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
