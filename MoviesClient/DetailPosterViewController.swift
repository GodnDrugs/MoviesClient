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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        self.tableView.scrollEnabled = false
        let cell = tableView.dequeueReusableCellWithIdentifier(DetailPosterViewCell.cellReuseIdentifier()) as! DetailPosterViewCell
        cell.posterImageView.af_setImageWithURL(NSURL(string: self.posterImageURL!)!, placeholderImage: UIImage(named: "scientific15"), completion: { response -> Void in
        })

        return cell
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
