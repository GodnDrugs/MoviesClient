//
//  BookmarkMovieViewCell.swift
//  MoviesClient
//
//  Created by Sergey Salnikov on 19.02.16.
//  Copyright © 2016 Sergey Salnikov. All rights reserved.
//

import UIKit

class BookmarkMovieViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeGenreYearCountryLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var writersLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
//    @IBOutlet weak var bookmarkImage: UIImageView!
//    @IBOutlet weak var posterImage: UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.cardView.layer.borderWidth = 1.0
        self.cardView.layer.borderColor = UIColor.grayColor().CGColor
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    class func nibBookmarkCell() -> UINib
    {
        let nib = UINib(nibName: "BookmarkMovieViewCell", bundle: nil)
        
        return nib
    }
    
    class func cellBookmarkReuseIdentifier() -> String
    {
        return "cellBookmarkMovie"
    }
    
}
