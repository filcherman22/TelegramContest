//
//  DateView.swift
//  TelegramContestRomanov
//
//  Created by Филипп on 18.03.2019.
//  Copyright © 2019 Филипп. All rights reserved.
//

import UIKit


extension Date {
    func asString(style: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        let dateStr = dateFormatter.string(from: self)
        return dateStr
    }
    
    func getYear4Sibbols() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        let dateStr = dateFormatter.string(from: self)
        return dateStr
    }
}

class DateView: UIView {
    
    var arrLabel: [UILabel] = []
    var arrStepBack: [[Bool]] = []
    var countSaveArr: Int = 0
    var data: GraphInfo?
    let labelWidth: CGFloat = 60
    let labelHeight: CGFloat = 15
    let labelFontSize: CGFloat = 12
    let labelAlpha: CGFloat = 0.5
    let alphaDuration: Double = 0.5
    var maxLabelsCount: Int = 0
    var maxWidth: CGFloat = 0
    var stepChoise: Int = 0
    var reactionAlpha: CGFloat = 0.4
    
    var isDay: Bool = false
    
    var colorLabel: UIColor = UIColor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initColorThemeDay()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initColorThemeDay()
    }
    
    private func initColorThemeDay(){
        setTheme(isDay: self.isDay)
    }
    
    func setDate(data: GraphInfo){
        self.arrLabel.removeAll()
        self.data = data
        self.maxLabelsCount = Int(self.frame.width / self.labelWidth)
        dateReload()
        createArrLabel()
        self.maxWidth = CGFloat(self.arrLabel.count) * self.labelWidth
        createOriginCoord()
        addLabelToView()
        createArrSaves()
        setTheme(isDay: self.isDay)
    }
    private func createArrLabel(){
        for i in 0...self.data!.arrDayInfo.count - 1{
            if (( (i + 1) % self.stepChoise == self.stepChoise / 2) || ( (i+1) == self.stepChoise / 2)){
                let label: UILabel = UILabel()
                label.alpha = self.labelAlpha
                label.text = self.data!.arrDayInfo[i].date.asString(style: .medium)
                label.font = UIFont.systemFont(ofSize: self.labelFontSize)
                label.frame.size = CGSize(width: self.labelWidth, height: self.labelHeight)
                label.textAlignment = .center
                self.arrLabel.append(label)
            }
            else if i == self.data!.arrDayInfo.count - 1 && self.arrLabel.count != self.maxLabelsCount{
                let label: UILabel = UILabel()
                label.alpha = self.labelAlpha
                label.text = self.data!.arrDayInfo[i].date.asString(style: .medium)
                label.font = UIFont.systemFont(ofSize: self.labelFontSize)
                label.frame.size = CGSize(width: self.labelWidth, height: self.labelHeight)
                label.textAlignment = .center
                self.arrLabel.append(label)
            }
        }
    }
    
    func addLabelToView(){
        for el in self.arrLabel{
            self.addSubview(el)
        }
    }
    
    func createOriginCoord(){
        if self.data != nil{
            let width: CGFloat = self.frame.width / CGFloat((self.arrLabel.count -  1))
            for i in 0...self.arrLabel.count - 1{
                let x = width * CGFloat(i) + width / 2
                let y = self.frame.height / 2
                if x > self.frame.width - self.arrLabel[i].frame.width / 2 && self.arrLabel[i].alpha != 0{
                    if x >= self.frame.width - self.arrLabel[i].frame.width / 1.5{
                        
                    }
                    else{
//                        self.arrLabel[i].alpha = (self.frame.width - x) / self.arrLabel[i].frame.width * 2 * self.labelAlpha
                    }
//                    x = self.frame.width - self.arrLabel[i].frame.width / 2
                }
                self.arrLabel[i].center = CGPoint(x: x, y: y)
            }
        }
        
    }
    
    private func isWarning(iSelf: Int) -> Bool{
        for i in 0...self.arrLabel.count - 1{
            if iSelf != i && self.arrLabel[i].alpha == self.labelAlpha && -(self.arrLabel[i].center.x - self.arrLabel[iSelf].center.x) <= self.labelWidth {
                return true
            }
        }
        return false
    }
    
    func setWidth(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat){
        self.frame = CGRect(x: x, y: y, width: width, height: height)
        if self.data != nil{
//            dateReload()
            createOriginCoord()
            reloadLabelsAlpha()
            
        }
        
    }
    
    func dateReload(){
        self.stepChoise = self.data!.arrDayInfo.count / (self.maxLabelsCount) + 1
    }
    
    private func setStartLabelsAlpha(n: Int){
        for i in 0...self.arrLabel.count - 1{
            if i % Int(n) == 0 && i != 0{
                self.arrLabel[i].alpha = self.labelAlpha
            }
            else{
                self.arrLabel[i].alpha = 0
            }
        }
    }
    
    private func alphaLabes(alpha: CGFloat, numArr: Int, isLower: Bool){
        for i in 0...self.arrLabel.count - 1{
            if !self.arrStepBack[numArr][i] {
                if self.arrStepBack[numArr - 1][i] != self.arrStepBack[numArr][i]{
                    self.arrLabel[i].alpha = alpha * self.labelAlpha
                    
                }
                else{
                    self.arrLabel[i].alpha = 0
                }
                
            }
            else{
                self.arrLabel[i].alpha = self.labelAlpha
            }
        }
    }
    
    private func saveArrStepBack(){
        var isAlphaArr: [Bool] = []
        for el in self.arrLabel{
            if el.alpha == 0{
                isAlphaArr.append(false)
            }
            else{
                isAlphaArr.append(true)
            }
        }
        self.arrStepBack.append(isAlphaArr)
        self.countSaveArr = self.arrStepBack.count
    }
    
    private func createArrSaves(){
        var newArr: [Bool] = Array(repeating: true, count: self.arrLabel.count)
        self.arrStepBack.append(newArr)
        
        var isEven = true
        while newArr.firstIndex(of: true) != nil {
            for i in 0...newArr.count - 1{
                if newArr[i]{
                    if isEven{
                        newArr[i] = false
                        isEven = false
                    }
                    else{
                        isEven = true
                    }
                }
            }
            self.arrStepBack.append(newArr)
        }
    }
    
    private func reloadLabelsAlpha(){
        let div = Int(self.maxWidth / self.frame.width)
        if div == 0{
            return
        }
        if log2(Double(div)) - Double(Int(log2(Double(div)))) == 0 || div == 1{
            let numArr: Int = Int(log2(Double(div))) + 1
            let rest = self.maxWidth - CGFloat(div) * self.frame.width
            if rest / self.frame.width < self.reactionAlpha{
                alphaLabes(alpha: 1 - (rest / self.frame.width * (1.0 / self.reactionAlpha)), numArr: numArr, isLower: true)
            }
            else{
                alphaLabes(alpha: 0, numArr: numArr, isLower: true)
            }
        }
    }
    
    func clearLabelsAplpha(){
        if self.arrLabel.count > 0{
            for i in 0...self.arrLabel.count - 1{
                if self.arrLabel[i].alpha < self.labelAlpha && self.arrLabel[i].alpha != 0{
                    UIView.animate(withDuration: 0.2) {
                        if self.labelAlpha / self.arrLabel[i].alpha >= 1.5{
                            self.arrLabel[i].alpha = 0
                        }
                        else{
//                            self.arrLabel[i].alpha = self.labelAlpha
                        }
                    }
                }
            }
        }
    }
    
    func setTheme(isDay: Bool){
        self.isDay = isDay
        let theme = ThemeColors()
        UIView.animate(withDuration: theme.duration) {
            for el in self.arrLabel{
                if !isDay{
                    el.textColor = theme.dateLabelColorDay
                    self.backgroundColor = theme.frontColorDay
                }
                else{
                    el.textColor = theme.dateLabelColorNight
                    self.backgroundColor = theme.frontColorNight
                }
            }
            
        }
    }
}
