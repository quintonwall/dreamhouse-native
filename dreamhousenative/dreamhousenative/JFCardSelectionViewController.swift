/*
* JFCardSelectionViewController
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
import SDWebImage

public struct CardAction {
    public let title: String
    
    public init?(title: String) {
        self.title = title
    }
}

public protocol CardPresentable {
    var imageURLString: String { get }
    var placeholderImage: UIImage? { get }
    var titleText: String { get }
    var dialLabel: String { get }
    var detailTextLineOne: String { get }
    var detailTextLineTwo: String { get }
    var actionOne: CardAction? { get }
    var actionTwo: CardAction? { get }
}

public enum JFCardSelectionViewSelectionAnimationStyle {
    case Fade, Slide
}

public protocol JFCardSelectionViewControllerDelegate {
    func cardSelectionViewController(cardSelectionViewController: JFCardSelectionViewController, didSelectCardAction cardAction: CardAction, forCardAtIndexPath indexPath: NSIndexPath) -> Void
    func cardSelectionViewController(cardSelectionViewController: JFCardSelectionViewController, didSelectDetailActionForCardAtIndexPath indexPath: NSIndexPath) -> Void
}

public protocol JFCardSelectionViewControllerDataSource {
    func numberOfCardsForCardSelectionViewController(cardSelectionViewController: JFCardSelectionViewController) -> Int
    func cardSelectionViewController(cardSelectionViewController: JFCardSelectionViewController, cardForItemAtIndexPath indexPath: NSIndexPath) -> CardPresentable
}

public class JFCardSelectionViewController: UIViewController {
    
    /// This will be the UIImage behind a UIVisualEffects view that will be used to add a blur effect to the background. If this isn't set, the photo of the selected CardPresentable will be used.
    public var backgroundImage: UIImage? {
        didSet {
       
           bgImageView.image = backgroundImage
                UIView.animateWithDuration(0.3, animations: {
                self.bgImageView.alpha = 1
                self.bgImageViewTwo.alpha = 0
            }) { (finished) -> Void in
                if finished {
                   self.bgImageViewTwo.image = nil
                   
                    self.showingImageViewOne = true
                }
            }
        }
    }
    public var delegate: JFCardSelectionViewControllerDelegate?
    public var dataSource: JFCardSelectionViewControllerDataSource?
    public var selectionAnimationStyle: JFCardSelectionViewSelectionAnimationStyle = .Fade
    
    var previouslySelectedIndexPath: NSIndexPath?
    let focusedView = JFFocusedCardView.loadFromNib()
    let focusedViewTwo = JFFocusedCardView.loadFromNib()
    let dialView = DialView()
    let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: JFCardSelectionViewFlowLayout())
    
    var selectedCard : CardPresentable?
    
    private var bgImageView = UIImageView()
    private var bgImageViewTwo = UIImageView()
    private var showingImageViewOne = true
    private var focusedViewHConstraints = [NSLayoutConstraint]()
    private var focusedViewTwoHConstraints = [NSLayoutConstraint]()
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
    private let blurEffectViewTwo = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
    private let bottomCircleView = UIView()
    private let bottomCircleOutlineView = UIView()
    private let topSpace: CGFloat = 74
    private let bottomSpace: CGFloat = 20
    private let horizontalSpace: CGFloat = 75
    private var focusedViewMetrics: [String: CGFloat] {
        let width = CGRectGetWidth(view.frame) - (horizontalSpace * 2)
        return [
            "maxX": CGRectGetMaxX(view.frame),
            "minX": CGRectGetMinX(view.frame) - (width),
            "width": width,
            "topSpace": topSpace,
            "bottomSpace": bottomSpace,
            "horizontalSpace": horizontalSpace
        ]
    }
    private var focusedViewViews: [String: UIView] {
        return [
            "focusedView": focusedView,
            "focusedViewTwo": focusedViewTwo,
            "collectionView": collectionView
        ]
    }
    
    deinit {
        collectionView.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppDefaults.dreamhouseGreen
        buildBGUI()
        buildCardSelectionUI()
        buildFocusedCardUI()
        
        
        if backgroundImage == nil {
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            guard let card = dataSource?.cardSelectionViewController(self, cardForItemAtIndexPath: indexPath) else {
                return
            }
            
            bgImageView.sd_setImageWithURL(NSURL(string: card.imageURLString), placeholderImage: card.placeholderImage)
        }

        
    }
    
    public override func shouldAutorotate() -> Bool {
        return false
    }
    
    public func reloadData() {
        collectionView.reloadData()
    }
    
    private func buildBGUI() {
       bgImageView.image = backgroundImage ?? nil
     
        bgImageView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        bgImageView.addSubview(blurEffectView)
        view.addSubview(bgImageView)
        
        bgImageViewTwo.translatesAutoresizingMaskIntoConstraints = false
        blurEffectViewTwo.translatesAutoresizingMaskIntoConstraints = false
        bgImageViewTwo.addSubview(blurEffectViewTwo)
        bgImageViewTwo.alpha = 0
        view.insertSubview(bgImageViewTwo, belowSubview: bgImageView)
        
        let views = ["bgImageView": bgImageView, "blurEffectView": blurEffectView, "bgImageViewTwo": bgImageViewTwo, "blurEffectViewTwo": blurEffectViewTwo]
        for val in ["V", "H"] {
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("\(val):|[bgImageView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
            view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("\(val):|[bgImageViewTwo]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
            bgImageView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("\(val):|[blurEffectView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
            bgImageViewTwo.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("\(val):|[blurEffectViewTwo]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        }
        view.layoutIfNeeded()
    }
    
    private func buildCardSelectionUI() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        let bundle = NSBundle(forClass: JFCardSelectionCell.self)
        collectionView.registerNib(UINib(nibName: JFCardSelectionCell.reuseIdentifier, bundle: bundle), forCellWithReuseIdentifier: JFCardSelectionCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.clearColor()
        view.addSubview(collectionView)
        let height = CGRectGetHeight(UIScreen.mainScreen().bounds) / 3
        var metrics = ["height": height]
        let views = ["collectionView": collectionView]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[collectionView(==height)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[collectionView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        view.layoutIfNeeded()
        
        var width = CGRectGetWidth(view.frame)
        var y = CGRectGetMaxY(view.frame) - 40
        
        dialView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(dialView, belowSubview: collectionView)
        metrics = ["width": CGRectGetWidth(view.frame), "y": CGRectGetMaxY(view.frame) - 60]
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(y)-[dialView(==width)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: ["dialView": dialView]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[dialView(==width)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: ["dialView": dialView]))
        view.layoutIfNeeded()
        
        bottomCircleOutlineView.backgroundColor = UIColor.clearColor()
        view.insertSubview(bottomCircleOutlineView, belowSubview: dialView)
        width += 15
        y -= 27.5
        bottomCircleOutlineView.frame = CGRect(x: 0, y: y, width: width, height: width)
        let trackingLine = UIView(frame: CGRect(x: 0, y: 0, width: width, height: width))
        trackingLine.makeRoundWithBorder(width: 2, color: UIColor.whiteColor().colorWithAlphaComponent(0.5))
        bottomCircleOutlineView.addSubview(trackingLine)
        bottomCircleOutlineView.center.x = view.center.x
        
        var x = (CGRectGetWidth(bottomCircleOutlineView.frame) / CGFloat(M_PI * 2)) - 9.5
        y = x
        let trackingIndicatorInner = UIView(frame: CGRect(x: x, y: y, width: 10, height: 10))
        trackingIndicatorInner.makeRound()
        trackingIndicatorInner.backgroundColor = UIColor.whiteColor()
        
        x -= 2.5
        y -= 2.5
        let trackingIndicatorOuter = UIView(frame: CGRect(x: x, y: y, width: 15, height: 15))
        trackingIndicatorOuter.makeRound()
        trackingIndicatorOuter.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
        
        bottomCircleOutlineView.addSubview(trackingIndicatorOuter)
        bottomCircleOutlineView.addSubview(trackingIndicatorInner)
        
        collectionView.addObserver(self, forKeyPath: "contentOffset", options: .New, context: nil)
    }
    
    private func buildFocusedCardUI() {
        focusedView.delegate = self
        focusedViewTwo.delegate = self
        
        focusedView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(focusedView)
        focusedViewTwo.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(focusedViewTwo, belowSubview: focusedView)
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(topSpace)-[focusedView]-(bottomSpace)-[collectionView]", options: NSLayoutFormatOptions(rawValue: 0), metrics: focusedViewMetrics, views: focusedViewViews))
        focusedViewHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(horizontalSpace)-[focusedView]-(horizontalSpace)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: focusedViewMetrics, views: focusedViewViews)
        view.addConstraints(focusedViewHConstraints)
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(topSpace)-[focusedViewTwo]-(bottomSpace)-[collectionView]", options: NSLayoutFormatOptions(rawValue: 0), metrics: focusedViewMetrics, views: focusedViewViews))
        
        switch selectionAnimationStyle {
        case .Fade:
            focusedViewTwo.alpha = 0
            focusedViewTwoHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(horizontalSpace)-[focusedViewTwo]-(horizontalSpace)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: focusedViewMetrics, views: focusedViewViews)
            view.addConstraints(focusedViewTwoHConstraints)
        case .Slide:
            focusedViewTwo.hidden = true
            focusedViewTwoHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(maxX)-[focusedViewTwo]", options: NSLayoutFormatOptions(rawValue: 0), metrics: focusedViewMetrics, views: focusedViewViews)
            view.addConstraints(focusedViewTwoHConstraints)
        }
        
        view.layoutIfNeeded()
        
        let color = UIColor.blackColor().colorWithAlphaComponent(0.4)
        let h = 64
        let w = 44
        let metrics = ["w": w, "h": h]
        var acc = AccessoryIndicator.withColor(color, facing: .Left, size: CGSize(width: w, height: h))
        acc.addTarget(self, action: #selector(previousCard), forControlEvents: .TouchUpInside)
        acc.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(acc, belowSubview: focusedView)
        view.addConstraint(NSLayoutConstraint(item: acc, attribute: .CenterY, relatedBy: .Equal, toItem: focusedView, attribute: .CenterY, multiplier: 1, constant: 0))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[acc(==h)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: ["acc": acc]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[acc(==w)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: ["acc": acc]))
        
        acc = AccessoryIndicator.withColor(color, facing: .Right, size: CGSize(width: w, height: h))
        acc.translatesAutoresizingMaskIntoConstraints = false
        acc.addTarget(self, action: #selector(nextCard), forControlEvents: .TouchUpInside)
        view.insertSubview(acc, belowSubview: focusedView)
        view.addConstraint(NSLayoutConstraint(item: acc, attribute: .CenterY, relatedBy: .Equal, toItem: focusedView, attribute: .CenterY, multiplier: 1, constant: 0))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[acc(==h)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: ["acc": acc]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[acc(==w)]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: ["acc": acc]))
        
        view.layoutIfNeeded()
    }
    
    func updateUIForCard(card: CardPresentable, atIndexPath indexPath: NSIndexPath) {
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .CenteredHorizontally, animated: true)
        if !showingImageViewOne {
            if backgroundImage == nil {
                 bgImageView.sd_setImageWithURL(NSURL(string: card.imageURLString), placeholderImage: card.placeholderImage)
 
           }
            focusedView.configureForCard(card)
        } else {
            if backgroundImage == nil {
                  bgImageView.sd_setImageWithURL(NSURL(string: card.imageURLString), placeholderImage: card.placeholderImage)
            }
            focusedViewTwo.configureForCard(card)
        }
        
        switch selectionAnimationStyle {
        case .Fade:
            fade()
        case .Slide:
            slideToIndexPath(indexPath)
        }
        
        showingImageViewOne = !showingImageViewOne
    }
    
    func previousCard() {
        let count = dataSource?.numberOfCardsForCardSelectionViewController(self)
        let row = (previouslySelectedIndexPath?.row ?? 0) - 1
        let section = previouslySelectedIndexPath?.section ?? 0
        if row >= 0 && row < count {
            let indexPath = NSIndexPath(forRow: row, inSection: section)
            guard let card = dataSource?.cardSelectionViewController(self, cardForItemAtIndexPath: indexPath) else {
                return
            }
            collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .None)
            updateUIForCard(card, atIndexPath: indexPath)
             selectedCard = card
            previouslySelectedIndexPath = indexPath
        }
    }
    
    func nextCard() {
        let count = dataSource?.numberOfCardsForCardSelectionViewController(self)
        let row = (previouslySelectedIndexPath?.row ?? 0) + 1
        let section = previouslySelectedIndexPath?.section ?? 0
        if row < count {
            let indexPath = NSIndexPath(forRow: row, inSection: section)
            guard let card = dataSource?.cardSelectionViewController(self, cardForItemAtIndexPath: indexPath) else {
                return
            }
            collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .None)
            updateUIForCard(card, atIndexPath: indexPath)
            selectedCard = card
            
            previouslySelectedIndexPath = indexPath
        
        }
    }
    
    func fade() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            if self.backgroundImage == nil {
                self.bgImageView.alpha = CGFloat(!self.showingImageViewOne)
                self.bgImageViewTwo.alpha = CGFloat(self.showingImageViewOne)
            }
            self.focusedView.alpha = CGFloat(!self.showingImageViewOne)
            self.focusedViewTwo.alpha = CGFloat(self.showingImageViewOne)
        }) { finished in
            self.finishAnimations()
        }
    }
    
    func finishAnimations() {
        
        if self.showingImageViewOne {
            if self.backgroundImage == nil {
                self.bgImageViewTwo.image = nil
               
            }
            self.focusedViewTwo.configureForCard(nil)
        } else {
            if self.backgroundImage == nil {
               self.bgImageView.image = nil
            }
            self.focusedView.configureForCard(nil)
            
        }
    }
    
    func shake() {
        var startX: CGFloat
        if self.showingImageViewOne {
            startX = self.focusedView.center.x
        } else {
            startX = self.focusedViewTwo.center.x
        }
        UIView.animateKeyframesWithDuration(0.5, delay: 0, options: .CalculationModeLinear, animations: { () -> Void in
            
            UIView.addKeyframeWithRelativeStartTime(0, relativeDuration: 0.125) {
                if self.showingImageViewOne {
                    self.focusedView.center.x += 10
                } else {
                    self.focusedViewTwo.center.x += 10
                }
            }
            
            UIView.addKeyframeWithRelativeStartTime(0.125, relativeDuration: 0.125) {
                if self.showingImageViewOne {
                    self.focusedView.center.x -= 10
                } else {
                    self.focusedViewTwo.center.x -= 10
                }
            }
            
            UIView.addKeyframeWithRelativeStartTime(0.25, relativeDuration: 0.125) {
                if self.showingImageViewOne {
                    self.focusedView.center.x -= 10
                } else {
                    self.focusedViewTwo.center.x -= 10
                }
            }
            
            UIView.addKeyframeWithRelativeStartTime(0.375, relativeDuration: 0.125) {
                if self.showingImageViewOne {
                    self.focusedView.center.x = startX
                } else {
                    self.focusedViewTwo.center.x = startX
                }
            }
            
        }) { (finished) -> Void in
                
        }
    }
    
    func slideToIndexPath(indexPath: NSIndexPath) {
        var scrollLeft = true
        if let _previousIndexPath = previouslySelectedIndexPath {
            scrollLeft = indexPath.row > _previousIndexPath.row
        }
        
        // Moves views into starting position
        if showingImageViewOne {
            focusedViewTwo.hidden = true
            view.removeConstraints(focusedViewTwoHConstraints)
            if scrollLeft {
                focusedViewTwoHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(maxX)-[focusedViewTwo(==width)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: focusedViewMetrics, views: focusedViewViews)
            } else {
                focusedViewTwoHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(minX)-[focusedViewTwo(==width)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: focusedViewMetrics, views: focusedViewViews)
            }
            view.addConstraints(focusedViewTwoHConstraints)
            view.layoutIfNeeded()
            focusedViewTwo.hidden = false
            
            view.removeConstraints(focusedViewHConstraints)
            view.removeConstraints(focusedViewTwoHConstraints)
            focusedViewTwoHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(horizontalSpace)-[focusedViewTwo]-(horizontalSpace)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: focusedViewMetrics, views: focusedViewViews)
            if scrollLeft {
                focusedViewHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(minX)-[focusedView(==width)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: focusedViewMetrics, views: focusedViewViews)
            } else {
                focusedViewHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(maxX)-[focusedView(==width)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: focusedViewMetrics, views: focusedViewViews)
            }
            view.addConstraints(focusedViewHConstraints)
            view.addConstraints(focusedViewTwoHConstraints)
        } else {
            focusedView.hidden = true
            view.removeConstraints(focusedViewHConstraints)
            if scrollLeft {
                focusedViewHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(maxX)-[focusedView(==width)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: focusedViewMetrics, views: focusedViewViews)
            } else {
                focusedViewHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(minX)-[focusedView(==width)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: focusedViewMetrics, views: focusedViewViews)
            }
            view.addConstraints(focusedViewHConstraints)
            view.layoutIfNeeded()
            focusedView.hidden = false
            
            view.removeConstraints(focusedViewHConstraints)
            view.removeConstraints(focusedViewTwoHConstraints)
            focusedViewHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(horizontalSpace)-[focusedView]-(horizontalSpace)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: focusedViewMetrics, views: focusedViewViews)
            if scrollLeft {
                focusedViewTwoHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(minX)-[focusedViewTwo(==width)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: focusedViewMetrics, views: focusedViewViews)
            } else {
                focusedViewTwoHConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(maxX)-[focusedViewTwo(==width)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: focusedViewMetrics, views: focusedViewViews)
            }
            view.addConstraints(focusedViewHConstraints)
            view.addConstraints(focusedViewTwoHConstraints)
        }
        
        // Animates views into final position
        UIView.animateWithDuration(0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9, options: .CurveEaseInOut, animations: { () -> Void in
            self.view.layoutIfNeeded()
            if self.backgroundImage == nil {
                self.bgImageView.alpha    = CGFloat(!self.showingImageViewOne)
                self.bgImageViewTwo.alpha = CGFloat(self.showingImageViewOne)
            }
        }) { finished in
           // self.backgroundImage
            self.finishAnimations()
        }
    }
    
    var rotation: CGFloat = 0
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        guard let offset = change?[NSKeyValueChangeNewKey]?.CGPointValue else { return }
        guard let flowLayout = collectionView.collectionViewLayout as? JFCardSelectionViewFlowLayout else { return }
        let w = ((collectionView.contentSize.width - (flowLayout.sectionInset.left + flowLayout.sectionInset.right))) / CGFloat(M_PI_2)
        rotation = (offset.x / w)
        bottomCircleOutlineView.transform = CGAffineTransformMakeRotation(rotation)
        
        let collectionViewCenterX = collectionView.center.x
        for item in collectionView.visibleCells() {
            guard let cardCell = item as? JFCardSelectionCell else { return }
            let cardPosition = view.convertPoint(cardCell.center, fromView: collectionView)
            if cardPosition.x <= collectionViewCenterX + 20 && cardPosition.x >= collectionViewCenterX - 20 {
                guard let label = cardCell.card?.dialLabel else { return }
                dialView.rotatePointerToLabel(label)
            }
        }
    }
    
}
