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
    @IBOutlet weak var bookmarkImageView: UIImageView!
    
    var isBookmarked: Bool = false
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.cardView.layer.borderWidth = 1.0
        self.cardView.layer.borderColor = UIColor.grayColor().CGColor
        self.cardView.layer.cornerRadius = 2.0
    }
    
    class func nibCell() -> UINib
    {
        let nib = UINib(nibName: "SearchViewCell", bundle: nil)
        return nib
    }
    
    class func cellReuseIdentifier() -> String
    {
        return "cellSearch"
    }
    
}
