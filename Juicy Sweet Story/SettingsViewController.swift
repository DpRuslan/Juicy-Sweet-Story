import UIKit

final class SettingsViewController: UIViewController {
    @IBOutlet private weak var settingsLabel: UILabel!
    @IBOutlet private weak var soundButton: UIButton!
    @IBOutlet private weak var vibroButton: UIButton!
    @IBOutlet private weak var rateUsButton: UIButton!
    @IBOutlet private weak var soundImage: UIImageView!
    @IBOutlet private weak var vibroImage: UIImageView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vibroImage.image = UIImage(named: "CHECKBOX")
        soundImage.image = UIImage(named: "CHECKBOX")
        
        setTitleFont(button: soundButton, title: "SOUND")
        setTitleFont(button: vibroButton, title: "VIBRO")
        setTitleFont(button: rateUsButton, title: "RATE US")
        
        let attributesForLabels: [NSAttributedString.Key : Any] = [
            .strokeWidth: -12.0,
            .strokeColor: UIColor(red: 173/255, green: 27/255, blue: 141/255, alpha: 1),
            .foregroundColor: UIColor.white
        ]
        
        settingsLabel.attributedText = NSAttributedString(string: "SETTINGS", attributes: attributesForLabels)
        settingsLabel.font = UIFont(name: "Knewave-Regular", size: 34)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func soundButtonPressed(_ sender: Any) {
        soundImage.image = (soundImage.image == UIImage(named: "CHECKBOX")) ?  UIImage(named: "CHECKBOX-4") : UIImage(named: "CHECKBOX")
    }
    
    @IBAction func vibroButtonPressed(_ sender: Any) {
        vibroImage.image = (vibroImage.image == UIImage(named: "CHECKBOX")) ?  UIImage(named: "CHECKBOX-4") : UIImage(named: "CHECKBOX")
    }
    
    @IBAction func rateUsButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Do you like to play our game?", message: "Tap a star to rate it on the App Store", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        alert.addAction(UIAlertAction(title: "Submit", style: .default))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: setTitleFont
extension SettingsViewController {
    private func setTitleFont(button: UIButton, title: String) {
        let attributesForButtons: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Knewave-Regular", size: 34) as Any
        ]

        let myAttributedStyle = NSAttributedString(string: title, attributes: attributesForButtons)
        button.setAttributedTitle(myAttributedStyle, for: .normal)
        button.backgroundColor = UIColor(red: 173/255, green: 27/255, blue: 141/255, alpha: 1)
        button.layer.cornerRadius = 25
        button.layer.borderWidth = 5
        button.layer.borderColor = UIColor.white.cgColor
    }
}
