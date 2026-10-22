import AppKit
import CoreGraphics
import Foundation

let size = 1024
guard
    let context = CGContext(
        data: nil,
        width: size,
        height: size,
        bitsPerComponent: 8,
        bytesPerRow: size * 4,
        space: CGColorSpaceCreateDeviceRGB(),
        bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue
    )
else {
    fatalError("Unable to create the icon canvas.")
}

func color(_ hex: UInt32, alpha: CGFloat = 1) -> CGColor {
    CGColor(
        red: CGFloat((hex >> 16) & 0xFF) / 255,
        green: CGFloat((hex >> 8) & 0xFF) / 255,
        blue: CGFloat(hex & 0xFF) / 255,
        alpha: alpha
    )
}

let colorSpace = CGColorSpaceCreateDeviceRGB()
let gradient = CGGradient(
    colorsSpace: colorSpace,
    colors: [color(0x065F57), color(0x087F73), color(0x27C7B8)] as CFArray,
    locations: [0, 0.52, 1]
)!
context.drawLinearGradient(
    gradient,
    start: CGPoint(x: 0, y: size),
    end: CGPoint(x: size, y: 0),
    options: []
)

let logoInset: CGFloat = 72
let logoScale = (CGFloat(size) - (logoInset * 2)) / 100

func logoPoint(x: CGFloat, y: CGFloat) -> CGPoint {
    CGPoint(
        x: logoInset + (x * logoScale),
        y: CGFloat(size) - logoInset - (y * logoScale)
    )
}

func strokeSegment(from start: CGPoint, to end: CGPoint) {
    context.move(to: start)
    context.addLine(to: end)
    context.strokePath()
}

context.setLineWidth(11 * logoScale)
context.setLineCap(.round)
context.setLineJoin(.round)
context.setStrokeColor(color(0xFFFFFF))
strokeSegment(from: logoPoint(x: 16, y: 68), to: logoPoint(x: 84, y: 68))
strokeSegment(from: logoPoint(x: 74, y: 68), to: logoPoint(x: 74, y: 34))
strokeSegment(from: logoPoint(x: 50, y: 68), to: logoPoint(x: 50, y: 34))
strokeSegment(from: logoPoint(x: 26, y: 68), to: logoPoint(x: 26, y: 34))

guard let image = context.makeImage() else {
    fatalError("Unable to create the app icon image.")
}
let bitmap = NSBitmapImageRep(cgImage: image)
guard let png = bitmap.representation(using: .png, properties: [:]) else {
    fatalError("Unable to encode the app icon.")
}

let output = URL(fileURLWithPath: CommandLine.arguments.dropFirst().first ?? "SeulyIcon.png")
try png.write(to: output, options: .atomic)
print("Wrote \(output.path)")
