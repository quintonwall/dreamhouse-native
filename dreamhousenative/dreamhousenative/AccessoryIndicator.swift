/*
* AccessoryIndicator
*
* Created by Jeremy Fox on 3/1/16.
* Copyright (c) 2016 Jeremy Fox. All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*/

import UIKit

class AccessoryIndicator: UIControl {
    
    var accessoryColor: UIColor?
    var highlightColor: UIColor?
    private var facing: Direction?

    enum Direction {
        case Left, Right //, Up, Down
    }

    override var highlighted: Bool {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clearColor()
    }
    
    class func withColor(color: UIColor, facing: Direction, size: CGSize) -> AccessoryIndicator {
        let acc = AccessoryIndicator(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        acc.facing = facing
        acc.accessoryColor = color
        return acc
    }
    
    override func drawRect(rect: CGRect) {
        let y = CGRectGetMidY(bounds)
        let R = CGRectGetHeight(rect)
        let ctxt = UIGraphicsGetCurrentContext()
        if let _facing = facing {
            switch _facing {
            case .Left:
                let x = CGRectGetMinX(bounds)
                CGContextMoveToPoint(ctxt, x+R, y+R)
                CGContextAddLineToPoint(ctxt, x+(R/2), y)
                CGContextAddLineToPoint(ctxt, x+R, y-R)
            case .Right:
                let x = CGRectGetMaxX(bounds)
                CGContextMoveToPoint(ctxt, x-R, y-R)
                CGContextAddLineToPoint(ctxt, x-(R/2), y)
                CGContextAddLineToPoint(ctxt, x-R, y+R)
            }
        } else {
            let x = CGRectGetMaxX(bounds)
            CGContextMoveToPoint(ctxt, x+R, y+R)
            CGContextAddLineToPoint(ctxt, x+(R/2), y)
            CGContextAddLineToPoint(ctxt, x+R, y-R)
        }
        
        CGContextSetLineCap(ctxt, .Square)
        CGContextSetLineJoin(ctxt, .Miter)
        CGContextSetLineWidth(ctxt, 1)
        if highlighted {
            currentHighlightColor().setStroke()
        } else {
            currentAccessoryColor().setStroke()
        }
        CGContextStrokePath(ctxt)
    }
    
    private func currentAccessoryColor() -> UIColor {
        var color = UIColor.blackColor()
        if let _accessoryColor = accessoryColor {
            color = _accessoryColor
        }
        return color
    }
    
    private func currentHighlightColor() -> UIColor {
        var color = UIColor.whiteColor()
        if let _highlightColor = highlightColor {
            color = _highlightColor
        }
        return color
    }
    
    override func intrinsicContentSize() -> CGSize {
        return frame.size
    }
    
    override func alignmentRectInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

}

