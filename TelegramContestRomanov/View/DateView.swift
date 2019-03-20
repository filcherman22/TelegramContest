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
        dateFormatter.dateStyle = style
        let dateStr = dateFormatter.string(from: self)
        let arrStr = dateStr.components(separatedBy: ",")
        let date = arrStr[0]
        return date
    }
}

class DateView: UIView {
    

    @IBOutlet var dateView: UIView!
    var arrLabel: [UILabel] = []
    var arrStepBack: [[Bool]] = []
    var countSaveArr: Int = 0
    var data: GraphInfo?
    let labelWidth: CGFloat = 70
    let labelHeight: CGFloat = 18
    let labelFontSize: CGFloat = 15
    let alphaDuration: Double = 0.5
    var labelNumStart: CGFloat = 0
    var labelNum: CGFloat = 0{
        didSet(oldValue){
            if oldValue != 0{
                let div = Int(self.labelNum / self.labelNumStart)
                print(div)
                let rest: CGFloat = self.labelNum - CGFloat(Int(self.labelNum / self.labelNumStart)) * self.labelNumStart
                let lineStop: CGFloat = self.labelNumStart / 4
                if div > countSaveArr{
                    print("More")
                    saveArrStepBack()
                }
                else if div < countSaveArr{
                    print("lower")
                    self.arrStepBack.removeLast()
                    countSaveArr = countSaveArr - 1
                }
                if rest <= lineStop{
                    lowerLabes(alpha: 1 - (rest / lineStop) )
                }else{
                    lowerLabes(alpha: 0)
                }
            
                
//                else if self.labelNum < oldValue && self.labelNum > self.labelNumStart{
//                    if self.labelNum % labelNumStart == self.labelNumStart / 4{
//                        moreLabes()
//                    }
//                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    private func customInit() {
        Bundle.main.loadNibNamed("DateView", owner: self, options: nil)
        addSubview(dateView)
        dateView.frame = self.bounds
        dateView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func setDate(data: GraphInfo){
        self.arrLabel.removeAll()
        self.data = data
        createArrLabel()
        createOriginCoord()
        addLabelToView()
        dateReload()
        setStartLabelsAlpha(n: Int(self.labelNum))
        self.labelNumStart = self.labelNum
        saveArrStepBack()
    }
    private func createArrLabel(){
        
        for el in (data?.arrDayInfo)!{
            let label: UILabel = UILabel()
            label.alpha = 0
            label.text = el.date.asString(style: .medium)
            label.font = UIFont(name: "default", size: self.labelFontSize)
            label.frame.size = CGSize(width: self.labelWidth, height: self.labelHeight)
            self.arrLabel.append(label)
        }
    }
    
    func addLabelToView(){
        for el in self.arrLabel{
            self.addSubview(el)
        }
    }
    
    func createOriginCoord(){
        if self.data != nil{
            let width: CGFloat = self.frame.width / CGFloat(((self.data?.arrDayInfo.count)! - 1))
            for i in 0...(data?.arrDayInfo.count)! - 1{
                self.arrLabel[i].center = CGPoint(x: width * CGFloat(i), y: self.frame.height / 2)
            }
        }
        
    }
    
    func setWidth(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat){
        self.frame = CGRect(x: x, y: y, width: width, height: height)
        if self.data != nil{
            dateReload()
            createOriginCoord()
        }
        
    }
    
    func dateReload(){
        let width = self.frame.width
        let n = width / self.labelWidth
        self.labelNum = CGFloat(self.arrLabel.count) / n + 1
    }
    
    private func setStartLabelsAlpha(n: Int){
        for i in 0...self.arrLabel.count - 1{
            if i % Int(n) == 0 && i != 0{
                self.arrLabel[i].alpha = 1
            }
            else{
                self.arrLabel[i].alpha = 0
            }
        }
    }
    
    private func lowerLabes(alpha: CGFloat){
//        saveArrStepBack()
        var isEven: Bool = false
        for i in 1...self.arrLabel.count - 1{
            if self.arrStepBack.last![i]{
                if isEven{
                    UIView.animate(withDuration: alphaDuration) {
                        self.arrLabel[i].alpha = alpha
                    }
                    isEven = false
                }
                else{
                    isEven = true
                }
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
        print(isAlphaArr)
        self.arrStepBack.append(isAlphaArr)
        self.countSaveArr = self.arrStepBack.count
    }
    
    private func moreLabes(){
        for i in 0...self.arrStepBack.last!.count - 1{
            if self.arrStepBack.last![i] {
                UIView.animate(withDuration: self.alphaDuration) {
                    self.arrLabel[i].alpha = 1
                }
            }
            else{
                UIView.animate(withDuration: self.alphaDuration) {
                    self.arrLabel[i].alpha = 0
                }
            }
        }
        self.arrStepBack.removeLast()
    }
}
