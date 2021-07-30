//
//  AppDelegate.swift
//  FlutterHybridiOS
//
//  Created by Miaoz on 2020/7/16.
//  Copyright © 2020 ShuXun. All rights reserved.
//

import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {



   override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
          let router = PlatformRouterImp.init();
           FlutterBoostPlugin.sharedInstance().startFlutter(with: router, onStart: { (engine) in
            
           });
           
           self.window = UIWindow.init(frame: UIScreen.main.bounds)
           let viewController = ViewController.init()
           let navi = UINavigationController.init(rootViewController: viewController)
           self.window.rootViewController = navi
           self.window.makeKeyAndVisible()
           
        return true
    }

    // MARK: UISceneSession Lifecycle
//
//   override func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//   override func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }
//
//
}
//
