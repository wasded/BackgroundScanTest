//
//  BackgroundBLEManager.swift
//  BackgroundScanTest
//
//  Created by Andrey Bashkirtsev on 12.10.2023.
//

import Foundation
import CoreBluetooth
import OSLog

protocol BackgroundBLEManagerDelegate: AnyObject {
    func didDiscovered(peripheral: CBPeripheral, advData: [String: Any])
    func willRestore()
}

class BackgroundBLEManager: NSObject {
    
    // MARK: - Properties
    
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
        log.info("🍚 scan did start")
        self.centralManager.scanForPeripherals(withServices: services)
    }
    
    func stopScan() {
        log.info("🍚 scan did end")
        self.centralManager.stopScan()
    }
    
    func scanIsEnabled() -> Bool {
        return self.centralManager.isScanning
    }
}

// MARK: - CBCentralManagerDelegate

extension BackgroundBLEManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        var state: String = {
            switch central.state {
            case .poweredOn:
                return "poweredOn"
            case .poweredOff:
                return "poweredOff"
            case .resetting:
                return "resetting"
            case .unauthorized:
                return "unauthorized"
            case .unsupported:
                return "unsupported"
            case .unknown:
                return "unknown"
            }
        }()
        
        log.info("🍚 centralManagerDidUpdateState \(state)")
    }
    
    func centralManager(_: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any],
                        rssi RSSI: NSNumber) {
        os_log("👀 backgroundScan did discovered peripheral = \(peripheral), advData = \(advertisementData)")
        log.info("👀 backgroundScan did discovered peripheral = \(peripheral), advData = \(advertisementData)")
        self.delegate?.didDiscovered(peripheral: peripheral, advData: advertisementData)
    }
    
    func centralManager(_: CBCentralManager, didConnect peripheral: CBPeripheral) {
    }
    
    func centralManager(_ central: CBCentralManager,
                        didFailToConnect peripheral: CBPeripheral,
                        error: Error?) {
    }
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        log.info("🗿background scan will restore \(dict)")
    }
}
