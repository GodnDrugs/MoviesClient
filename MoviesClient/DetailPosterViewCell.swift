//
//  DetailPosterViewCell.swift
//  MoviesClient
//
//  Created by Sergey Salnikov on 07.03.16.
//  Copyright © 2016 Sergey Salnikov. All rights reserved.
//

import UIKit

class DetailPosterViewCell: UITableViewCell, UIScrollViewDelegate {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var posterScrollView: UIScrollView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.posterScrollView.delegate = self
        self.posterScrollView.minimumZoomScale = 1.0
        self.posterScrollView.maximumZoomScale = 6.0
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
    {
        return self.posterImageView
    }
    
    class func nibCell() -> UINib
    {
        let nib = UINib(nibName: "DetailPosterViewCell", bundle: nil)
        return nib
    }
    
    class func cellReuseIdentifier() -> String
    {
        return "DetailPosterViewCell"
    }
    
}
