//
//  SearchTableViewCell.swift
//  MoviesClient
//
//  Created by Sergey Salnikov on 08.02.16.
//  Copyright © 2016 Sergey Salnikov. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var titleMovieLabel: UILabel!
    @IBOutlet weak var countryDataLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    @IBOutlet weak var imageMovie: UIImageView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var addToBookmarksButtonProperty: UIButton!
    

    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.addToBookmarksButtonProperty.setTitle("Добавить в закладки", forState: UIControlState.Normal)
        self.cardView.layer.borderWidth = 1.0
        self.cardView.layer.borderColor = UIColor.grayColor().CGColor
        
    }

    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    
    class func nibSearchCell() -> UINib
    {
        let nib = UINib(nibName: "SearchTableViewCell", bundle: nil)
        
        return nib
    }
    
    class func cellSearchReuseIdentifier() -> String
    {
        return "cellSearch"
    }
    
    @IBAction func addToBookmarksButton(sender: AnyObject)
    {
        
    }
    
}