/*
* JFFocusedCardView
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

protocol JFFocusedCardViewDelegate {
    func focusedCardViewDidSelectDetailAction(focusedCardView: JFFocusedCardView) -> Void
    func focusedCardViewDidSelectActionItemOne(focusedCardView: JFFocusedCardView) -> Void
    func focusedCardViewDidSelectActionItemTwo(focusedCardView: JFFocusedCardView) -> Void
}

class JFFocusedCardView: UIView {

    var card: CardPresentable!
    var delegate: JFFocusedCardViewDelegate?
    private var recognizer: UITapGestureRecognizer!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabelOne: UILabel!
    @IBOutlet var subTitleLabelTwo: UILabel!
    @IBOutlet weak var actionOneButton: UIButton!
    @IBOutlet weak var actionTwoButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 2
        imageView.layer.borderColor = UIColor.whiteColor().colorWithAlphaComponent(0.4).CGColor
        imageView.layer.borderWidth = 0.5
        actionOneButton.hidden = true
        actionOneButton.layer.cornerRadius = 2
        actionOneButton.layer.borderColor = UIColor.whiteColor().colorWithAlphaComponent(0.5).CGColor
        actionOneButton.layer.borderWidth = 0.5
        actionTwoButton.hidden = true
        actionTwoButton.layer.cornerRadius = 2
        actionTwoButton.layer.borderColor = UIColor.whiteColor().colorWithAlphaComponent(0.5).CGColor
        actionTwoButton.layer.borderWidth = 0.5
        recognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        imageView.addGestureRecognizer(recognizer)
        imageView.userInteractionEnabled = true
    }
    
    func configureForCard(card: CardPresentable?) {
        guard let _card = card else {
            self.card = nil
            self.imageView.image = nil
            self.titleLabel.text = nil
            self.subTitleLabelOne.text = nil
            self.subTitleLabelTwo.text = nil
            return
        }
        
        self.card = _card
        
        if let _actionOne = self.card.actionOne {
            let title = NSAttributedString(string: _actionOne.title, attributes: ShadowAttributes.forLabelMedium)
            actionOneButton.setAttributedTitle(title, forState: .Normal)
            actionOneButton.hidden = false
        }
        
        if let _actionTwo = self.card.actionTwo {
            let title = NSAttributedString(string: _actionTwo.title, attributes: ShadowAttributes.forLabelMedium)
            actionTwoButton.setAttributedTitle(title, forState: .Normal)
            actionTwoButton.hidden = false
        }
        

        //imageView.loadImageAtURL(self.card.imageURLString, withDefaultImage: self.card.placeholderImage)
        imageView.sd_setImageWithURL(NSURL(string: self.card.imageURLString), placeholderImage: self.card.placeholderImage)
        
        
        titleLabel.attributedText = NSAttributedString(string: self.card.titleText, attributes: ShadowAttributes.forLabelSoft)
        titleLabel.textColor = AppDefaults.dreamhouseBlreen
        subTitleLabelOne.attributedText = NSAttributedString(string: self.card.detailTextLineOne, attributes: ShadowAttributes.forLabelSoft)
        subTitleLabelOne.textColor = AppDefaults.dreamhouseLightBlue
        subTitleLabelTwo.attributedText = NSAttributedString(string: self.card.detailTextLineTwo, attributes: ShadowAttributes.forLabelSoft)
    }

    @IBAction func actionOneButtonAction(sender: AnyObject) {
        delegate?.focusedCardViewDidSelectActionItemOne(self)
    }
    
    @IBAction func actionTwoButtonAction(sender: AnyObject) {
        delegate?.focusedCardViewDidSelectActionItemTwo(self)
    }
    
    func tapAction() {
        delegate?.focusedCardViewDidSelectDetailAction(self)
    }
}


