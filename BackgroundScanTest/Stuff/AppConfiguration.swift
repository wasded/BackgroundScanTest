//
//  AppConfiguration.swift
//  BackgroundScanTest
//
//  Created by Andrey Bashkirtsev on 12.10.2023.
//

import Foundation
import CoreBluetooth

class AppConfiguration {
    
    static let configuration = AppConfiguration.defaultModel()
    
    let backgroundScanUUIDS: [CBUUID]
    let commonScanUUIDS: [CBUUID]
    let backgroundScanStartDelay: TimeInterval
    
    init(backgroundScanUUIDS: [CBUUID], 
         commonScanUUIDS: [CBUUID],
         backgroundScanStartDelay: TimeInterval) {
        self.backgroundScanUUIDS = backgroundScanUUIDS
        self.commonScanUUIDS = commonScanUUIDS
        self.backgroundScanStartDelay = backgroundScanStartDelay
    }
    
    static func defaultModel() -> AppConfiguration {
        return AppConfiguration(
            backgroundScanUUIDS: [
                CBUUID(string: "330C5AD1-7261-4F06-B87C-0F6342365C2E"),
                CBUUID(string: "4c6607e0-2c3d-4fca-b201-0246773d6e9c")
            ],
            commonScanUUIDS: [
                CBUUID(string: "4c6607e0-2c3d-4fca-b201-0246773d6e9c")
            ],
            backgroundScanStartDelay: 30.0
        )
    }
}
