//
//  RangeSlider.swift
//  TelegramContestRomanov
//
//  Created by Филипп on 20.03.2019.
//  Copyright © 2019 Филипп. All rights reserved.
//

import UIKit

import QuartzCore

class RangeSliderThumbLayer: CALayer {
    var highlighted = false
    weak var rangeSlider: RangeSlider?
}

class RangeSlider: UIControl {

    
    var minimumValue: CGFloat = 0
    var maximumValue: CGFloat = 1
    var lowerValue: CGFloat = 0.2
    var upperValue: CGFloat = 1
    
    var thumbWidth: CGFloat {
        return CGFloat(bounds.height)
    }
    
    var previousLocation = CGPoint()
    let trackLayer = CALayer()
    let lowerThumbLayer = RangeSliderThumbLayer()
    let upperThumbLayer = RangeSliderThumbLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSettingsDefault()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSettingsDefault()
    }
    
    override var frame: CGRect {
        didSet {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            updateLayerFrames()
            CATransaction.commit()
        }
    }
    
    func setPointsValue(lower: CGFloat, upper: CGFloat){
        lowerValue = lower
        lowerValue = CGFloat(boundValue(value: Double(lowerValue), toLowerValue: Double(minimumValue), upperValue: Double(upperValue)))
        upperValue = upper
        upperValue = CGFloat(boundValue(value: Double(upperValue), toLowerValue: Double(lowerValue), upperValue: Double(maximumValue)))
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        updateLayerFrames()
        
        CATransaction.commit()
    }
    
    private func initSettingsDefault(){
        trackLayer.backgroundColor = UIColor.blue.cgColor
//        layer.addSublayer(trackLayer)
        lowerThumbLayer.backgroundColor = UIColor.green.cgColor
        layer.addSublayer(lowerThumbLayer)
        upperThumbLayer.backgroundColor = UIColor.green.cgColor
        layer.addSublayer(upperThumbLayer)
        lowerThumbLayer.rangeSlider = self
        upperThumbLayer.rangeSlider = self
        updateLayerFrames()
    }
    
    
    private func updateLayerFrames() {
        trackLayer.frame = bounds.insetBy(dx: 0.0, dy: bounds.height / 3)
        trackLayer.setNeedsDisplay()
        
        let lowerThumbCenter = CGFloat(positionForValue(lowerValue))
        
        lowerThumbLayer.frame = CGRect(x: lowerThumbCenter - thumbWidth / 2.0, y: 0.0, width: thumbWidth, height: thumbWidth)
        lowerThumbLayer.setNeedsDisplay()
        
        let upperThumbCenter = CGFloat(positionForValue(upperValue))
        upperThumbLayer.frame = CGRect(x: upperThumbCenter - thumbWidth / 2.0, y: 0.0, width: thumbWidth, height: thumbWidth)
        upperThumbLayer.setNeedsDisplay()
    }
    
    func positionForValue(_ value: CGFloat) -> CGFloat {
        return (bounds.width - thumbWidth) * (value - minimumValue) / (maximumValue - minimumValue) + (thumbWidth / 2.0)
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        previousLocation = touch.location(in: self)
        
        if lowerThumbLayer.frame.contains(previousLocation) {
            lowerThumbLayer.highlighted = true
        } else if upperThumbLayer.frame.contains(previousLocation) {
            upperThumbLayer.highlighted = true
        }
        
        return lowerThumbLayer.highlighted || upperThumbLayer.highlighted
    }
    func boundValue(value: Double, toLowerValue lowerValue: Double, upperValue: Double) -> Double {
        return min(max(value, lowerValue), upperValue)
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        
        let deltaLocation = (location.x - previousLocation.x)
        let deltaValue = (maximumValue - minimumValue) * deltaLocation / (bounds.width - thumbWidth)
        
        previousLocation = location
        
        if lowerThumbLayer.highlighted {
            lowerValue += deltaValue
            lowerValue = CGFloat(boundValue(value: Double(lowerValue), toLowerValue: Double(minimumValue), upperValue: Double(upperValue)))
        } else if upperThumbLayer.highlighted {
            upperValue += deltaValue
            upperValue = CGFloat(boundValue(value: Double(upperValue), toLowerValue: Double(lowerValue), upperValue: Double(maximumValue)))
        }
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        updateLayerFrames()
        
        CATransaction.commit()
        sendActions(for: .valueChanged)
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        lowerThumbLayer.highlighted = false
        upperThumbLayer.highlighted = false
    }
}
