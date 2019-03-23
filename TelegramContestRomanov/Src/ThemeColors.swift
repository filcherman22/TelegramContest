//
//  ThemeColors.swift
//  TelegramContestRomanov
//
//  Created by Филипп on 23.03.2019.
//  Copyright © 2019 Филипп. All rights reserved.
//

import UIKit

struct ThemeColors {
    
    init() {
        self.graphLineColorDay = self.graphLabelsTextColorDay
        self.graphLineNight = self.graphLabelsTextColorNight
        self.dateLabelColorDay = self.graphLabelsTextColorDay
        self.dateLabelColorNight = self.graphLabelsTextColorNight
    }
    
    let duration: Double = 0.1
    
    let frontColorNight: UIColor = UIColor(red: 33 / 255, green: 47 / 255, blue: 63 / 255, alpha: 1.0)
    let backColorNight: UIColor = UIColor(red: 24 / 255, green: 34 / 255, blue: 45 / 255, alpha: 1.0)
    
    let frontColorDay: UIColor = UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1.0)
    let backtColorDay: UIColor = UIColor(red: 239 / 255, green: 239 / 255, blue: 244 / 255, alpha: 1.0)
    
    let tintColorDay: UIColor = UIColor.black
    let tintColorNight: UIColor = UIColor.white
    
    let graphLabelsTextColorDay: UIColor = UIColor.black
    let graphLabelsTextColorNight: UIColor = UIColor.white
    let graphLineColorDay: UIColor!
    let graphLineNight: UIColor!
    
    let dateLabelColorDay: UIColor!
    let dateLabelColorNight: UIColor!
    
}
