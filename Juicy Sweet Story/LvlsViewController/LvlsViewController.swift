import UIKit

final class LvlsViewController: UIViewController {
    @IBOutlet private weak var lvlsBackgroundImage: UIImageView!
    @IBOutlet private weak var lvlsLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    private var myStoryboard: UIStoryboard?
    private var data: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = createLayout()
        myStoryboard = UIStoryboard(name: "Main", bundle: nil)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .none
        
        lvlsBackgroundImage.image = UIImage(named: "image 5")
        setFontTitle(label: lvlsLabel, title: "LEVELS")
        setImages()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: UICollectionViewDataSource
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

// MARK: UICollectionViewDelegate
extension LvlsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: Finish It
        guard indexPath.row == 0 else {return}
        let vc = myStoryboard?.instantiateViewController(withIdentifier: "GameLvl1ViewController") as! GameLvl1ViewController
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: GameLvl1ViewControllerDelegate
extension LvlsViewController: GameLvl1ViewControllerDelegate {
    func imageChange() {
        data[1] = UIImage(named: "u_2")!
        // TODO: maybe self collection not sure
        collectionView.reloadData()
    }
}

// MARK: setFontTitle
extension LvlsViewController {
    func setFontTitle(label: UILabel, title: String) {
        let attributes: [NSAttributedString.Key : Any] = [
            .strokeWidth: -10.0,
            .strokeColor: UIColor(red: 173/255, green: 27/255, blue: 141/255, alpha: 1),
            .foregroundColor: UIColor.white
        ]
        
        label.attributedText = NSAttributedString(string: title, attributes: attributes)
        label.font = UIFont(name: "Knewave-Regular", size: 34)
    }
}

// MARK: setImages
extension LvlsViewController {
    func setImages() {
        for i in 0...11 {
            let image = UIImage(named: "l_\(i)")!
            data.append(image)
        }
    }
}

// MARK: createLayout
extension LvlsViewController {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.24)),
            subitem: item,count: 3
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
