import Foundation
import SwiftUI
import UIKit

struct WrappedUITextView: UIViewRepresentable {
    var text: NSAttributedString
    var fontStyle: UIFont.TextStyle
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        
        textView.attributedText = text
        textView.textColor = UIColor.label
        textView.font = UIFont.preferredFont(forTextStyle: fontStyle)
        
        // Link all data types
        textView.dataDetectorTypes = .all
        
        // Varios settings to make it immutable
        textView.isEditable = false
        textView.isSelectable = true
        textView.clipsToBounds = true
        textView.isScrollEnabled = false
        
        // This is important
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        // Remove useless padding so it fits in with other views
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textView.textContainer.lineFragmentPadding = 0
        
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = text
    }
    
}

struct HeightKey: PreferenceKey {
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout CGFloat, nextValue: () -> Value) {
        value += nextValue()
    }
}

struct DynamicTextView: View {
    
    let text: String
    var fontStyle: UIFont.TextStyle
    
    @State private var height: CGFloat
    
    init(text: String, fontStyle: UIFont.TextStyle) {
        self.text = text
        self.fontStyle = fontStyle
        
        // Get the initial height for a single line
        height = attributedString(for: "a", fontStyle: fontStyle)
            .height(containerWidth: CGFloat.infinity)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                makeView(text: text, geometry: geometry)
            }
            .background(GeometryReader {
                Color.clear
                    .preference(key: HeightKey.self,
                                value: $0.frame(in: .local).size.height)
            })
            .onPreferenceChange(HeightKey.self) { value in
                height = value
            }
        }
        .frame(height: height)
    }
    
    func makeView(text: String, geometry: GeometryProxy)  -> some View {
        let attr = attributedString(for: text, fontStyle: fontStyle)
        let h = attr.height(containerWidth: geometry.size.width)
        
        return WrappedUITextView(text: attr, fontStyle: fontStyle)
            .frame(width: geometry.size.width, height: h)
    }
    
    
}

func attributedString(for string: String, fontStyle: UIFont.TextStyle) -> NSAttributedString {
    let attributedString = NSMutableAttributedString(string: string)
    let range = NSMakeRange(0, (string as NSString).length)
    attributedString.addAttribute(.font, value: UIFont.preferredFont(forTextStyle: fontStyle), range: range)
    attributedString.addAttribute(.paragraphStyle, value: NSMutableParagraphStyle(), range: range)
    return attributedString
}

struct TextLabelWithHyperlink_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("above")
            DynamicTextView(text: "Lets go to google.com and http://dateit.io hello world", fontStyle: .body)
            Text("below")
        }
    }
}

