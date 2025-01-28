import UIKit

class SlideViewController: UIViewController {
    
    var customView: SlideView {
        view as! SlideView
    }
    
    override func loadView() {
        super.loadView()
        view = SlideView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customView.setDismissAction(UIAction { _ in
            self.dismiss(animated: true)
        })
    }
}
