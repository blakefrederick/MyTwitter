// PostRowView.swift
import SwiftUI
import SDWebImageSwiftUI

struct PostRowView: View {
    var post: Post
    @Environment(\.openURL) var openURL

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // User Avatar
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 48, height: 48)
                .foregroundColor(.blue)
            
            // Post Content
            VStack(alignment: .leading, spacing: 4) {
                // Username as a link
                Text(post.username)
                    .font(.headline)
                    .foregroundColor(.blue)
                    .onTapGesture {
                        if let url = URL(string: post.username), UIApplication.shared.canOpenURL(url) {
                            openURL(url)
                        } else if let url = URL(string: "https://" + post.username), UIApplication.shared.canOpenURL(url) {
                            openURL(url)
                        }
                    }
                
                // Text
                Text(post.text)
                    .font(.body)
                    .lineLimit(nil)
                
                // Image
                if !post.imageUrl.isEmpty {
                    WebImage(url: URL(string: post.imageUrl))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 200)
                }
            }
        }
        .padding(.vertical, 8)
    }
}
