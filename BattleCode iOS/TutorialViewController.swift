//
//  TutorialViewController.swift
//  BattleCode iOS
//
//  Created by Matt Jackson on 3/18/22.
//

import Foundation
import UIKit

class TutorialViewController: GameViewController {
    @IBOutlet weak var tutorialSettingsButton: UIButton!
    @IBAction func tutorialSettingsButtonClick(_ sender: Any) {
        super.settingsButtonClick(sender)
    }
}
