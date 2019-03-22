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
    var centerValue: CGFloat = 0
    let deltaLowerUpper: Double = 0.15
    var thumbWidth: CGFloat = 15
    let thumbAlpha: Float = 0.5
    let leftRightLayerAlpha: Float = 0.2
    var colorLayer: UIColor{
        return UIColor.gray
    }
    
    var thumbHeight: CGFloat {
        return bounds.height
    }
    var previousLocation = CGPoint()
    
    let lowerThumbLayer = RangeSliderThumbLayer()
    let upperThumbLayer = RangeSliderThumbLayer()
    let centerThumbLayer = RangeSliderThumbLayer()
    let leftLayer = CALayer()
    let rightLayer = CALayer()
    
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
        
        lowerThumbLayer.backgroundColor = self.colorLayer.cgColor
        lowerThumbLayer.opacity = self.thumbAlpha
        layer.addSublayer(lowerThumbLayer)
        
        upperThumbLayer.backgroundColor = self.colorLayer.cgColor
        upperThumbLayer.opacity = self.thumbAlpha
        layer.addSublayer(upperThumbLayer)
        
        centerThumbLayer.backgroundColor = UIColor.clear.cgColor
        centerThumbLayer.opacity = self.thumbAlpha
        centerThumbLayer.borderWidth = 1
        centerThumbLayer.borderColor = self.colorLayer.cgColor
        layer.addSublayer(centerThumbLayer)
        
        leftLayer.backgroundColor = self.colorLayer.cgColor
        leftLayer.opacity = self.leftRightLayerAlpha
        layer.addSublayer(leftLayer)
        
        rightLayer.backgroundColor = self.colorLayer.cgColor
        rightLayer.opacity = self.leftRightLayerAlpha
        layer.addSublayer(rightLayer)
        
        lowerThumbLayer.rangeSlider = self
        upperThumbLayer.rangeSlider = self
        centerThumbLayer.rangeSlider = self
        updateLayerFrames()
    }
    
    
    private func updateLayerFrames() {

        let lowerThumbCenter = CGFloat(positionForValue(lowerValue))
        lowerThumbLayer.frame = CGRect(x: lowerThumbCenter - thumbWidth / 2.0, y: 0.0, width: thumbWidth, height: thumbHeight)
        lowerThumbLayer.setNeedsDisplay()
        
        let upperThumbCenter = CGFloat(positionForValue(upperValue))
        upperThumbLayer.frame = CGRect(x: upperThumbCenter - thumbWidth / 2.0, y: 0.0, width: thumbWidth, height: thumbHeight)
        upperThumbLayer.setNeedsDisplay()
        
        let x = lowerThumbLayer.frame.origin.x + upperThumbLayer.frame.width
        let y: CGFloat = 0.0
        let width = self.upperThumbLayer.frame.origin.x - (self.lowerThumbLayer.frame.width + self.lowerThumbLayer.frame.origin.x)
        let height = thumbHeight
        centerThumbLayer.frame = CGRect(x: x, y: y, width: width, height: height)
        
        leftLayerUpdate()
        rightLAyerUpdate()
    }
    
    private func leftLayerUpdate(){
        let x: CGFloat = 0.0
        let y: CGFloat = 0.0
        let width = self.lowerThumbLayer.frame.origin.x
        let height = self.thumbHeight
        self.leftLayer.frame = CGRect(x: x, y: y, width: width, height: height)
    }
    
    private func rightLAyerUpdate(){
        let x: CGFloat = self.upperThumbLayer.frame.origin.x + self.upperThumbLayer.frame.width
        let y: CGFloat = 0.0
        let width = self.frame.width - x
        let height = self.thumbHeight
        self.rightLayer.frame = CGRect(x: x, y: y, width: width, height: height)
    }
    
    func positionForValue(_ value: CGFloat) -> CGFloat {
        return (bounds.width - thumbWidth) * (value - minimumValue) / (maximumValue - minimumValue) + (thumbWidth / 2.0)
    }
    
    func positionForCenterThumb(_ value: CGFloat) -> CGFloat{
        return 0.0
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        previousLocation = touch.location(in: self)
        
        if lowerThumbLayer.frame.contains(previousLocation) {
            lowerThumbLayer.highlighted = true
        } else if upperThumbLayer.frame.contains(previousLocation) {
            upperThumbLayer.highlighted = true
        } else if centerThumbLayer.frame.contains(previousLocation){
            centerThumbLayer.highlighted = true
        }
        
        return lowerThumbLayer.highlighted || upperThumbLayer.highlighted || centerThumbLayer.highlighted
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
            lowerValue = CGFloat(boundValue(value: Double(lowerValue), toLowerValue: Double(minimumValue), upperValue: Double(upperValue) - deltaLowerUpper))
        } else if upperThumbLayer.highlighted {
            upperValue += deltaValue
            upperValue = CGFloat(boundValue(value: Double(upperValue), toLowerValue: Double(lowerValue) + deltaLowerUpper, upperValue: Double(maximumValue)))
        } else if centerThumbLayer.highlighted{
            let widthCenter: Double = Double(upperValue - lowerValue)
            if deltaValue < 0{
                lowerValue += deltaValue
                lowerValue = CGFloat(boundValue(value: Double(lowerValue), toLowerValue: Double(minimumValue), upperValue: Double(upperValue) - widthCenter))
                upperValue += deltaValue
                upperValue = CGFloat(boundValue(value: Double(upperValue), toLowerValue: Double(lowerValue) + widthCenter, upperValue: Double(maximumValue)))
            }
            else{
                upperValue += deltaValue
                upperValue = CGFloat(boundValue(value: Double(upperValue), toLowerValue: Double(lowerValue) + widthCenter, upperValue: Double(maximumValue)))
                lowerValue += deltaValue
                lowerValue = CGFloat(boundValue(value: Double(lowerValue), toLowerValue: Double(minimumValue), upperValue: Double(upperValue) - widthCenter))
            }
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
        centerThumbLayer.highlighted = false
        sendActions(for: .touchUpOutside)
    }
}
