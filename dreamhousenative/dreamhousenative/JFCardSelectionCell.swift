/*
* JFCardSelectionCell
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

class JFCardSelectionCell: UICollectionViewCell {

    static let reuseIdentifier = "JFCardSelectionCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    private weak var scrollView: UIScrollView!
    var card: CardPresentable?
    private var rotation: CGFloat {
        guard let _scrollView = scrollView else { return 0 }
        guard let _superView = _scrollView.superview else { return 0 }
        let position = _superView.convertPoint(self.center, fromView: scrollView)
        let superViewCenterX = CGRectGetMidX(_superView.frame)
        return ((position.x - superViewCenterX) / superViewCenterX) / 1.3
    }
    private var centerY: CGFloat {
        let height = CGRectGetHeight(scrollView.frame)
        var y = rotation
        if rotation < 0.0 {
            y *= -1
            y *= (rotation * -1)
        } else {
            y *= rotation
        }
        return ((y * height) / 1.8) + (height / 2.5)
    }
    
    deinit {
        scrollView.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 2
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        scrollView.removeObserver(self, forKeyPath: "contentOffset")
        if let _imageURLString = card?.imageURLString {
            imageView.sd_cancelCurrentImageLoad()
        }
        imageView.image = nil
        label.text = nil
    }
    
    func configureForCard(card: CardPresentable, inScrollView scrollView: UIScrollView) {
        
        self.card = card
        self.scrollView = scrollView
        self.scrollView.addObserver(self, forKeyPath: "contentOffset", options: .New, context: nil)
        
        imageView.sd_setImageWithURL(NSURL(string: card.imageURLString), placeholderImage: card.placeholderImage)
        
        self.transform = CGAffineTransformMakeRotation(rotation)
        center.y = centerY
        
        label.attributedText = NSAttributedString(string: card.titleText, attributes: ShadowAttributes.forLabelSoft)

    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
//        if (card?.titleText ?? "") == "Avery Smith" {
        self.transform = CGAffineTransformMakeRotation(rotation)
        center.y = centerY
//        }
    }

}
