//
//  AAItemCell.swift
//  AAPageController
//
//  Created by cztv on 2019/8/12.
//

import UIKit

class AAItemCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func nib() -> UINib? {
        let bundle = Bundle.init(for: classForCoder())
        return UINib.init(nibName: .init(describing: classForCoder()), bundle: bundle)
    }
    
}
