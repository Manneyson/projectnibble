//
//  HUD.swift
//  Vibez
//
//  Created by Michael Rebello on 1/7/17.
//  Copyright © 2017 Michael Rebello. All rights reserved.
//

import JGProgressHUD
import UIKit

/// Convenience structure for using and displaying HUDs
class HUD {
    
    private var underlyingHUD: JGProgressHUD!

    // MARK: - Public
    
    /// Creates a loading HUD and displays it on the key window
    static func showLoading() -> HUD {
        return HUD()
    }
    
    /// Dismisses the HUD
    func dismiss() {
        self.underlyingHUD.dismiss(animated: true)
    }
    
    // MARK: - Lifecycle
    
    init() {
        self.underlyingHUD = JGProgressHUD(style: .dark)
        if let keyWindow = UIApplication.shared.keyWindow {
            self.underlyingHUD.show(in: keyWindow)
        }
    }
    
    deinit {
        self.dismiss()
    }
}
