//
//  ViewController.swift
//  Smalltalk
//
//  Created by Anton Pryakhin on 25.11.2020.
//

import UIKit
import FirebaseFirestore

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textColor = .black
        label.center = view.center
        label.textAlignment = .center
        view.addSubview(label)

        let db = Firestore.firestore()
        db.collection("test").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                label.text = querySnapshot?.documents.first?.data()["text"] as? String
            }
        }
    }

}
