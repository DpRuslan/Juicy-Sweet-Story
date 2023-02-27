import UIKit
import CoreData

final class LvlsViewController: UIViewController {
    @IBOutlet private weak var lvlsBackgroundImage: UIImageView!
    @IBOutlet private weak var lvlsLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    private var myStoryboard: UIStoryboard?
    private var data: [Int: UIImage] = [:]
    private var valuesFromCoreData: [Int: Bool] = [:]
    private var objectsIdFromCoreData: [Int: NSManagedObjectID] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setImages()
        
        collectionView.collectionViewLayout = createLayout()
        myStoryboard = UIStoryboard(name: "Main", bundle: nil)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .none
        
        lvlsBackgroundImage.image = UIImage(named: "image 5")
        setFontTitle(label: lvlsLabel, title: "LEVELS")
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        
        //MARK: Just to stop program from going to 4 lvl cause I needed to do 3 lvls.
        if indexPath.row == 3 {return}
        
        
        if valuesFromCoreData[indexPath.row] == false {
            return
        } else {
            let lvlID = objectsIdFromCoreData[indexPath.row + 1]
            let vc = myStoryboard?.instantiateViewController(withIdentifier: "GameLvlViewController") as! GameLvlViewController
            vc.level = indexPath.row
            vc.lvlID = lvlID
            navigationController?.pushViewController(vc, animated: true)
        }
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
        let fetchRequest: NSFetchRequest<Level> = Level.fetchRequest()
        let items = try! AppDelegate.coreDataStack.managedContext.fetch(fetchRequest)
        for i in items {
            objectsIdFromCoreData.updateValue(i.objectID, forKey: Int(i.id))
            valuesFromCoreData.updateValue(i.levelLockUnlock, forKey: Int(i.id))
        }
        
        for i in valuesFromCoreData {
            if i.value == false {
                data[i.key] = UIImage(named: "l_\(i.key)")!
            } else {
                data[i.key] = UIImage(named: "u_\(i.key)")!
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
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
