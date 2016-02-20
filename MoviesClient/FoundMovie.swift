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
    
    var id: String?
    var title: String!
    var year: String!
    var country: String!
    var poster: String!
    var plot: String?
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        
        self.id <- map["imdbID"]
        self.title <- map["Title"]
        self.year <- map["Year"]
        self.country <- map["Country"]
        self.poster <- map["Poster"]
        self.plot <- map["Plot"]
        
    }
}
