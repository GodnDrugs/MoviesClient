//
//  FactoryFoundMovie.swift
//  MoviesClient
//
//  Created by Sergey Salnikov on 11.02.16.
//  Copyright © 2016 Sergey Salnikov. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper


class FactoryFoundMovie: NSObject {
    
    class var sharedInstance: FactoryFoundMovie {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: FactoryFoundMovie? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = FactoryFoundMovie()
        }
        
        return Static.instance!
    }
    
    func collectorIdFoundMovieBySearch(completion:[FoundMovie] -> Void) -> Void
    {
        var imdbIDArray = Array<String>()
        var foundMovieArray: [FoundMovie] = []
        let downloadGroup = dispatch_group_create()
        
        Alamofire.request(.GET, "http://www.omdbapi.com/?s=mortal", parameters: ["foo": "bar"])
            .responseJSON { response in
                if let JSON = response.result.value {
                    let dictionaryJSON = JSON as! NSDictionary
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

    }//function
    
}//Class
