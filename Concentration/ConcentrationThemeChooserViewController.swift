//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by jeffomidvaran on 3/25/20.
//  Copyright © 2020 jeffomidvaran. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate {
    /*
        all methods in UISplitViewControllerDelegate are optional
        it is an objective-c protocol
     */

    
    let themes = [
        "Sports": "⚽️🏀🏈⚾️🎾🏐🏉🎱🏓⛷🎳⛳️",
        "Animals": "🐶🐔🦊🐼🦀🐪🐓🐳🐙🦄🐵",
        "Faces": "😊😗🙃🙂😍🥰😘😗😙😟"
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("awake from nib called")
        splitViewController?.delegate = self
    }
    
    
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController
    ) -> Bool {
        if let cvc = secondaryViewController as? ConcentrationViewController {
            if cvc.theme == nil {
                return true // yes I did collapse it
            }
        }
        return false //  no I didn't collapse it
    }
    
    
    
    // USE WHEN YOU WANT CONDITIONAL SEQUES
    @IBAction func changeTheme(_ sender: Any) {
        if let cvc = splitViewDetailConcentrationViewController {
            // find and enter split view
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName]{
                cvc.theme = theme
            }
        } else if let cvc = lastSeguedToConcentrationViewController {
            // hold something in heap that get thrown off of the navigation stack
            // this is for an iPhone that does not have split view
            // it will save the game so that it does not start over every time a new
            // theme is choosen
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName]{
                cvc.theme = theme
            }
            // push on to a navigation stack without seguing
            navigationController?.pushViewController(cvc, animated: true)
        } else {
            // segue from code
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    var splitViewDetailConcentrationViewController: ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    // MARK: - Navigation
    private var lastSeguedToConcentrationViewController: ConcentrationViewController?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare called")
        if segue.identifier == "Choose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle , let theme = themes[themeName] {
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.theme = theme
                    lastSeguedToConcentrationViewController = cvc
                }
            }
        }
    }
}
