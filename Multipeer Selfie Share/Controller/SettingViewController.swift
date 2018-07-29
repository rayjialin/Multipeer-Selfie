//
//  SettingsController.swift
//  Multipeer Selfie Share
//
//  Created by ruijia lin on 7/15/18.
//  Copyright © 2018 ruijia lin. All rights reserved.
//

import Foundation
import CollectionViewSlantedLayout

class SettingsController: UITableViewController {
    
    weak var collectionViewLayout: CollectionViewSlantedLayout!
    
    @IBOutlet weak var slantingDirectionSegment: UISegmentedControl!
    @IBOutlet weak var scrollDirectionSegment: UISegmentedControl!
    @IBOutlet weak var zIndexOrderSegment: UISegmentedControl!
    @IBOutlet weak var firstCellSlantingSwitch: UISwitch!
    @IBOutlet weak var lastCellSlantingSwitch: UISwitch!
    @IBOutlet weak var slantingSizeSlider: UISlider!
    @IBOutlet weak var lineSpacingSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.slantingDirectionSegment.selectedSegmentIndex = (self.collectionViewLayout.slantingDirection == .downward) ? 0 : 1
        self.scrollDirectionSegment.selectedSegmentIndex = (self.collectionViewLayout.scrollDirection == .horizontal) ? 0 : 1
        self.zIndexOrderSegment.selectedSegmentIndex = (self.collectionViewLayout.zIndexOrder == .descending) ? 0 : 1
        self.firstCellSlantingSwitch.isOn = self.collectionViewLayout.isFirstCellExcluded
        self.lastCellSlantingSwitch.isOn = self.collectionViewLayout.isLastCellExcluded
        self.slantingSizeSlider.value = Float(self.collectionViewLayout.slantingSize)
        self.lineSpacingSlider.value = Float(self.collectionViewLayout.lineSpacing)        
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    
    @IBAction func slantingDirectionChanged(_ sender: UISegmentedControl) {
        self.collectionViewLayout.slantingDirection = (sender.selectedSegmentIndex == 0 ? .downward : .upward )
    }
    
    @IBAction func scrollDirectionChanged(_ sender: UISegmentedControl) {
        self.collectionViewLayout.scrollDirection = (sender.selectedSegmentIndex == 0 ? .horizontal : .vertical)
    }
    
    @IBAction func zIndexOrderChanged(_ sender: UISegmentedControl) {
        self.collectionViewLayout.zIndexOrder = (sender.selectedSegmentIndex == 0 ? .descending : .ascending)
    }
    
    @IBAction func firstCellSlantingSwitchChanged(_ sender: UISwitch) {
        self.collectionViewLayout.isFirstCellExcluded = sender.isOn
    }
    
    @IBAction func lastCellSlantingSwitchChanged(_ sender: UISwitch) {
        self.collectionViewLayout.isLastCellExcluded = sender.isOn
    }
    
    @IBAction func slantingSizeChanged(_ sender: UISlider) {
        self.collectionViewLayout.slantingSize = UInt(sender.value)
    }
    
    @IBAction func lineSpacingChanged(_ sender: UISlider) {
        self.collectionViewLayout.lineSpacing = CGFloat(sender.value)
    }
    @IBAction func done(_ sender: AnyObject) {
        self.presentingViewController?.dismiss(animated: true, completion: { () -> Void in
            self.collectionViewLayout.collectionView?.scrollRectToVisible(CGRect(x: 0, y: 0, width: 0, height: 0), animated: true);
        })
    }
}

