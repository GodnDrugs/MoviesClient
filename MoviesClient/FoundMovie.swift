//
//  FoundMovie.swift
//  MoviesClient
//
//  Created by Sergey Salnikov on 09.02.16.
//  Copyright © 2016 Sergey Salnikov. All rights reserved.
//

import UIKit
import ObjectMapper


class FoundMovie: Mappable {
    
    var title: String!
    var year: String!
    var country: String!
    var poster: String!
    var plot: String?
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        
        title <- map["Title"]
        year <- map["Year"]
        country <- map["Country"]
        poster <- map["Poster"]
        plot <- map["Plot"]
        
    }
}
