import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    func req() async {
        let response = await AF.request("https://httpbin.org/get", interceptor: .retryPolicy)
                               .authenticate(username: "user", password: "pass")
                               .cacheResponse(using: .cache)
                               .redirect(using: .follow)
                               .validate()
                               .cURLDescription { description in
                                 print(description)
                               }
        print(response)
    }
}

