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
    var data: GraphInfo?
    
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
        addLabelToView()
    }
    private func createArrLabel(){
        let label: UILabel = UILabel()
        for el in (data?.arrDayInfo)!{
            label.text = el.date.asString(style: .medium)
            label.font = UIFont(name: "default", size: 12)
            label.frame = CGRect(x: 10, y: 10, width: 30, height: 15)
            self.arrLabel.append(label)
        }
    }
    
    func addLabelToView(){
        for el in self.arrLabel{
            self.addSubview(el)
        }
    }
    
}
