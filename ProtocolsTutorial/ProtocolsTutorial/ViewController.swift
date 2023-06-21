//
//  ViewController.swift
//  ProtocolsTutorial
//
//  Created by Victor Roldan on 4/09/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var stringSelectedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func open2ndScreenPressed(_ sender: Any) {
        let vc = VC2()
        vc.delegate = self
        navigationController?.present(vc, animated: true)
    }
    
    @IBAction func openListPressed(_ sender: Any) {
        let vc = PostsListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController : StringProtocol{
    func stringLeght(_ count: Int) {
        print("count", count)
    }
    
    func didSelectString(_ string: String) {
        stringSelectedLabel.text = string
    }
}

