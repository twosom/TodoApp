//
// Created by Desire L on 2021/12/19.
//

import UIKit

class TodoCell: UITableViewCell {

    @IBOutlet
    var topTitleLabel: UILabel!

    @IBOutlet
    var priorityView: UIView! {
        didSet {
            priorityView.layer.cornerRadius = priorityView.bounds.height / 2
        }
    }

    @IBOutlet
    var dateLabel: UILabel!


}
