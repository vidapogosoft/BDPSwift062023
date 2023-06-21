//
//  VC2.swift
//  ProtocolsTutorial
//
//  Created by Victor Roldan on 4/09/21.
//

import UIKit

protocol StringProtocol {
    func didSelectString(_ string : String)
    func stringLeght(_ count : Int)
}

class VC2: UIViewController {
    @IBOutlet weak var textField: UITextField!
    
    var delegate : StringProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func dismissButtonPressed(_ sender: Any) {
        delegate.stringLeght(textField.text!.count)
        delegate.didSelectString(textField.text!)
        dismiss(animated: true)
    }
}
