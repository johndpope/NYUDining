//
//  AppDelegate.swift
//  NYUDining
//
//  Created by Ross Freeman on 6/10/16.
//  Copyright © 2016 Ross Freeman. All rights reserved.
//

import Foundation
import Firebase
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func applicationDidFinishLaunching(application: UIApplication) {
        FIRApp.configure()
        
        GMSServices.provideAPIKey("AIzaSyBN_4cWF6QUZ7RvjhuocQcErs6i3QqtKtk")
    }
}