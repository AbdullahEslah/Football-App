//
//  AnimationScreen.swift
//  DrApp
//
//  Created by Abdallah Eslah on 19/08/2022.
//

import Lottie
import UIKit
import Foundation

class AppAnimation {
    
    static var splashScreen = AnimationView(animation: Animation.named("splashScreen"))
    
    static func playAnimation(onView:UIView) {
        
        splashScreen.frame = onView.bounds
        //  Add animationView as subview
        onView.addSubview(splashScreen)
        //  Play the animation
        splashScreen.play()
        splashScreen.loopMode = .loop
        splashScreen.animationSpeed = 1
    }
    
    static func dismissAnimation() {
        
        splashScreen.stop()
        splashScreen.alpha = 0
    }
    
  
}

