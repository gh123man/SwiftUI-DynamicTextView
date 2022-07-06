//
//  File.swift
//  
//
//  Created by Brian Floersch on 7/5/22.
//

import Foundation
import SwiftUI

struct ContentView_Previews: PreviewProvider {
    
    static var texts: [(String, UIFont.TextStyle)] = {
        let data: [(String, UIFont.TextStyle)] = [
            ("Hi I am a small message", .subheadline),
            ("blah blah blah", .footnote),
            ("what is the meaning of life?", .headline),
            ("Why you do dis AAPL? Why does this have to be so hard - like really? Just make text rendering that works right the first time: apple.com", .body),
            ("you don't need to call me at 555-555-5555", .caption1),
            ("... I can smell you", .title3),
            ("This is a long thing to say. Nora is my cat and she likes to bite my feet. She doesn't have a job and sleeps all day. http://google.com", .title1),
            ("I am probably multiple lines (jk)", .largeTitle),
        ]
        return (0...50).map { _ in data }.flatMap { $0 }
    }()
    
    static var previews: some View {
        ScrollView {
            LazyVStack {
                ForEach(0..<texts.count, id: \.self) { i in
                    DynamicTextView(text: texts[i].0, fontStyle: texts[i].1)
                }
            }
        }
        .padding()
    }

}
