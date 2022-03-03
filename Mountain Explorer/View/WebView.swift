//
//  WebView.swift
//  Mountain app
//
//  Created by Pavel Sharenda on 21.02.22.
//

import SwiftUI
import WebKit

struct WebViewUIView: UIViewRepresentable {
    var url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

struct WebView: View {
    @Environment(\.dismiss) var dismiss
    var url: URL
    
    var body: some View {
        WebViewUIView(url: url)
            .ignoresSafeArea()
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.blue)
                    }
                }
            }
    }
}
