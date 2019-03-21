//
//  DayInfo.swift
//  TelegramContestRomanov
//
//  Created by Филипп on 12.03.2019.
//  Copyright © 2019 Филипп. All rights reserved.
//

import Foundation


struct DayInfoUni {
    init(dateInt: Int, arrYValue: [Int]) {
        self.date = Date(timeIntervalSince1970: TimeInterval(dateInt))
        for el in arrYValue{
            arrY.append(el)
        }
    }
    let date: Date!
    var arrY: [Int] = []
}
