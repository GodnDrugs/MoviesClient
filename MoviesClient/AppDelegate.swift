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

class AppDelegate: UIResponder, UIApplicationDelegate/*, SplashScreenViewControllerDelegate*/ {
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
        UITabBar.appearance().tintColor = UIColor.whiteColor()
//        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
    
//        let filter = string.stringByReplacingOccurrencesOfString(" ", withString: "+")
//        print(filter)
//        UINavigationBar.appearance().barTintColor = UIColor.blackColor()
//        UISearchBar.appearance().barTintColor = UIColor.whiteColor()
//        UISearchBar.appearance().placeholder = "Поиск"
//        UISearchBar.appearance().tintColor = UIColor.whiteColor()
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
//        let splashScreen = storyboard.instantiateViewControllerWithIdentifier("SplashScreen") as! SplashScreenViewController
//        splashScreen.delegate = AppDelegate()
//        self.window!.rootViewController = splashScreen
//        self.window!.makeKeyAndVisible()
        
        return true
    }
    
    
//    func condenseWhitespace(string: String) -> String {
//        let components = string.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
//        let w = components
//        return join(" ", components)
//    }

//    func splashScreenViewControllerWasFinishedLoading()
//    {
//        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let tabBarController  = storyboard.instantiateViewControllerWithIdentifier("tabBarController") as! UITabBarController
//        
////        let vc = storyboard.instantiateViewControllerWithIdentifier("SearchMovieVC") as! SearchMovieViewController
//        self.window!.rootViewController = UINavigationController(rootViewController: tabBarController)
//        self.window!.makeKeyAndVisible()
//    }

}


