import UIKit
import Kingfisher

protocol imagesListCellDelegate: AnyObject {
    func imagesListCellDidTapLike(_ cell: ImagesListCell)
}
final class ImagesListCell: UITableViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
    }
    static let reuseIdentifier = "ImagesListCell"
    private let placeholderImage = UIImage(named: "placeholder")
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM YYYY"
        return dateFormatter
    }()
    weak var delegate: imagesListCellDelegate?
    
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var cellImage: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        UIView.animateKeyframes(withDuration: 1, delay: 0, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25, animations: {
                self.likeButton.transform = CGAffineTransform (scaleX: 1.5, y: 1.5)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25, animations: {
                self.likeButton.transform = .identity
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.25, animations: {
                self.likeButton.transform = CGAffineTransform (scaleX: 1.2, y: 1.2)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25, animations: {
                self.likeButton.transform = .identity
            })
        })
        
        delegate?.imagesListCellDidTapLike(self)
        
    }
}

extension ImagesListCell {
    func setIsLiked(_ isLiked: Bool) {
        let likedImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.setImage(likedImage, for: .normal)
    }
    
    func loadPhotos (from photo: Photo) -> Bool {
        var status = false
        
        if let photoDate = photo.createdAt {
            dateLabel.text = dateFormatter.string(from: photoDate)
        } else {
            dateLabel.text = ""
        }
        
        setIsLiked(photo.isLiked)

        guard let photoUrl = URL(string: photo.thumbImageURL) else {return status}
        
        cellImage.kf.indicatorType = .activity
        cellImage.kf.setImage(with: photoUrl, placeholder: placeholderImage) {[weak self] result in
            guard let self else {return}
            switch result {
            case .success(_):
                status = true
            case .failure(let error):
                cellImage.image = placeholderImage
                debugPrint("Error: \(error.localizedDescription)")
            }
        }
        return status
    }
}
