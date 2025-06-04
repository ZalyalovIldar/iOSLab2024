import UIKit

class ViewController: UIViewController {
    
    var networkManager = NetworkManager()
    
    lazy var mainView: UIView = {
        let mainView = MainView()
        mainView.changePhotoDelegate = self
        return mainView
    }()
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ViewController: changePhotoDelegate {
    func changePhoto() async -> Data {
        do {
            let url = try await networkManager.getRandomFoxImageUrl()
            let data = try await networkManager.fetchRandomFoxImage(url: url)
            return data
        } catch {
            print("Error fetching image: \(error.localizedDescription)")
            return Data()
        }
    }
}
