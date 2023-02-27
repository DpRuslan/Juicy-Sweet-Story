import UIKit
import CoreData

final class MainViewController: UIViewController {
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var gameRulesButton: UIButton!
    @IBOutlet private weak var settingsButton: UIButton!
    @IBOutlet private weak var privacyPolicyButton: UIButton!
    private var myStoryboard: UIStoryboard?
    private var lockUnlock: [Bool] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveToCoreData()
        myStoryboard = UIStoryboard(name: "Main", bundle: nil)
        setFontTitle(button: playButton, title: "PLAY")
        setFontTitle(button: gameRulesButton, title: "GAME RULES")
        setFontTitle(button: settingsButton, title: "SETTINGS")
        setFontTitle(button: privacyPolicyButton, title: "PRIVACY POLICY")
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
        let vc = myStoryboard?.instantiateViewController(withIdentifier: "lvlsViewController") as! LvlsViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        let vc = myStoryboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: setFontTittle
extension MainViewController {
    func setFontTitle(button: UIButton, title: String) {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Knewave-Regular", size: 34) as Any
        ]
        
        let attributedStyle = NSAttributedString(string: title, attributes: attributes)
        button.setAttributedTitle(attributedStyle, for: .normal)
        button.backgroundColor = UIColor(red: 173/255, green: 27/255, blue: 141/255, alpha: 1)
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 5
        button.layer.borderColor = UIColor.white.cgColor
    }
}

// MARK: saveToCoreData
extension MainViewController {
    func saveToCoreData() {
        for i in 0...11 {
            if i == 0 {
                lockUnlock.append(true)
            } else {
                lockUnlock.append(false)
            }
        }
        
        do {
            if try AppDelegate.coreDataStack.managedContext.count(for: NSFetchRequest<Level>(entityName: "Level")) == 0 {
                for i in lockUnlock {
                    let newLevel = Level(context: AppDelegate.coreDataStack.managedContext)
                    newLevel.levelLockUnlock = i
                }
                try! AppDelegate.coreDataStack.managedContext.save()
            }
            
        } catch { }
    }
}
