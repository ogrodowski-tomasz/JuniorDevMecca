//
//  SkeletonLoadable.swift
//  PublicApis
//
//  Created by Tomasz Ogrodowski on 16/12/2022.
//

import Foundation
import UIKit

protocol SkeletonLoadable { }

extension SkeletonLoadable {
    func makeAnimationGroup(previousGroup: CAAnimationGroup? = nil) -> CAAnimationGroup {
        let animDuration: CFTimeInterval = 0.2
        let anim1 = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.backgroundColor))
        anim1.fromValue = UIColor.skeletonLightGray.cgColor
        anim1.toValue = UIColor.skeletonDarkGray.cgColor
        anim1.duration = animDuration
        anim1.beginTime = 0.0
        
        let anim2 = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.backgroundColor))
        anim2.fromValue = UIColor.skeletonDarkGray.cgColor
        anim2.toValue = UIColor.skeletonLightGray.cgColor
        anim2.duration = animDuration
        anim2.beginTime = anim1.beginTime + animDuration
        
        let group = CAAnimationGroup()
        group.animations = [anim1, anim2]
        group.repeatCount = .greatestFiniteMagnitude // to make this animation infinite
        group.duration = anim2.beginTime + anim2.duration // anim1.beginTime + anim1.duration + anim2.duration
        group.isRemovedOnCompletion = false
        
        if let previousGroup {
            // Offset groups by 0.33 seconds for effect
            group.beginTime = previousGroup.beginTime + 0.33
        }
        return group
    }
}

extension UIColor {
    
    static var skeletonLightGray: UIColor {
        return UIColor(red: 239/255, green: 241/255, blue: 241/255, alpha: 1)
    }
    
    static var skeletonDarkGray: UIColor {
        return UIColor(red: 201/255, green: 201/255, blue: 201/255, alpha: 1)
    }
    
}
