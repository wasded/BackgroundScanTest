//
//  BackgroundBLEManager.swift
//  BackgroundScanTest
//
//  Created by Andrey Bashkirtsev on 12.10.2023.
//

import Foundation
import CoreBluetooth

protocol BackgroundBLEManagerDelegate: AnyObject {
    func didDiscovered(peripheral: CBPeripheral)
}

class BackgroundBLEManager: NSObject {
    
    // MARK: - Properties
    
//    static let shared = BackgroundBLEManager()
    
    lazy var centralManager: CBCentralManager = {
        return CBCentralManager(
            delegate: self,
            queue: self.queue,
            options: [
                CBCentralManagerOptionRestoreIdentifierKey: "restore_id_123"
            ]
        )
    }()
    
    let queue = DispatchQueue(label: "background_ble_manager_queue")
    
    weak var delegate: BackgroundBLEManagerDelegate?
    
    // MARK: - Inits
    
    override init() {
        super.init()
        
        let _ = self.centralManager
    }
    
    // MARK: - Methods
    
    func scan(services: [CBUUID]) {
        self.centralManager.scanForPeripherals(withServices: services)
    }
    
    func stopScan() {
        self.centralManager.stopScan()
    }
    
    func scanIsEnabled() -> Bool {
        return self.centralManager.isScanning
    }
}

// MARK: - CBCentralManagerDelegate

extension BackgroundBLEManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
    }
    
    func centralManager(_: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any],
                        rssi RSSI: NSNumber) {
        self.delegate?.didDiscovered(peripheral: peripheral)
    }
    
    func centralManager(_: CBCentralManager, didConnect peripheral: CBPeripheral) {
    }
    
    func centralManager(_ central: CBCentralManager,
                        didFailToConnect peripheral: CBPeripheral,
                        error: Error?) {
    }
}
