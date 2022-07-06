
import Foundation
import CoreGraphics

extension NSAttributedString {
    func height(containerWidth: CGFloat) -> CGFloat {
        let rect = self.boundingRect(with: CGSize.init(width: containerWidth, height: CGFloat.greatestFiniteMagnitude),
                                                                 options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                                 context: nil)
        return ceil(rect.size.height)
    }
}
