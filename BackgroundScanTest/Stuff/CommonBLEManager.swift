//
//  CommonBLEManager.swift
//  BackgroundScanTest
//
//  Created by Andrey Bashkirtsev on 12.10.2023.
//

import Foundation
import CoreBluetooth

protocol CommonBLEManagerDelegate: AnyObject {
    func didDiscover(peripheral: CBPeripheral)
    func didConnect(to peripheral: CBPeripheral)
    func didFailedConnect(to peripheral: CBPeripheral)
}

class CommonBLEManager: NSObject {
    
    // MARK: - Properties
    
    lazy var centralManager: CBCentralManager = {
        return CBCentralManager(
            delegate: self,
            queue: self.queue
        )
    }()
    
    let queue = DispatchQueue(label: "common_ble_manager_queue")
    
    weak var delegate: CommonBLEManagerDelegate?
    
    var connectingPeripheral: CBPeripheral?
    
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
    
    func connect(peripheral: CBPeripheral) {
        self.centralManager.connect(peripheral)
    }
    
    func scanIsEnabled() -> Bool {
        return self.centralManager.isScanning
    }
    
    func disconnect() {
        guard let connectingPeripheral else { return }
        
        self.centralManager.cancelPeripheralConnection(connectingPeripheral)
        self.connectingPeripheral = nil
    }
}

// MARK: - CBCentralManagerDelegate

extension CommonBLEManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
    }
    
    func centralManager(_: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any],
                        rssi RSSI: NSNumber) {
        self.delegate?.didDiscover(peripheral: peripheral)
    }
    
    func centralManager(_: CBCentralManager, didConnect peripheral: CBPeripheral) {
        self.delegate?.didConnect(to: peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, 
                        didFailToConnect peripheral: CBPeripheral,
                        error: Error?) {
        self.connectingPeripheral = nil
        self.delegate?.didFailedConnect(to: peripheral)
    }
}
