//
//  MainViewController.swift
//  BackgroundScanTest
//
//  Created by Andrey Bashkirtsev on 12.10.2023.
//

import Foundation
import UIKit
import CoreBluetooth

class MainViewController: UIViewController {
    
    // MARK: - Views
    
    lazy var stackView: UIStackView = {
        let item = UIStackView()
        item.translatesAutoresizingMaskIntoConstraints = false
        item.axis = .vertical
        item.spacing = 8
        
        return item
    }()
    
    lazy var startScanButton: CommonButton = {
        let item = CommonButton()
        item.setTitle("Start scan", for: .normal)
        item.translatesAutoresizingMaskIntoConstraints = false
        item.addTarget(self, action: #selector(self.startScanDidTap), for: .touchUpInside)
        
        return item
    }()
    
    lazy var selectedPeripheralLabel: CommonLabel = {
        let item = CommonLabel()
        item.translatesAutoresizingMaskIntoConstraints = false
        
        return item
    }()
    
    lazy var connectingStatusLabel: UILabel = {
        let item = CommonLabel()
        item.translatesAutoresizingMaskIntoConstraints = false
        
        return item
    }()
    
    lazy var stopScanButton: CommonButton = {
        let item = CommonButton()
        item.setTitle("Stop Scan", for: .normal)
        item.translatesAutoresizingMaskIntoConstraints = false
        item.addTarget(self, action: #selector(self.stopScanDidTap), for: .touchUpInside)
        
        return item
    }()
    
    lazy var connectButton: CommonButton = {
        let item = CommonButton()
        item.setTitle("Connect", for: .normal)
        item.translatesAutoresizingMaskIntoConstraints = false
        item.addTarget(self, action: #selector(self.connectDidTap), for: .touchUpInside)
        
        return item
    }()
    
    lazy var disconnectButton: CommonButton = {
        let item = CommonButton()
        item.translatesAutoresizingMaskIntoConstraints = false
        item.setTitle("Disconnect", for: .normal)
        item.addTarget(self, action: #selector(self.disconnectDidTap), for: .touchUpInside)
        
        return item
    }()
    
    lazy var discoveredTableView: UITableView = {
        let item = UITableView()
        item.translatesAutoresizingMaskIntoConstraints = false
        
        return item
    }()
    
    // MARK: - Properties
    
    let viewModel = MainViewModel()
    
    let peripheralNoNameValue: String = "unknown"
    let cellId: String = String(describing: DiscoveredPeripheralCell.self)
    
    // MARK: - Inits
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bind()
        self.setupLayout()
        self.configureUI()
    }
    
    // MARK: - Methods
    
    func bind() {
        self.viewModel.discoveredPeripheralsDidChanged = { value in
            DispatchQueue.main.async {
                self.discoveredPeripheralsDidChanged(values: value)
            }
        }
        self.viewModel.scanIsEnableDidChanged = { values in
            DispatchQueue.main.async {
                self.scanIsEnabledDidChanged(value: values)
            }
        }
        self.viewModel.selectedPeripheralDidChanged = { value in
            DispatchQueue.main.async {
                self.selectedPeripheralDidChanged(value: value)
            }
        }
        self.viewModel.connectingStatusDidChanged = { value in
            DispatchQueue.main.async {
                self.connectingStatusDidChanged(value: value)
            }
        }
    }
    
    func setupLayout() {
        self.view.addSubview(self.stackView)
        self.stackView.addArrangedSubview(self.startScanButton)
        self.stackView.addArrangedSubview(self.stopScanButton)
        self.stackView.addArrangedSubview(self.selectedPeripheralLabel)
        self.stackView.addArrangedSubview(self.connectButton)
        self.stackView.addArrangedSubview(self.disconnectButton)
        self.stackView.addArrangedSubview(self.connectingStatusLabel)
        self.stackView.addArrangedSubview(self.discoveredTableView)
        
        let insent: CGFloat = 16
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: insent),
            self.stackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -insent),
            self.stackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: insent),
            self.stackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -insent)
        ])
        
        let labelHeight: CGFloat = 32
        NSLayoutConstraint.activate([
            self.selectedPeripheralLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            self.connectingStatusLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        ])
        
        let buttonHeight: CGFloat = 42
        NSLayoutConstraint.activate([
            self.startScanButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            self.stopScanButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            self.connectButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            self.disconnectButton.heightAnchor.constraint(equalToConstant: buttonHeight),
        ])
    }
    
    func configureUI() {
        self.view.backgroundColor = .white
        self.scanIsEnabledDidChanged(value: self.viewModel.scanIsEnabled)
        self.selectedPeripheralDidChanged(value: self.viewModel.selectedPeripheral)
        self.connectingStatusDidChanged(value: self.viewModel.connectingStatus)
        self.configureTableView()
    }
    
    func configureTableView() {
        self.discoveredTableView.register(
            DiscoveredPeripheralCell.self,
            forCellReuseIdentifier: self.cellId
        )
        self.discoveredTableView.dataSource = self
        self.discoveredTableView.delegate = self
    }
    
    func getPeripheralDescription(peripheral: CBPeripheral?) -> String {
        if let peripheral {
            return String(
                format: "%@ %@",
                peripheral.name ?? self.peripheralNoNameValue,
                peripheral.identifier.uuidString
            )
        } else {
            return "Peripheral not selected"
        }
    }
    
    func getConnectingStatusDescription(status: ConnectingStatus) -> String {
        return String(format: "Connecting status: %@", status.description)
    }
    
    func configureConnectButton(status: ConnectingStatus, selectedPeripheral: CBPeripheral?) {
        self.connectButton.isEnabled = !status.isConnecting() && selectedPeripheral != nil
    }
    
    // MARK: - DidChanged
    
    func discoveredPeripheralsDidChanged(values: [CBPeripheral]) {
        self.discoveredTableView.reloadData()
    }
    
    func scanIsEnabledDidChanged(value: Bool) {
        self.startScanButton.isEnabled = !value
        self.stopScanButton.isEnabled = value
    }
    
    func selectedPeripheralDidChanged(value: CBPeripheral?) {
        self.configureConnectButton(
            status: self.viewModel.connectingStatus,
            selectedPeripheral: value
        )
        self.selectedPeripheralLabel.text = self.getPeripheralDescription(peripheral: value)
    }
    
    func connectingStatusDidChanged(value: ConnectingStatus) {
        self.configureConnectButton(
            status: value,
            selectedPeripheral: self.viewModel.selectedPeripheral
        )
        self.disconnectButton.isEnabled = value.isConnecting()
        self.connectingStatusLabel.text = self.getConnectingStatusDescription(status: value)
    }
    
    // MARK: - Actions
    
    @objc func startScanDidTap() {
        self.viewModel.startScan()
    }
    
    @objc func stopScanDidTap() {
        self.viewModel.stopScan()
    }
    
    @objc func connectDidTap() {
        self.viewModel.connect()
    }
    
    @objc func disconnectDidTap() {
        self.viewModel.disconnect()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension MainViewController: UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.discoveredPeripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.viewModel.discoveredPeripherals[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath)
        
        cell.textLabel?.text = self.getPeripheralDescription(peripheral: data)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let data = self.viewModel.discoveredPeripherals[indexPath.row]
        
        self.viewModel.selectedPeripheral = data
    }
}
