//
//  PopSleepViewController.swift
//  Diabetes
//
//  Created by Malhotra, Neil on 7/26/17.
//  Copyright © 2017 Malhotra, Neil. All rights reserved.
//

import UIKit

class PopSleepViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func Choosedata()
    {
        theUser.sleepGoal = Double(Float(GoalsText.text!)!)
    }
    
    @IBOutlet weak var GoalsText: UITextField!

   
    @IBAction func Close(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
   
    @IBAction func Savebutton(_ sender: Any) {
    
        Choosedata()
        UserDefaults.standard.set(theUser.sleepGoal, forKey: "sleepGoal")
    }
    
    

   

}
