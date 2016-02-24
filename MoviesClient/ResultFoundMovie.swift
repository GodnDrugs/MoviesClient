//
//  ResultFoundMovie.swift
//  MoviesClient
//
//  Created by Sergey Salnikov on 23.02.16.
//  Copyright © 2016 Sergey Salnikov. All rights reserved.
//

import UIKit
import FMDB

class ResultFoundMovie: NSObject {
    
    var title: String?
    var year: String?
    var country: String?
    var poster: String?
    var plot: String?
    
}

extension ResultFoundMovie {
    
    class func resultFoundMovieWithResultSet(resultSet: FMResultSet) -> ResultFoundMovie
    {
        let resultFoundMovie = ResultFoundMovie()
        
        resultFoundMovie.title = resultSet.stringForColumn("title")
        resultFoundMovie.year = resultSet.stringForColumn("year")
        resultFoundMovie.country = resultSet.stringForColumn("country")
        resultFoundMovie.poster = resultSet.stringForColumn("poster")
        resultFoundMovie.plot = resultSet.stringForColumn("plot")

        return resultFoundMovie
    }
}
