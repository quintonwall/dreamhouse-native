//
//  Broker.swift
//  DHNative
//
//  Created by QUINTON WALL on 7/31/16.
//  Copyright © 2016 Quinton Wall. All rights reserved.
//

import UIKit

struct Broker {
    var id: String
    var name: String
    var photoURL: String
    var jobTitle: String
    var phoneOffice: String
    var phoneCell: String
    var email: String
    
    
    
}

extension Broker : CardPresentable {
    
    var imageURLString: String {
        return photoURL
    }
    
    var placeholderImage: UIImage? {
        return UIImage(named: "default")
    }
    
    var titleText: String {
        return name
    }
    
    var brokerId : String {
        return id
    }
    
    // This is used to tell the dial at the bottom of the UI which letter to point tofor this card
    var dialLabel: String {
        guard let lastString = titleText.componentsSeparatedByString(" ").last else { return "" }
        return String(lastString[lastString.startIndex])
    }
    
    var detailTextLineOne: String {
        return jobTitle
    }
    
    var detailTextLineTwo: String {
        return ""
    }
    
    var actionOne: CardAction? {
        return CardAction(title: "Call")
    }
    
    var actionTwo: CardAction? {
        return CardAction(title: "Email")
    }
    
}
