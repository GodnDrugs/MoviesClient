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
        var count = 0
//    http://www.omdbapi.com/?i=tt0102469&plot=short&r=json

        Alamofire.request(.GET, "http://www.omdbapi.com/?s=mortal", parameters: ["foo": "bar"])
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    let dictionaryJSON = JSON as! NSDictionary
                    imdbIDArray = dictionaryJSON.valueForKeyPath("Search.imdbID") as! Array<String>
                }

                for i in imdbIDArray {
                    print("http://www.omdbapi.com/?i="+i+"&plot=short&r=json")
                    print("Число итераций: \(count++)")
                    
                    Alamofire.request(.GET, "http://www.omdbapi.com/?i="+i+"&plot=short&r=json", parameters: ["foo": "bar"])
                        .responseJSON { response in
                            
                            if let JSON = response.result.value {
//                                print("JSON: \(JSON)")
                                let foundMovie = Mapper<FoundMovie>().map(JSON)
                                foundMovieArray.append(foundMovie!)
                                print(foundMovie?.title)
                            }//if end

                            

                    }//Alamofire end

                    
                    
                }//For end

                
        }

    }//function
    
}//Class
