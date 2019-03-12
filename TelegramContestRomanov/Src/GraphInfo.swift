//
//  GraphInfo.swift
//  TelegramContestRomanov
//
//  Created by Филипп on 12.03.2019.
//  Copyright © 2019 Филипп. All rights reserved.
//

import UIKit

class GraphInfo {
    init(arrDayInfo: [DayInfoUni], arrLineName: [String], arrLineColor: [UIColor], nameX: String) {
        self.arrDayInfo = arrDayInfo
        self.arrLineName = arrLineName
        self.arrLineColor = arrLineColor
        self.nameX = nameX
    }
    var arrDayInfo: [DayInfoUni]!
    var arrLineName: [String]!
    var arrLineColor: [UIColor]!
    var nameX: String!
}
