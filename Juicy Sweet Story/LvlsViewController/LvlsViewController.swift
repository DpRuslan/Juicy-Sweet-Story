import UIKit

final class LvlsViewController: UIViewController {
    @IBOutlet weak var lvlsBackgroundImage: UIImageView!
    @IBOutlet weak var lvlsLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var data: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .none
        
        lvlsBackgroundImage.image = UIImage(named: "image 5")
        let attributes: [NSAttributedString.Key : Any] = [.strokeWidth: -10.0, .strokeColor: UIColor(red: 173/255, green: 27/255, blue: 141/255, alpha: 1), .foregroundColor: UIColor.white]
        lvlsLabel.attributedText = NSAttributedString(string: "LEVELS", attributes: attributes)
        lvlsLabel.font = UIFont(name: "Knewave-Regular", size: 34)
        for i in 0...11 {
            let image = UIImage(named: "l_\(i)")!
            data.append(image)
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension LvlsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionView", for: indexPath) as! LvlsImagesCell
        cell.lvlsImages.image = data[indexPath.row]
        return cell
    }
}

extension LvlsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "GameLvl1ViewController") as! GameLvl1ViewController
            vc.imageChangeDelegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension LvlsViewController: ImageChangeLvlDelegate {
    func imageChange() {
        data[1] = UIImage(named: "u_2")!
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
