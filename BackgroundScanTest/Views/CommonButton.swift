//
//  CommonButton.swift
//  BackgroundScanTest
//
//  Created by Andrey Bashkirtsev on 12.10.2023.
//

import Foundation
import UIKit

class CommonButton: UIButton {
    
    // MARK: - Properties
    
    override var isEnabled: Bool {
        didSet {
            if oldValue != self.isEnabled {
                self.isEnabledDidChanged(value: self.isEnabled)
            }
        }
    }
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.sharedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.sharedInit()
    }
    
    // MARK: - Methods
    
    func sharedInit() {
        self.titleLabel?.textColor = .black
        self.isEnabledDidChanged(value: self.isEnabled)
    }
    
    func isEnabledDidChanged(value: Bool) {
        self.backgroundColor = value ? .systemGreen : .systemGray
    }
}
