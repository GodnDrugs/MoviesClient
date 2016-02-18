//
//  MovieFactory.swift
//  MoviesClient
//
//  Created by Sergey Salnikov on 11.02.16.
//  Copyright © 2016 Sergey Salnikov. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

protocol MovieFactoryDelegate
{
    func showSearchError(movieTitle title: String)
}

class MovieFactory: NSObject {
    
    var delegate:MovieFactoryDelegate? = nil
    
    class var sharedInstance: MovieFactory {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: MovieFactory? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = MovieFactory()
        }
        
        return Static.instance!
    }
    
    func alertError(error textError: String)
    {
        let alertController = UIAlertController(title: "Ошибка ввода!", message: textError, preferredStyle: .Alert)
        let actionOk = UIAlertAction(title: "Повторить ввод", style: .Default) { (action) in }
        alertController.addAction(actionOk)
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alertController, animated: true) {}
    }

    func collectorIdFoundMovieBySearch(searchString text: String, completion: [FoundMovie] -> Void) -> Void
    {
        var imdbIDArray = Array<String>()
        var foundMovieArray = Array<FoundMovie>()
        let downloadGroup = dispatch_group_create()
        let url = "http://www.omdbapi.com/?s="+text
        Alamofire.request(.GET, url, parameters: ["foo": "bar"])
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    
                    print("\(JSON)")
                    let dictionaryJSON = JSON as! NSDictionary
                    let response = dictionaryJSON.valueForKeyPath("Response") as! String
                    
                    if (response == "False") {
                        
//                        let errorMessage = dictionaryJSON.valueForKeyPath("Error") as! String
                        self.delegate?.showSearchError(movieTitle: text)
                        
                        return
                    }
                    
                    imdbIDArray = dictionaryJSON.valueForKeyPath("Search.imdbID") as! Array<String>
                }
                for id in imdbIDArray {
                    
                    dispatch_group_enter(downloadGroup)
                    Alamofire.request(.GET, "http://www.omdbapi.com/?i="+id+"&plot=full&r=json", parameters: ["foo": "bar"])
                        .responseJSON { response in
                            
                            if let JSON = response.result.value {
                                
                                let foundMovie = Mapper<FoundMovie>().map(JSON)
                                foundMovieArray.append(foundMovie!)
                                print(foundMovie?.title)
                                
                            }
                            
                            dispatch_group_leave(downloadGroup)
                    }//End Alamofire
                    
                } // End for
                dispatch_group_notify(downloadGroup, dispatch_get_main_queue()) {
                         completion(foundMovieArray)
                }
        }//End Alamofire

    }//End Function
    
}//End Class
