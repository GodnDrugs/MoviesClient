//
//  Extensions.swift
//  MoviesClient
//
//  Created by Sergey Salnikov on 05.03.16.
//  Copyright © 2016 Sergey Salnikov. All rights reserved.
//

import Foundation
import UIKit


extension UITableViewCell {
    func fixConstraints() -> UITableViewCell
    {
        if (UIDevice.currentDevice().systemVersion < "9.0") {
            self.updateConstraintsIfNeeded()
        }
        
        return self
    }
}