//
//  MainViewModel.swift
//  BackgroundScanTest
//
//  Created by Andrey Bashkirtsev on 12.10.2023.
//

import Foundation
import CoreBluetooth

enum ConnectingStatus: Equatable {
    case notConnected
    case connecting
    case connected
    case connectedAndSupportConnection
    
    var description: String {
        switch self {
        case .notConnected:
            return "not connected"
        case .connecting:
            return "connecting"
        case .connected:
            return "connected"
        case .connectedAndSupportConnection:
            return "connected and support connection"
        }
    }
    
    func isConnecting() -> Bool {
        switch self {
        case .notConnected:
            return false
        case .connected, .connecting, .connectedAndSupportConnection:
            return true
        }
    }
}

class MainViewModel {
    
    // MARK: - Properties
    
    let commonBLEManager = CommonBLEManager()
    let config = AppConfiguration.configuration
    
    var discoveredPeripherals: [CBPeripheral] {
        didSet {
            if oldValue != self.discoveredPeripherals {
                self.discoveredPeripheralsDidChanged(self.discoveredPeripherals)
            }
        }
    }
    var scanIsEnabled: Bool {
        didSet {
            if oldValue != self.scanIsEnabled {
                self.scanIsEnableDidChanged(self.scanIsEnabled)
            }
        }
    }
    var selectedPeripheral: CBPeripheral? {
        didSet {
            if oldValue != self.selectedPeripheral {
                self.selectedPeripheralDidChanged(self.selectedPeripheral)
            }
        }
    }
    var connectingStatus: ConnectingStatus {
        didSet {
            if oldValue != self.connectingStatus {
                self.connectingStatusDidChanged(self.connectingStatus)
            }
        }
    }
    
    var discoveredPeripheralsDidChanged: ([CBPeripheral]) -> Void = { _ in }
    var scanIsEnableDidChanged: (Bool) -> Void = { _ in }
    var selectedPeripheralDidChanged: (CBPeripheral?) -> Void = { _ in }
    var connectingStatusDidChanged: (ConnectingStatus) -> Void = { _ in }
    
    // MARK: - Inits
    
    init() {
        self.discoveredPeripherals = []
        self.scanIsEnabled = self.commonBLEManager.scanIsEnabled()
        self.connectingStatus = .notConnected
        
        self.commonBLEManager.delegate = self
    }
    
    // MARK: - Methods
    
    func startScan() {
        self.commonBLEManager.scan(
            services: self.config.commonScanUUIDS
        )
        
        self.scanIsEnabled = self.commonBLEManager.scanIsEnabled()
        self.discoveredPeripherals = []
    }
    
    func stopScan() {
        self.commonBLEManager.centralManager.stopScan()
        self.scanIsEnabled = self.commonBLEManager.scanIsEnabled()
    }
    
    func connect() {
        guard let selectedPeripheral else { return }
        
        self.connectingStatus = .connecting
        self.commonBLEManager.connect(peripheral: selectedPeripheral)
    }
    
    func disconnect() {
        self.commonBLEManager.disconnect()
        
        self.connectingStatus = .notConnected
    }
    
    func startSupportConnection() {
        
    }
    
    func stopSupportConnection() {
        
    }
}

// MARK: - CommonBLEManagerDelegate

extension MainViewModel: CommonBLEManagerDelegate {
    func didDiscover(peripheral: CBPeripheral) {
        if !self.discoveredPeripherals.contains(peripheral) {
            self.discoveredPeripherals.append(peripheral)
        }
    }
    
    func didConnect(to peripheral: CBPeripheral) {
        self.connectingStatus = .connected
    }
    
    func didFailedConnect(to peripheral: CBPeripheral) {
        self.connectingStatus = .notConnected
    }
}
