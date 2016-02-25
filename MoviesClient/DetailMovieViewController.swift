//
//  DetailMovieViewController.swift
//  MoviesClient
//
//  Created by Sergey Salnikov on 23.02.16.
//  Copyright © 2016 Sergey Salnikov. All rights reserved.
//

import UIKit
import Social
import MessageUI


let searchIdentifierVC = "searchVC"
let bookmarkIdentifierVC = "bookmarkVC"

class DetailMovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var checkViewController = String()
    var bookmarkMovie: BookmarkMovie?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        self.tableView.registerNib(DetailMovieCell.nibCell(), forCellReuseIdentifier: DetailMovieCell.cellReuseIdentifier())
        self.title = bookmarkMovie?.title
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(DetailMovieCell.cellReuseIdentifier()) as! DetailMovieCell
        
        if checkViewController == searchIdentifierVC {
        } else {
            cell.bookmarkImage.image = UIImage(named: "bookmarks")
        }
        
        cell.titleLabel.text = self.bookmarkMovie?.title
        var timeGenreYearCountry = self.bookmarkMovie!.runtime!+" - "+self.bookmarkMovie!.genre!
        timeGenreYearCountry += " - "+self.bookmarkMovie!.year!+" - "+self.bookmarkMovie!.country!
        cell.timeGenreYearCountryLabel.text = timeGenreYearCountry
        cell.ratingLabel.text = "Rating: "+(self.bookmarkMovie?.imdbRating)!
        cell.directorLabel.text = "Director: "+(self.bookmarkMovie?.director)!
        cell.writersLabel.text = "Writers: "+(self.bookmarkMovie?.writer)!
        cell.typeMovieLabel.text = "Type: "+(self.bookmarkMovie?.type)!
        cell.plotLabel.text = "Description: "+(self.bookmarkMovie?.plot)!
        cell.posterImage.setImageWithURL(NSURL(string: (self.bookmarkMovie?.poster)!)!)
        
        return cell
    }

    @IBAction func showActionSheet(sender: AnyObject)
    {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
        let shareToTwitter = UIAlertAction(title: "Twitter share", style: .Default) {
            (alert: UIAlertAction!) -> Void in
            let shareToTwitter : SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            self.presentViewController(shareToTwitter, animated: true, completion: nil)
        }
        
        let shareToFacebook = UIAlertAction(title: "Facebook share", style: .Default) {
            (alert: UIAlertAction!) -> Void in
            let shareToTwitter : SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            self.presentViewController(shareToTwitter, animated: true, completion: nil)
        }
        
        let emailAction = UIAlertAction(title: "Email share", style: .Default) {
            (alert: UIAlertAction!) -> Void in
            self.presentModalMailComposeViewController(true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) {
            (alert: UIAlertAction!) -> Void in
            //Code
        }
        
        optionMenu.addAction(shareToTwitter)
        optionMenu.addAction(shareToFacebook)
        optionMenu.addAction(emailAction)
        optionMenu.addAction(cancelAction)
        
        if checkViewController == searchIdentifierVC {
            optionMenu.addAction(self.addToBookmarksAlert())
        } else {
            optionMenu.addAction(self.deleteFromBookmarksAlert())
        }

        self.presentViewController(optionMenu, animated: true, completion: nil)
        
    }
    
    func presentModalMailComposeViewController(animated: Bool)
    {
        let emailTitle = "Test Email"
        let messageBody = "iOS programming is so fun!"
        let toRecipents = ["support@appcoda.com"]
        
        let mc = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        
        self.presentViewController(mc, animated: true) { () -> Void in
            
        }

    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        if error != nil {
            print("Error: \(error)")
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addToBookmarksAlert() -> UIAlertAction
    {
        let addBookmarkAction = UIAlertAction(title: "Add to Bookmarks", style: .Default) {
            (alert: UIAlertAction!) -> Void in
            print("")
            DatabaseManager.sharedInstance.addMovieToBookmarks(addToBookmarks: self.bookmarkMovie!)
        }
        
        return addBookmarkAction
    }
    
    func deleteFromBookmarksAlert() -> UIAlertAction
    {
        let removeBookmarkAction = UIAlertAction(title: "Remove from Bookmarks", style: .Default) {
            (alert: UIAlertAction!) -> Void in
            DatabaseManager.sharedInstance.deleteMoveFromBookmarks(titleMovieForRemove: (self.bookmarkMovie?.title)!)
        }
        
        return removeBookmarkAction
    }
    

}/* End Class */
