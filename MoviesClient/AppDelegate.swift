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
//        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
//        addLoadingIndicator()
//        activityIndicator.startAnimating()

        
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
    
//    lazy private var activityIndicator : CustomActivityIndicatorView = {
//        let image : UIImage = UIImage(named: "loading")!
//        return CustomActivityIndicatorView(image: image)
//    }()
//    
//    func addLoadingIndicator ()
//    {
//        self.window!.addSubview(activityIndicator)
//        activityIndicator.center = self.window!.center
//    }
    
    func splashScreenViewControllerWasFinishedLoading()
    {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("SearchMovieVC") as! SearchMovieViewController
        self.window!.rootViewController = UINavigationController(rootViewController: vc)
        self.window!.makeKeyAndVisible()
    }

}

