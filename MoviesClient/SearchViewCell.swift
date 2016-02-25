//
//  SearchTableViewCell.swift
//  MoviesClient
//
//  Created by Sergey Salnikov on 08.02.16.
//  Copyright © 2016 Sergey Salnikov. All rights reserved.
//

import UIKit


class SearchViewCell: UITableViewCell {

    @IBOutlet weak var titleMovieLabel: UILabel!
    @IBOutlet weak var countryDataLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    @IBOutlet weak var imageMovie: UIImageView!
    @IBOutlet weak var cardView: UIView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.cardView.layer.borderWidth = 1.0
        self.cardView.layer.borderColor = UIColor.grayColor().CGColor
    }
        
    class func nibSearchCell() -> UINib
    {
        let nib = UINib(nibName: "SearchViewCell", bundle: nil)
        return nib
    }
    
    class func cellSearchReuseIdentifier() -> String
    {
        return "cellSearch"
    }
    
}
