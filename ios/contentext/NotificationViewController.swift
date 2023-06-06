//
//  NotificationViewController.swift
//  visionbankcontentExt
//
//  Created by Rajaram on 18/05/21.
//  Copyright © 2021 Interakt. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import REIOSSDK

class NotificationViewController: UIViewController, UNNotificationContentExtension, REiosContentExtensionReceiver {
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // REiosHandler.env = .run
        REiosHandler.contentExtDelegate = self
    }
    
    func didReceive(_ notification: UNNotification) {
        
        let dynamicLink = [ "applinks": "visionbanknative1.page.link", "storeId": "1289654399", "appBundleId": "com.resulticks.visionbankrn" ]
        REiosHandler.presnetContentExtension(vc: self, notification: notification, deeplinkData: dynamicLink) { height in
        }
    }
    
    func didCloseContentExtention() {
        if #available(iOSApplicationExtension 12.0, *) {
            self.extensionContext?.dismissNotificationContentExtension()
        } else {
            // Fallback on earlier versions
        }
    }
    
    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        
    }
}

