//
//  log.swift
//  BackgroundScanTest
//
//  Created by Andrey Bashkirtsev on 12.10.2023.
//

import Foundation
import SwiftyBeaver

class log: SwiftyBeaver {
    
    static let fileDest = FileDestination()
    
    static var logFileName: String {
        return "backgroundScan.log"
    }
    
    class func setupLogging() {
        self.setupSwiftyBeaver()
    }
    
    class func setupSwiftyBeaver() {
        let console = ConsoleDestination()
        let file = self.fileDest
        let url = try? FileManager.default.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: true)
        let fileURL = url?.appendingPathComponent(self.logFileName)

        file.logFileURL = fileURL
        
        console.format = "$DHH:mm:ss.SSS $C$d $T $N.$F:$l $L: $M$c"
        console.levelColor.verbose = ""
        console.levelColor.debug = ""
        console.levelColor.info = "📫"
        console.levelColor.warning = "⚠️"
        console.levelColor.error = "💥"
        console.minLevel = .debug
        SwiftyBeaver.addDestination(console)
        SwiftyBeaver.addDestination(file)
    }
}
