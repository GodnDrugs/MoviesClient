//
//  DetailPosterViewController.swift
//  MoviesClient
//
//  Created by Sergey Salnikov on 06.03.16.
//  Copyright © 2016 Sergey Salnikov. All rights reserved.
//

import UIKit

class DetailPosterViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var posterScrollView: UIScrollView!
    @IBOutlet weak var posterImageView: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.posterScrollView.delegate = self
        self.posterScrollView.minimumZoomScale = 1.0
        self.posterScrollView.maximumZoomScale = 6.0
        
        self.posterImageView.backgroundColor = UIColor.brownColor()
        
    }

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView?
    {
        return self.posterImageView
    }
    
    @IBAction func previousScreen(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
