//
//  NotBookmarksViewCell.swift
//  MoviesClient
//
//  Created by Sergey Salnikov on 03.03.16.
//  Copyright © 2016 Sergey Salnikov. All rights reserved.
//

import UIKit

class NotBookmarksViewCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var notBookmarksLabel: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.cardView.layer.borderWidth = 1.0
        self.cardView.layer.borderColor = UIColor.grayColor().CGColor
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.userInteractionEnabled = false
        self.notBookmarksLabel.text = "You do not have bookmarks"
    }
    
    class func nibCell() -> UINib
    {
        let nib = UINib(nibName: "NotBookmarksViewCell", bundle: nil)
        return nib
    }
    
    class func cellReuseIdentifier() -> String
    {
        return "cellNotBookmarks"
    }
    
}
