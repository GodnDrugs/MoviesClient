//
//  DetailMovieCell.swift
//  MoviesClient
//
//  Created by Sergey Salnikov on 23.02.16.
//  Copyright © 2016 Sergey Salnikov. All rights reserved.
//

import UIKit

class DetailMovieCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeGenreYearCountryLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var writersLabel: UILabel!
    @IBOutlet weak var typeMovieLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var bookmarkImage: UIImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var headerContainerView: UIView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        
        self.cardView.layer.borderWidth = 2.0
        self.cardView.layer.borderColor = UIColor.grayColor().CGColor
        self.headerContainerView.autoresizingMask = .FlexibleHeight
        self.headerContainerView.sizeToFit()
        self.titleLabel.sizeToFit()
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func nibCell() -> UINib
    {
        let nib = UINib(nibName: "DetailMovieCell", bundle: nil)
        return nib
    }
    
    class func cellReuseIdentifier() -> String
    {
        return "cellDetailMovie"
    }
    
}
