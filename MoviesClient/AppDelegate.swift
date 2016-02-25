//
//  AppDelegate.swift
//  MoviesClient
//
//  Created by Sergey Salnikov on 05.02.16.
//  Copyright © 2016 Sergey Salnikov. All rights reserved.
//

import UIKit
import Alamofire


@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, SplashScreenViewControllerDelegate {
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        UINavigationBar.appearance().barTintColor = UIColor.greenColor()
        UISearchBar.appearance().barTintColor = UIColor.greenColor()
        UISearchBar.appearance().placeholder = "Поиск"
        UISearchBar.appearance().tintColor = UIColor.whiteColor()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let splashScreen = storyboard.instantiateViewControllerWithIdentifier("SplashScreen") as! SplashScreenViewController
        splashScreen.delegate = AppDelegate()
        self.window!.rootViewController = splashScreen
        self.window!.makeKeyAndVisible()
        return true
    }

    func splashScreenViewControllerWasFinishedLoading()
    {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController  = storyboard.instantiateViewControllerWithIdentifier("tabBarController") as! UITabBarController
        
//        let vc = storyboard.instantiateViewControllerWithIdentifier("SearchMovieVC") as! SearchMovieViewController
        self.window!.rootViewController = UINavigationController(rootViewController: tabBarController)
        self.window!.makeKeyAndVisible()
    }

}

