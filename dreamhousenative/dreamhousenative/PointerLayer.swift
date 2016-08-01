/*
* PointerLayer
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

class PointerLayer: CALayer {
    
    override func drawInContext(ctx: CGContext) {
        
        contentsScale = UIScreen.mainScreen().scale
        let midX = CGRectGetMidX(frame)
        let midY = CGRectGetMidY(frame)
        
        CGContextMoveToPoint(ctx, midX, 16)
        CGContextAddLineToPoint(ctx, midX + 4, 20)
        CGContextAddLineToPoint(ctx, midX - 4, 20)
        CGContextAddLineToPoint(ctx, midX, 16)
        CGContextSetFillColorWithColor(ctx, UIColor.blackColor().CGColor)
        CGContextSetStrokeColorWithColor(ctx, UIColor.blackColor().CGColor)
        CGContextSetLineWidth(ctx, 1)
        CGContextDrawPath(ctx, .Fill)
        
        CGContextMoveToPoint(ctx, midX, 20)
        CGContextAddLineToPoint(ctx, midX, midY)
        CGContextAddLineToPoint(ctx, midX - 1, midY)
        CGContextMoveToPoint(ctx, midX - 1, 20)
        CGContextSetFillColorWithColor(ctx, UIColor.whiteColor().CGColor)
        CGContextSetStrokeColorWithColor(ctx, UIColor.whiteColor().CGColor)
        CGContextSetLineWidth(ctx, 1)
        CGContextDrawPath(ctx, .FillStroke)
    }
    
}
