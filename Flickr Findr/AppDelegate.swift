//
//  AppDelegate.swift
//  Flickr Findr
//
//  Created by Emmy DeLoach on 1/1/20.
//  Copyright © 2020 Emmy Rivas. All rights reserved.
//

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Properties
    
    var window: UIWindow?

    // MARK: UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        setUpLogger()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = SearchViewController()
        window?.makeKeyAndVisible()

        return true
    }
    
    // MARK: - Helpers
    
    private func setUpLogger() {
        
        DDLog.add(DDOSLogger.sharedInstance)
    }
}
