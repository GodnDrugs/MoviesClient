//
//  DetailPosterViewController.swift
//  MoviesClient
//
//  Created by Sergey Salnikov on 06.03.16.
//  Copyright © 2016 Sergey Salnikov. All rights reserved.
//

import UIKit

class DetailPosterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var posterImageURL: String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableView.scrollEnabled = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(DetailPosterViewCell.nibCell(), forCellReuseIdentifier: DetailPosterViewCell.cellReuseIdentifier())
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return self.tableView.frame.size.height
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
//    (399.0, 280.0) Optional((150.0, 222.5)) Optional(2.0) - url
//    (399.0, 280.0) Optional((300.0, 450.0)) Optional(1.0) - assets


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(DetailPosterViewCell.cellReuseIdentifier()) as! DetailPosterViewCell
        cell.posterImageView.af_setImageWithURL(NSURL(string: self.posterImageURL!)!, placeholderImage: UIImage(named: "scientific15"), completion: { response -> Void in
            cell.posterImageView.contentMode = UIViewContentMode.Center
        })
        cell.posterImageView.image = scaleImage(cell.posterImageView.image!, newSize: CGSizeMake(300, 450))
        print(cell.posterImageView.frame.size, cell.posterImageView.image?.size, cell.posterImageView.image?.scale)
        
        return cell
    }
    
    func scaleImage(image: UIImage, newSize: CGSize) -> UIImage
    {
        UIGraphicsBeginImageContext(newSize)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    @IBAction func previousScreen(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true) { () -> Void in
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent
    }

}
