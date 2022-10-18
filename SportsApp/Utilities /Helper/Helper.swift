//
//  Helper.swift
//  DrApp
//
//  Created by Abdallah Eslah on 18/08/2022.
//

import Foundation
import UIKit
import SwiftMessages
import ProgressHUD

class Helper {
    
    static func displayMessage(message: String, messageError: Bool) {
        DispatchQueue.main.async {
            
           let view = MessageView.viewFromNib(layout: MessageView.Layout.messageView)
           if messageError == true {
               view.configureTheme(.error)
           } else {
               view.configureTheme(.success)
           }
           
           view.iconImageView?.isHidden = true
           view.iconLabel?.isHidden = true
           view.titleLabel?.isHidden = true
           view.bodyLabel?.text = message
           view.titleLabel?.textColor = UIColor.white
           view.bodyLabel?.textColor = UIColor.white
           view.button?.isHidden = true
           
           var config = SwiftMessages.Config()
           config.presentationStyle = .bottom
           SwiftMessages.show(config: config, view: view)
       }
    }
    
    static func hudProgress() {
        ProgressHUD.show("Loading...")
        ProgressHUD.animationType   = .circleSpinFade
        ProgressHUD.colorAnimation  = UIColor.purple
        ProgressHUD.colorHUD        = .label
    }
    
    static func dismissHud() {
        ProgressHUD.dismiss()
    }
    
    
}
    
    extension UIViewController {
        
         func pushVC(storyboardName:String,vcIdentifier:String) {
            
            let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: vcIdentifier)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        func presentVC(storyboardName:String,VCidentifier:String) {
            let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
            let vc         = storyboard.instantiateViewController(withIdentifier: VCidentifier)
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
    



