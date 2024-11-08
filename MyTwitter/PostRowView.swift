import SwiftUI
import SDWebImageSwiftUI

struct PostRowView: View {
    var post: Post
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // User Avatar
            Image(systemName: "person.crop.circle")
                .resizable()
                .frame(width: 48, height: 48)
                .foregroundColor(.blue)
            
            // Post Content
            VStack(alignment: .leading, spacing: 4) {
                // Username
                Text(post.username)
                    .font(.headline)
                
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
