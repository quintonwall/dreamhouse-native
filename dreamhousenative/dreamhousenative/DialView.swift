/*
* DialView
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


//  NOTE:
//  This was adapted from the gist here: https://gist.github.com/sketchytech/d0a8909459aea899e67c
//  That gist gave me a great starting point for learning how to determine the CGPoints around a circle and being able to draw lines and labels in or around the circle in equal distances

import UIKit

class DialView: UIView {

    let pointerLayer = PointerLayer()
    private var rotation: Double = -0.563
    private let sides = 110
    var labels: [String] {
        return ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        let endAngle = CGFloat(2 * M_PI)
        let newRect = CGRect(x: CGRectGetMinX(rect) + 20, y: CGRectGetMinY(rect) + 20, width: CGRectGetWidth(rect) - 40, height: CGRectGetHeight(rect) - 40)
        let rad = CGRectGetWidth(newRect) / 2
        
        CGContextAddArc(ctx, CGRectGetMidX(rect), CGRectGetMidY(newRect), rad, 0, endAngle, 1)
        CGContextSetFillColorWithColor(ctx, UIColor.whiteColor().colorWithAlphaComponent(0.4).CGColor)
        CGContextSetStrokeColorWithColor(ctx, UIColor.whiteColor().colorWithAlphaComponent(0.7).CGColor)
        CGContextSetLineWidth(ctx, 0.5)
        CGContextDrawPath(ctx, .FillStroke)
        
        drawMarkers(ctx, x: CGRectGetMidX(newRect), y: CGRectGetMidY(newRect), radius: rad, sides: sides, color: UIColor.whiteColor())
        
        drawText(newRect, ctx: ctx, radius: rad, color: UIColor.whiteColor())
        
        if pointerLayer.superlayer != layer {
            pointerLayer.frame = rect
            layer.addSublayer(pointerLayer)
            pointerLayer.setNeedsDisplay()
            let startingRotation = rotationForLabel("A")
            pointerLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransformMakeRotation(startingRotation))
        }
    }
    
    func rotatePointerToLabel(label: String) {
        let rotateTo = rotationForLabel(label)
        let transform = CATransform3DMakeAffineTransform(CGAffineTransformMakeRotation(rotateTo))
        if pointerLayer.superlayer == layer && !CATransform3DEqualToTransform(pointerLayer.transform, transform) {
            pointerLayer.transform = transform
        }
    }
    
    private func degreeToRadian(a: CGFloat) -> CGFloat {
        return CGFloat(M_PI) * a / 180
    }
    
    private func rotationForLabel(label: String) -> CGFloat {
        guard let index = labels.indexOf(label) else { return CGFloat(rotation) }
        let rotationStep: CGFloat = 0.045
        return (CGFloat(rotation) + (CGFloat(index) * rotationStep)) / CGFloat(M_PI_4)
    }
    
    private func circleCircumferencePoints(sides: Int, _ x: CGFloat, _ y: CGFloat, _ radius: CGFloat, adjustment: CGFloat = 0) -> [CGPoint] {
        let angle = degreeToRadian(360/CGFloat(sides))
        let cx = x // x origin
        let cy = y // y origin
        let r  = radius // radius of circle
        var i = sides
        var points = [CGPoint]()
        while points.count <= sides {
            let xpo = cx - r * cos(angle * CGFloat(i) + degreeToRadian(adjustment))
            let ypo = cy - r * sin(angle * CGFloat(i) + degreeToRadian(adjustment))
            points.append(CGPoint(x: xpo, y: ypo))
            i -= 1
        }
        return points
    }
    
    private func drawMarkers(ctx: CGContextRef, x: CGFloat, y: CGFloat, radius: CGFloat, sides: Int, color: UIColor) {
        let points = circleCircumferencePoints(sides, x, y, radius)
        let path = CGPathCreateMutable()
        let divider:CGFloat = 0.03
        for (_,p) in points.enumerate() {
            let xn = p.x + divider * (x - p.x)
            let yn = p.y + divider * (y - p.y)
            // build path
            CGPathMoveToPoint(path, nil, p.x, p.y)
            CGPathAddLineToPoint(path, nil, xn, yn)
            CGPathCloseSubpath(path)
            // add path to context
            CGContextAddPath(ctx, path)
        }
        let cgcolor = color.CGColor
        CGContextSetStrokeColorWithColor(ctx, cgcolor)
        CGContextSetLineWidth(ctx, 1)
        CGContextStrokePath(ctx)
    }
    
    private func drawText(rect: CGRect, ctx: CGContextRef, radius: CGFloat, color: UIColor) {
        // Flip text co-ordinate space, see: http://blog.spacemanlabs.com/2011/08/quick-tip-drawing-core-text-right-side-up/
        CGContextTranslateCTM(ctx, 0.0, CGRectGetHeight(rect))
        CGContextScaleCTM(ctx, 1.0, -1.0)
        // dictates how inset/outset the ring of labels will be
        let inset:CGFloat = 40
        // An adjustment to position labels correctly
        let points = circleCircumferencePoints(sides, CGRectGetMidX(rect), CGRectGetMidY(rect) - inset, radius + (inset / CGFloat(M_PI)), adjustment: 314)
        for (i,p) in points.enumerate() {
            guard i > 0 else { continue }
            guard i < labels.count + 1 else { return }
            let index = i - 1
            let aFont = UIFont.systemFontOfSize(8, weight: UIFontWeightLight)
            let attr: CFDictionaryRef = [NSFontAttributeName:aFont, NSForegroundColorAttributeName:UIColor.blackColor()]
            let text = CFAttributedStringCreate(nil, labels[index], attr)
            let line = CTLineCreateWithAttributedString(text)
            let bounds = CTLineGetBoundsWithOptions(line, CTLineBoundsOptions.UseOpticalBounds)
            CGContextSetLineWidth(ctx, 0.7)
            CGContextSetTextDrawingMode(ctx, .Fill)
            let xn = p.x - bounds.width / 2
            let yn = p.y - bounds.midY
            CGContextSetTextPosition(ctx, xn, yn)
            // the line of text is drawn - see https://developer.apple.com/library/ios/DOCUMENTATION/StringsTextFonts/Conceptual/CoreText_Programming/LayoutOperations/LayoutOperations.html
            // draw the line of text
            CTLineDraw(line, ctx)
            CGContextRotateCTM(ctx, 0.0)
        }
    }

}
