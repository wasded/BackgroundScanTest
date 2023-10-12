//
//  CommonLabel.swift
//  BackgroundScanTest
//
//  Created by Andrey Bashkirtsev on 12.10.2023.
//

import Foundation
import UIKit

class CommonLabel: UILabel {
    
    // MARK: - Properties
    
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
        self.backgroundColor = .systemPurple
        self.textColor = .white
        self.textAlignment = .center
    }
    
}
