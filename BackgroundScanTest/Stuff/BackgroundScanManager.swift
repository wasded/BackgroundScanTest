//
//  BackgroundScanManager.swift
//  BackgroundScanTest
//
//  Created by Andrey Bashkirtsev on 12.10.2023.
//

import Foundation
import CoreBluetooth
import UIKit

class BackgroundScanManager {
    
    // MARK: - Properties
    
    static let shared = BackgroundScanManager()
    
    let bleManager = BackgroundBLEManager()
    let config = AppConfiguration.configuration
    
    // MARK: - Inits
    
    private init() {
        (UIApplication.shared.delegate as! AppDelegate).delegate = self
        self.bleManager.delegate = self
    }
    
    // MARK: - Methods
    
    func startScan() {
        self.bleManager.scan(services: self.config.backgroundScanUUIDS)
    }
    
    func stopScan() {
        self.bleManager.stopScan()
    }
}

extension BackgroundScanManager: LifecycleDelegate {
    func enterForeground() {
        self.stopScan()
    }
    
    func didFinishLaunching() {
        self.stopScan()
    }
    
    func enterBackground() {
        self.startScan()
    }
}

extension BackgroundScanManager: BackgroundBLEManagerDelegate {
    func willRestore() { }
    
    func didDiscovered(peripheral: CBPeripheral, advData: [String: Any]) { }
}
