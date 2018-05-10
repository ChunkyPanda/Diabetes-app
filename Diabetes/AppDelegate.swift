//
//  AppDelegate.swift
//  Diabetes
//
//  Created by Malhotra, Neil on 7/19/17.
//  Copyright © 2017 Malhotra, Neil. All rights reserved.
//

import UIKit
import Parse
import IQKeyboardManagerSwift
//import UserNotifications
import Firebase
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Initialize Parse.
        
        let configuration = ParseClientConfiguration {
            $0.applicationId = "lkpSHHcMUM5GH52tz1djFlbCE3cWi5FCjWjIncWC"
            $0.clientKey = "TgonK02GFWWIvoBbu1AoI9Y3uQJ3dPWfNnkeEPaZ"
            $0.server = "https://parseapi.back4app.com"
        }
        Parse.initialize(with: configuration)
        IQKeyboardManager.sharedManager().enable = true
        FirebaseApp.configure()
        Fabric.with([Crashlytics.self])
        if #available(iOS 10.0, *) {
            /*let center = UNUserNotificationCenter.current()
            center.delegate = self as? UNUserNotificationCenterDelegate 
            center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            }*/
        }
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateOnReturn = formatter.string(from: date)
        print("Date On Return = " + dateOnReturn)
        
        //Compare the two dates
        if let dateOnExit = UserDefaults.standard.object(forKey: "dateOnExit") as? String
        {
            if dateOnExit == dateOnReturn
            {
                print("DON'T RESET DATA")
            }
            else
            {
                let userDefault = UserDefaults.standard
                
                breakfastList.removeAll()
                lunchList.removeAll()
                dinnerList.removeAll()
                snacksList.removeAll()
                
                var encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: breakfastList)
                userDefault.set(encodedData, forKey: "breakfastList")
                userDefault.synchronize()
                
                encodedData = NSKeyedArchiver.archivedData(withRootObject: breakfastList)
                userDefault.set(encodedData, forKey: "lunchList")
                userDefault.synchronize()
                
                encodedData = NSKeyedArchiver.archivedData(withRootObject: breakfastList)
                userDefault.set(encodedData, forKey: "dinnerList")
                userDefault.synchronize()
                
                encodedData = NSKeyedArchiver.archivedData(withRootObject: breakfastList)
                userDefault.set(encodedData, forKey: "snacksList")
                userDefault.synchronize()
                
                
                listActivity.removeAll()
                encodedData = NSKeyedArchiver.archivedData(withRootObject: listActivity)
                userDefault.set(encodedData, forKey: "activityList")
                userDefault.synchronize()
                
                addToCaloriesBurned = 0.0
                UserDefaults.standard.set(addToCaloriesBurned, forKey: "addToCaloriesBurned")
                
                carbsGlobal = 0.0
                addToCarbs = 0.0
                sugarGlobal = 0.0
                fatGlobal = 0.0
                caloriesGlobal = 0.0
                
                UserDefaults.standard.set(highGlucose, forKey: "addToCarbs")
                
                totalCarbs = 0
                totalFat = 0
                totalSugar = 0
                totalCal = 0
                
                readingsNum = 0
                glucoseGlobal = 0.0
                avgGlucose = 0
                highGlucose = 0
                lowGlucose = 0
                
                UserDefaults.standard.set(readingsNum, forKey: "glucoseReadingNumber")
                UserDefaults.standard.set(lowGlucose, forKey: "glucoseLowReading")
                UserDefaults.standard.set(avgGlucose, forKey: "glucoseAvgReading")
                UserDefaults.standard.set(highGlucose, forKey: "glucoseHighReading")
                UserDefaults.standard.set(glucoseGlobal, forKey: "glucoseGlobal")
                
                
                list1.removeAll()
                list1 = ["Breakfast", "Lunch", "Dinner", "Snack(s)"]
                UserDefaults.standard.set("Breakfast", forKey: "breakfastListDisplay")
                UserDefaults.standard.set("Lunch", forKey: "lunchListDisplay")
                UserDefaults.standard.set("Dinner", forKey: "dinnerListDisplay")
                UserDefaults.standard.set("Snack(s)", forKey: "snacksListDisplay")
                
                UserDefaults.standard.set(totalCal, forKey: "nutritionTotalCal")
                UserDefaults.standard.set(totalCarbs, forKey: "nutritionTotalCarbs")
                UserDefaults.standard.set(totalSugar, forKey: "nutritionTotalSugar")
                UserDefaults.standard.set(totalFat, forKey: "nutritionTotalFat")
                
                UserDefaults.standard.set(dateOnReturn, forKey: "dateOnExit")
                Analytics.logEvent("data_auto_reset", parameters: nil)
            }
        }
        
        
        return true
        
        
       
        }
        
        
        
       /* @available(iOS 10.0, *)
        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {                     completionHandler(.alert)
        }*/
 
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        //Store the date that the user exited the app on
        let date = Date()
        //let formatter = DateFormatter()
        //formatter.dateFormat = "MM/dd/yyyy"
        //let dateOnExit = formatter.string(from: date)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateOnExit = formatter.string(from: date)
        print(dateOnExit)
        UserDefaults.standard.set(dateOnExit, forKey: "dateOnExit")
        print("Date On Exit = " + dateOnExit)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        //Obtain the date that the user reopened the app on
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateOnReturn = formatter.string(from: date)
        print("Date On Return = " + dateOnReturn)
        
        //Compare the two dates
        if let dateOnExit = UserDefaults.standard.object(forKey: "dateOnExit") as? String
        {
            if dateOnExit == dateOnReturn
            {
                print("DON'T RESET DATA")
            }
            else
            {
                let userDefault = UserDefaults.standard
                
                breakfastList.removeAll()
                lunchList.removeAll()
                dinnerList.removeAll()
                snacksList.removeAll()
                
                var encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: breakfastList)
                userDefault.set(encodedData, forKey: "breakfastList")
                userDefault.synchronize()
                
                encodedData = NSKeyedArchiver.archivedData(withRootObject: breakfastList)
                userDefault.set(encodedData, forKey: "lunchList")
                userDefault.synchronize()
                
                encodedData = NSKeyedArchiver.archivedData(withRootObject: breakfastList)
                userDefault.set(encodedData, forKey: "dinnerList")
                userDefault.synchronize()
                
                encodedData = NSKeyedArchiver.archivedData(withRootObject: breakfastList)
                userDefault.set(encodedData, forKey: "snacksList")
                userDefault.synchronize()
                
                
                listActivity.removeAll()
                encodedData = NSKeyedArchiver.archivedData(withRootObject: listActivity)
                userDefault.set(encodedData, forKey: "activityList")
                userDefault.synchronize()
                
                addToCaloriesBurned = 0.0
                UserDefaults.standard.set(addToCaloriesBurned, forKey: "addToCaloriesBurned")
                
                carbsGlobal = 0.0
                addToCarbs = 0.0
                sugarGlobal = 0.0
                fatGlobal = 0.0
                caloriesGlobal = 0.0
                
                UserDefaults.standard.set(highGlucose, forKey: "addToCarbs")
                
                totalCarbs = 0
                totalFat = 0
                totalSugar = 0
                totalCal = 0
                
                readingsNum = 0
                glucoseGlobal = 0.0
                avgGlucose = 0
                highGlucose = 0
                lowGlucose = 0
                
                UserDefaults.standard.set(readingsNum, forKey: "glucoseReadingNumber")
                UserDefaults.standard.set(lowGlucose, forKey: "glucoseLowReading")
                UserDefaults.standard.set(avgGlucose, forKey: "glucoseAvgReading")
                UserDefaults.standard.set(highGlucose, forKey: "glucoseHighReading")
                UserDefaults.standard.set(glucoseGlobal, forKey: "glucoseGlobal")
                
                
                list1.removeAll()
                list1 = ["Breakfast", "Lunch", "Dinner", "Snack(s)"]
                UserDefaults.standard.set("Breakfast", forKey: "breakfastListDisplay")
                UserDefaults.standard.set("Lunch", forKey: "lunchListDisplay")
                UserDefaults.standard.set("Dinner", forKey: "dinnerListDisplay")
                UserDefaults.standard.set("Snack(s)", forKey: "snacksListDisplay")
                
                UserDefaults.standard.set(totalCal, forKey: "nutritionTotalCal")
                UserDefaults.standard.set(totalCarbs, forKey: "nutritionTotalCarbs")
                UserDefaults.standard.set(totalSugar, forKey: "nutritionTotalSugar")
                UserDefaults.standard.set(totalFat, forKey: "nutritionTotalFat")
                
                UserDefaults.standard.set(dateOnReturn, forKey: "dateOnExit")
                Analytics.logEvent("data_auto_reset", parameters: nil)
            }
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        //Store the date that the user exited the app on
        let date = Date()
        //let formatter = DateFormatter()
        //formatter.dateFormat = "MM/dd/yyyy"
        //let dateOnExit = formatter.string(from: date)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateOnExit = formatter.string(from: date)
        print(dateOnExit)
        UserDefaults.standard.set(dateOnExit, forKey: "dateOnExit")
        print("Date On Exit = " + dateOnExit)
        
    }
    
    
}

