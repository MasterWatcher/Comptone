//
//  AppDelegate.swift
//  Playlist
//
//  Created by Anastasia Goncharova on 20/04/2019.
//  Copyright © 2019 Anton Goncharov. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }




}

