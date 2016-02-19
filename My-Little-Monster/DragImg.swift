//
//  DragImg.swift
//  My-Little-Monster
//
//  Created by Brian Lim on 12/9/15.
//  Copyright © 2015 codebluapps. All rights reserved.
//

import Foundation
import UIKit

class DragImg: UIImageView {
    
    var originialPosition: CGPoint!
    var dropTarget: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Setting the var called originalPosition to the value of the centers of the current image
        originialPosition = self.center
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Checking to see if there is one touch out of the set of touches
        if let touch = touches.first {
            // If there is a touch, then get that touches location in the superview and store that value into the constant
            let position = touch.locationInView(self.superview)
            // Set the center of the current image to the constant called position (X an Y coordinates)
            self.center = CGPointMake(position.x, position.y)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Checking to see if there is one touch out of the set of touches and if there has been a drop target set
        if let touch = touches.first, let target = dropTarget {
            // If there is a touch, then get that touches location in the superview and store that value into the constant
            let position = touch.locationInView(self.superview)
            // Checking to see if the image is in the frame of the dropTarget
            if CGRectContainsPoint(target.frame, position) {
                // If so, then send out a message or a notification throughout the app's code
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "onTargetDropped", object: nil))
            }
        }
        // Then set the center of the current image to the originalPosition, which is the initial start point
        self.center = originialPosition
    }
}
