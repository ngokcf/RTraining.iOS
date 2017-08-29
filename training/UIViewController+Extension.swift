//
//  UIViewController+Extension.swift
//  training
//
//  Created by shota.nagao on 2017/08/25.
//  Copyright © 2017年 training. All rights reserved.
//

import UIKit

public extension UIViewController {
    
    static func make() -> Self {
        let name: String = "\(type(of: self))".components(separatedBy: ".").first!
        return instantiate(storyboardName: name)
    }
    
    private static func instantiate<T>(storyboardName: String) -> T {
        let storyboard: UIStoryboard = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = storyboard.instantiateInitialViewController() ?? storyboard.instantiateViewController(withIdentifier: storyboardName)
        return vc as! T
    }
    
}
