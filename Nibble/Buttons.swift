//
//  Buttons.swift
//  Standard Integration (Swift)
//
//  Created by Ben Guo on 4/25/16.
//  Copyright © 2016 Stripe. All rights reserved.
//

import UIKit
import Stripe

class HighlightingButton: UIButton {
    var highlightColor = UIColor(white: 0, alpha: 0.05)

    convenience init(highlightColor: UIColor) {
        self.init()
        self.highlightColor = highlightColor
    }

    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                self.backgroundColor = self.highlightColor
            } else {
                self.backgroundColor = UIColor.clear
            }
        }
    }
}

class BuyButton: HighlightingButton {
    var disabledColor = UIColor.lightGray
    var enabledColor = UIColor.white

    override var isEnabled: Bool {
        didSet {
            let color = isEnabled ? enabledColor : disabledColor
            self.setTitleColor(color, for: UIControlState())
            self.layer.borderColor = enabledColor.cgColor
            self.highlightColor = (color.withAlphaComponent(0.5))
        }
    }

    convenience init(enabled: Bool, theme: STPTheme) {
        self.init()
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 10
        self.setTitle("Confirm", for: UIControlState())
        self.disabledColor = theme.secondaryForegroundColor
        self.enabledColor = UIColor.white
        self.isEnabled = enabled
    }
}

class CancelButton: HighlightingButton {
    var disabledColor = UIColor.lightGray
    var enabledColor = UIColor.flatRed()
    
    override var isEnabled: Bool {
        didSet {
            let color = isEnabled ? enabledColor : disabledColor
            self.setTitleColor(color, for: UIControlState())
            self.layer.borderColor = color?.cgColor
            self.highlightColor = UIColor.flatRed()
        }
    }
    
    convenience init(enabled: Bool, theme: STPTheme) {
        self.init()
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 10
        self.setTitle("Cancel", for: UIControlState())
        self.disabledColor = UIColor.flatRed()
        self.enabledColor = UIColor.flatRed()
        self.isEnabled = enabled
    }
}

