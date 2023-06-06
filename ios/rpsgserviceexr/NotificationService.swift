//
//  NotificationService.swift
//  rpsgserviceexr
//
//  Created by Rajaram on 07/10/22.
//

import UserNotifications
import REIOSSDK

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
      self.contentHandler = contentHandler
      self.bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
      REiosHandler.presentServiceExtension(request: request) { content in
          contentHandler(content)
      }      
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
