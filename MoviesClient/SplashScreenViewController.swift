//
//  SplashScreenViewController.swift
//  MoviesClient
//
//  Created by Sergey Salnikov on 08.02.16.
//  Copyright © 2016 Sergey Salnikov. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper


protocol SplashScreenViewControllerDelegate {
    func splashScreenViewControllerWasFinishedLoading()
}

class SplashScreenViewController: UIViewController {
    
    var delegate:SplashScreenViewControllerDelegate?

    @IBOutlet weak var splashImage: UIImageView!

    
    lazy private var activityIndicator : CustomActivityIndicatorView = {
        let image : UIImage = UIImage(named: "loading")!
        return CustomActivityIndicatorView(image: image)
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.splashImage.image = UIImage(named: "scientific15")
        
        addLoadingIndicator()
        activityIndicator.startAnimating()
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            self.delegate?.splashScreenViewControllerWasFinishedLoading()
        }

    }
    
    func createTop10Movie(movieID id: String) -> [FoundMovie]
    {
        let top10MovieIDArray = ["tt0111161", "tt0068646", "tt0071562", "tt0110912", "tt0060196", "tt0468569", "tt0050083", "tt0108052", "tt0167260", "tt0137523"]
        var createdTopMoviesArray = Array<FoundMovie>()
        
        for movieID in top10MovieIDArray {
            Alamofire.request(.GET, self.concatUrl(insertID: movieID), parameters: ["foo": "bar"])
                .responseJSON { response in
                    
                    if let JSON = response.result.value {
                        
                        let topMovie = Mapper<FoundMovie>().map(JSON)
                        createdTopMoviesArray.append(topMovie!)
                        print(topMovie?.title)
                        
                    }
            }
            
        } /*End For*/
        
        return createdTopMoviesArray
    }
    
    func concatUrl(insertID id: String) -> String
    {
        let URLPartOne = "http://www.omdbapi.com/?i="
        let URLPartTwo = "&plot=full&r=json"
        let resultURL = URLPartOne+id+URLPartTwo
        
        return resultURL
    }
    
    func addLoadingIndicator ()
    {
        self.view.addSubview(activityIndicator)
        activityIndicator.center = self.view.center
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
