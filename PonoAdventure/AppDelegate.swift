//
//  AppDelegate.swift
//  PonoAdventure
//
//  Created by Ria and Dev on 23/09/16.
//  Copyright © 2016 Agileinf. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import Alamofire
import UserNotifications
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    var window: UIWindow?
    let locationManager = CLLocationManager()
    var _currentLocation:CLLocation?
    let web = Web()
    var isFirstLocation:Bool = true
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().barTintColor = UIColor(red: 0.0/255.0, green: 198.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        UIApplication.shared.statusBarStyle = .lightContent
        PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: "YOUR_CLIENT_ID_FOR_PRODUCTION",
                                                              PayPalEnvironmentSandbox: "ARKEBeYESAbgFRheBDU2fh532e_elQbGWSUSSRKQDm96Zq8dq2jHRWW4XfCWddcOg8gCrnifRfdo_Xht"])
        registerForPushNotifications(application: application)
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                // Enable or disable features based on authorization.
            }
        } else {
            // Fallback on earlier versions
        }
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let id = UserDefaults.standard.string(forKey: "userId")
        if id != nil {
            let storyboard = UIStoryboard(name: "TabPane", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "TabPane") as! UITabBarController
            initialViewController.selectedIndex = 0
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        } else {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "Login") as! UINavigationController
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = 1
        locationManager.distanceFilter = 10
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.activityType = CLActivityType.automotiveNavigation
        locationManager.allowsBackgroundLocationUpdates = true
        if UserDefaults.standard.string(forKey: "tracking") == nil {
            UserDefaults.standard.set(true, forKey: "tracking")
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        if UserDefaults.standard.bool(forKey: "tracking") {
            locationManager.startUpdatingLocation()
        }
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        locationManager.stopUpdatingLocation()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }


    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        if #available(iOS 10.0, *) {
            self.saveContext()
        } else {
            // Fallback on earlier versions
        }
    }
    func registerForPushNotifications(application: UIApplication) {
        let notificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .none {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        UserDefaults.standard.set(deviceTokenString, forKey: "deviceID")
        print(deviceTokenString)
        
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("i am not available in simulator \(error)")
        
    }

    // MARK: - Core Data stack

    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "PonoAdventure")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    @available(iOS 10.0, *)
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if(_currentLocation == nil){
            _currentLocation = locations.first!
        }
        let distance = _currentLocation?.distance(from: locations.first!)
        print(distance!)
        if distance! > 10 {
        
            let id = UserDefaults.standard.string(forKey: "userId")
            if id != nil {
                web.notification(completion: { (response) in
                    print(response ?? "")
                }, params: ["_id":id!,"location":["lat":locations.first!.coordinate.latitude, "lon":locations.first!.coordinate.longitude]])
            }
        
        
            //print(String(describing: locations.last?.coordinate.latitude))
            /*if #available(iOS 10.0, *) {
                let requestIdentifier = "SampleRequest"
                let content = UNMutableNotificationContent()
                content.title = "Locatoin monitored"
                content.subtitle = "Location changed"
                content.body = "(" + String(describing: locations.last!.coordinate.latitude) + "," + String(describing: locations.last!.coordinate.longitude) + ")"
                content.sound = UNNotificationSound.default()
                let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1.0, repeats: false)
                let request = UNNotificationRequest(identifier:requestIdentifier, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request){(error) in
                    
                    if (error != nil){
                        
                        print(error ?? "")
                    }
                }
            } else {
                // Fallback on earlier versions
            }*/
        }
        
        
    }

}

