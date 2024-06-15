//
//  ExpandedBottomSheet.swift
//  AppleMusicButtonSheet
//
//  Created by 鈴木楓香 on 2024/06/08.
//

import SwiftUI

struct ExpandedBottomSheet: View {
    @Binding var expandSheet: Bool
    var animation: Namespace.ID
    @State private var animateContent: Bool = false
    @State private var offsetY: CGFloat = 0
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            
            ZStack {
                RoundedRectangle(cornerRadius: animateContent ? deviceCornerRadius : 0, style: .continuous)
                    .fill(.ultraThickMaterial)
                    .overlay {
                        RoundedRectangle(cornerRadius: animateContent ? deviceCornerRadius : 0, style: .continuous)
                            .fill(.playlistGray)
                            .opacity(animateContent ? 1 : 0)
                    }
                    .overlay(alignment: .top) {
                        MusicInfo(expandSheet: $expandSheet, animation: animation)
                        // Diasbling Interaction
                            .allowsHitTesting(false)
                            .opacity(animateContent ? 0 : 1)
                    }
                    .matchedGeometryEffect(id: "BIGVIEW", in: animation)
                
                VStack(spacing: 15) {
                    Capsule()
                        .fill(.gray)
                        .frame(width: 40, height: 5)
                        .opacity(animateContent ? 1 : 0)
                        .offset(y: animateContent ? 0 : size.height)
                    
                    GeometryReader {
                        let size = $0.size
                        
                        Image(.lilac)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                    }
                    .matchedGeometryEffect(id: "LILAC", in: animation)
                    .frame(height: size.width - 50)
                    .padding(.vertical, size.height < 700 ? 10 : 30)
                    
                    // Player View
                    PlayerView(size)
                        .offset(y: animateContent ? 0 : size.height)
                }
                .padding(.top, safeArea.top + (safeArea.bottom == 0 ? 10 : 0))
                .padding(.bottom, safeArea.bottom == 0 ? 10 : safeArea.bottom)
                .padding(.horizontal, 25)
                .clipped()
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity,
                       alignment: .top)
            }
            .offset(y: offsetY)
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        let translationY = value.translation.height
                        offsetY = translationY > 0 ? translationY : 0
                    }).onEnded({ value in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            if value.translation.height > size.height * 0.4 {
                                expandSheet = false
                                animateContent = false
                            } else {
                                offsetY = .zero
                            }
                        }
                    })
            )
            .ignoresSafeArea(.container, edges: .all)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.35)) {
                animateContent = true
            }
        }
    }
    
    @ViewBuilder
    private func PlayerView(_ mainSize: CGSize) -> some View {
        GeometryReader {
            let size = $0.size
            let spacing = size.height * 0.04
            
            VStack(spacing: spacing) {
                VStack(spacing: spacing) {
                    HStack(alignment: .center, spacing: 15) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("ライラック")
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text("Mrs. GREEN APPLE")
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.white)
                                .padding(12)
                                .background {
                                    Circle()
                                        .fill(.ultraThinMaterial)
                                        .environment(\.colorScheme, .light)
                                }
                        }
                    }
                    
                    // Timing Indicator
                    Capsule()
                        .fill(.ultraThinMaterial)
                        .environment(\.colorScheme, .light)
                        .frame(height: 5)
                        .padding(.top, spacing)
                    
                    // Timing Label View
                    HStack {
                        Text("0:00")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Spacer(minLength: 0)
                        
                        Text("3:33")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .frame(height: size.height / 2.5, alignment: .top)
                
                // Playback Controls
                HStack(spacing: size.width * 0.18) {
                    Button {
                        
                    } label: {
                        Image(systemName: "backward.fill")
                        // Dynamic Sizing for Smaller to Larger iPhones
                            .font(size.height < 300 ? .title3 : .title)
                    }
                    
                    // Maiking Play/Pause Little Bigger
                    Button {
                        
                    } label: {
                        Image(systemName: "pause.fill")
                        // Dynamic Sizing for Smaller to Larger iPhones
                            .font(size.height < 300 ? .largeTitle : .system(size: 50))
                    }
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "forward.fill")
                        // Dynamic Sizing for Smaller to Larger iPhones
                            .font(size.height < 300 ? .title3 : .title)
                    }
                }
                .foregroundColor(.white)
                .frame(maxHeight: .infinity)
                
                // Volume & Other Controls
                VStack(spacing: spacing) {
                    HStack(spacing: 15) {
                        Image(systemName: "speaker.fill")
                            .foregroundColor(.gray)
                        
                        Capsule()
                            .fill(.ultraThinMaterial)
                            .environment(\.colorScheme, .light)
                            .frame(height: 5)
                        
                        Image(systemName: "speaker.wave.3.fill")
                            .foregroundColor(.gray)
                    }
                    
                    HStack(alignment: .top, spacing: size.width * 0.18) {
                        Button {
                            
                        } label: {
                            Image(systemName: "quote.bubble")
                                .font(.title2)
                        }
                        
                        VStack(spacing: 6) {
                            Button {
                                
                            } label: {
                                Image(systemName: "airpods.gen3")
                                    .font(.title2)
                            }
                            
                            Text("iJustine's Airpods")
                                .font(.caption)
                        }
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "list.bullet")
                                .font(.title2)
                        }
                    }
                    .foregroundColor(.white)
                    .blendMode(.overlay)
                    .padding(.top, spacing)
                }
                .frame(height: size.height / 2.5, alignment: .bottom)
            }
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}

extension View {
    var deviceCornerRadius: CGFloat {
        let key = "_displayCornerRadius"
        if let screen = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.screen {
            if let cornerRadius = screen.value(forKey: key) as? CGFloat {
                return cornerRadius
            }
        }
        return 0
    }
}
