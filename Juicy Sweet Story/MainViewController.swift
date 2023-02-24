import UIKit

final class MainViewController: UIViewController {
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var gameRulesButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var privacyPolicyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Knewave-Regular", size: 34) as Any
        ]
        
        var myAttributedStyle = NSAttributedString(string: "PLAY", attributes: attributes)
        playButton.setAttributedTitle(myAttributedStyle, for: .normal)
        playButton.backgroundColor = UIColor(red: 173/255, green: 27/255, blue: 141/255, alpha: 1)
        playButton.layer.cornerRadius = 25
        playButton.layer.borderWidth = 5
        playButton.layer.borderColor = UIColor.white.cgColor
    
        myAttributedStyle = NSAttributedString(string: "GAMES RULES", attributes: attributes)
        gameRulesButton.setAttributedTitle(myAttributedStyle, for: .normal)
        gameRulesButton.backgroundColor = UIColor(red: 173/255, green: 27/255, blue: 141/255, alpha: 1)
        gameRulesButton.layer.cornerRadius = 25
        gameRulesButton.layer.borderWidth = 5
        gameRulesButton.layer.borderColor = UIColor.white.cgColor
        
        myAttributedStyle = NSAttributedString(string: "PRIVACY POLICY", attributes: attributes)
        privacyPolicyButton.setAttributedTitle(myAttributedStyle, for: .normal)
        privacyPolicyButton.backgroundColor = UIColor(red: 173/255, green: 27/255, blue: 141/255, alpha: 1)
        privacyPolicyButton.layer.cornerRadius = 25
        privacyPolicyButton.layer.borderWidth = 5
        privacyPolicyButton.layer.borderColor = UIColor.white.cgColor
        
        myAttributedStyle = NSAttributedString(string: "SETTINGS", attributes: attributes)
        settingsButton.setAttributedTitle(myAttributedStyle, for: .normal)
        settingsButton.backgroundColor = UIColor(red: 173/255, green: 27/255, blue: 141/255, alpha: 1)
        settingsButton.layer.cornerRadius = 25
        settingsButton.layer.borderWidth = 5
        settingsButton.layer.borderColor = UIColor.white.cgColor
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "lvlsViewController") as! LvlsViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}

