//
//  NormalTableViewCell.swift
//  NewsLayout
//
//  Created by nmi on 2019/1/30.
//  Copyright © 2019 nmi. All rights reserved.
//

import UIKit

class NormalTableViewCell: UITableViewCell {

    @IBOutlet var title:UILabel!
    @IBOutlet var imagev:UIImageView!
    @IBOutlet var desc:UILabel!
    
    class func verticalSpace()->CGFloat
    {
        return 5 + 5
    }
    
    class func labelHeight()->CGFloat
    {
        return 20.5
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imagev.af_cancelImageRequest()
        imagev.image = nil
    }

}
