//
//  BackgroundScanManager.swift
//  BackgroundScanTest
//
//  Created by Andrey Bashkirtsev on 12.10.2023.
//

import Foundation
import CoreBluetooth

class BackgroundScanManager {
    
    // MARK: - Properties
    
    static let shared = BackgroundScanManager()
    
    
    let bleManager = BackgroundBLEManager()
    let config = AppConfiguration.configuration
    
    // MARK: - Inits
    
    private init() {
        self.bleManager.delegate = self
    }
    
    // MARK: - Methods
    
    func startScan() {
        self.bleManager.scan(services: self.config.backgroundScanUUIDS)
    }
}

extension BackgroundScanManager: LifecycleDelegate {
    func enterBackground() {
    }
}

extension BackgroundScanManager: BackgroundBLEManagerDelegate {
    func didDiscovered(peripheral: CBPeripheral) {
        print(peripheral)
    }
}
