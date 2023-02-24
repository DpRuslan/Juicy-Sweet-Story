import UIKit

final class SettingsViewController: UIViewController {
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var vibroButton: UIButton!
    @IBOutlet weak var rateUsButton: UIButton!
    @IBOutlet weak var soundImage: UIImageView!
    @IBOutlet weak var vibroImage: UIImageView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attributesForButtons: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Knewave-Regular", size: 34) as Any
        ]
       
        vibroImage.image = UIImage(named: "CHECKBOX")
        soundImage.image = UIImage(named: "CHECKBOX")
        
        var myAttributedStyle = NSAttributedString(string: "SOUND", attributes: attributesForButtons)
        soundButton.setAttributedTitle(myAttributedStyle, for: .normal)
        soundButton.backgroundColor = UIColor(red: 173/255, green: 27/255, blue: 141/255, alpha: 1)
        soundButton.layer.cornerRadius = 25
        soundButton.layer.borderWidth = 5
        soundButton.layer.borderColor = UIColor.white.cgColor
        
        myAttributedStyle = NSAttributedString(string: "VIBRO", attributes: attributesForButtons)
        vibroButton.setAttributedTitle(myAttributedStyle, for: .normal)
        vibroButton.backgroundColor = UIColor(red: 173/255, green: 27/255, blue: 141/255, alpha: 1)
        vibroButton.layer.cornerRadius = 25
        vibroButton.layer.borderWidth = 5
        vibroButton.layer.borderColor = UIColor.white.cgColor
        
        myAttributedStyle = NSAttributedString(string: "RATE US", attributes: attributesForButtons)
        rateUsButton.setAttributedTitle(myAttributedStyle, for: .normal)
        rateUsButton.backgroundColor = UIColor(red: 173/255, green: 27/255, blue: 141/255, alpha: 1)
        rateUsButton.layer.cornerRadius = 25
        rateUsButton.layer.borderWidth = 5
        rateUsButton.layer.borderColor = UIColor.white.cgColor
        
        let attributesForLabels: [NSAttributedString.Key : Any] = [.strokeWidth: -12.0, .strokeColor: UIColor(red: 173/255, green: 27/255, blue: 141/255, alpha: 1), .foregroundColor: UIColor.white]
        settingsLabel.attributedText = NSAttributedString(string: "SETTINGS", attributes: attributesForLabels)
        settingsLabel.font = UIFont(name: "Knewave-Regular", size: 34)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func soundButtonPressed(_ sender: Any) {
        if soundImage.image == UIImage(named: "CHECKBOX") {
            soundImage.image = UIImage(named: "CHECKBOX-4")
        } else {
            soundImage.image = UIImage(named: "CHECKBOX")
        }
    }
    
    @IBAction func vibroButtonPressed(_ sender: Any) {
        if vibroImage.image == UIImage(named: "CHECKBOX") {
            vibroImage.image = UIImage(named: "CHECKBOX-4")
        } else {
            vibroImage.image = UIImage(named: "CHECKBOX")
        }
    }
    
    @IBAction func rateUsButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Do you like to play our game?", message: "Tap a star to rate it on the App Store", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        alert.addAction(UIAlertAction(title: "Submit", style: .default))
        present(alert, animated: true, completion: nil)
    }
}
