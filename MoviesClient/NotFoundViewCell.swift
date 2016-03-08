//
//  NotFoundViewCell.swift
//  MoviesClient
//
//  Created by Sergey Salnikov on 28.02.16.
//  Copyright © 2016 Sergey Salnikov. All rights reserved.
//

import UIKit

class NotFoundViewCell: UITableViewCell {

    @IBOutlet weak var notFoundLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()

        self.cardView.layer.borderWidth = 1.0
        self.cardView.layer.borderColor = UIColor.grayColor().CGColor
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.userInteractionEnabled = false
    }
    
    class func nibCell() -> UINib
    {
        let nib = UINib(nibName: "NotFoundViewCell", bundle: nil)
        return nib
    }
    
    class func cellReuseIdentifier() -> String
    {
        return "cellNotFoundMovie"
    }

}
