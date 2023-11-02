//
//  UIView+extensions.swift
//  upwards-ios-challenge
//
//  Created by Ryan Helgeson on 11/2/23.
//

import UIKit

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
